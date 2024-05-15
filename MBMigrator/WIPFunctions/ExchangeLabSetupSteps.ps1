$subscriptionID = ''
#https://docs.microsoft.com/en-us/Exchange/plan-and-deploy/deploy-new-installations/create-azure-test-environments?view=exchserver-2016
# Set up key variables
$subscrID = "7165af79-8fd7-4167-8d04-763aed9831d1"
$rgName = "Exchange2013Lab"
$saName = 'exchange2013lab'
$locName = 'eastus2'
$exSubnetName = 'ExServerSubnet'
$exVNetName = 'EXServerVNet'
$adVMNICName = 'adVM-Nic'
$adVMName = 'adVM'
$exvmName = "exVM"
$adVMSize = 'Standard_D1_v2'
$exVMSize = "Standard_D3_v2"
$EXvmDNSName = "wirelessoneonline"
Connect-AzAccount
Select-AzSubscription -Subscription $SubscriptionID
New-AzResourceGroup -Name $rgName -Location $locName
New-AzStorageAccount -Name $saName -ResourceGroupName $rgName -Type Standard_LRS -Location $locName
$exSubnet = New-AzVirtualNetworkSubnetConfig -Name $exSubnetName -AddressPrefix 10.0.0.0/24
New-AzVirtualNetwork -Name $exVNetName -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $exSubnet -DNSServer 10.0.0.4
#$rule1 = New-AZNetworkSecurityRuleConfig -Name "RDPTraffic" -Description "Allow RDP to all VMs on the subnet" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
#$rule2 = New-AZNetworkSecurityRuleConfig -Name "ExchangeSecureWebTraffic" -Description "Allow HTTPS to the Exchange server" -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix "10.0.0.5/32" -DestinationPortRange 443
New-AzNetworkSecurityGroup -Name $exSubnetName -ResourceGroupName $rgName -Location $locName #-SecurityRules $rule1, $rule2
$vnet = Get-AzVirtualNetwork -ResourceGroupName $rgName -Name $exVNetName
$nsg = Get-AzNetworkSecurityGroup -Name $exSubnetName -ResourceGroupName $rgName
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $exSubnetName -AddressPrefix "10.0.0.0/24" -NetworkSecurityGroup $nsg
$vnet | Set-AzVirtualNetwork

# Create an availability set for domain controller virtual machines
New-AzAvailabilitySet -ResourceGroupName $rgName -Name adAvailabilitySet -Location $locName -Sku Aligned  -PlatformUpdateDomainCount 5 -PlatformFaultDomainCount 2
# Create the domain controller virtual machine
$vnet = Get-AzVirtualNetwork -ResourceGroupName $rgName -Name $exVNetName
$pip = New-AzPublicIpAddress -Name $adVMNICName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name $adVMNICName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress 10.0.0.4
$avSet = Get-AzAvailabilitySet -Name adAvailabilitySet -ResourceGroupName $rgName
$vm = New-AzVMConfig -VMName $adVMName -VMSize $adVMSize -AvailabilitySetId $avSet.Id
$vm = Set-AzVMOSDisk -VM $vm -Name 'adVM-OS' -DiskSizeInGB 128 -CreateOption FromImage -StorageAccountType "Standard_LRS"
$diskConfig = New-AzDiskConfig -AccountType "Standard_LRS" -Location $locName -CreateOption Empty -DiskSizeGB 20
$dataDisk1 = New-AzDisk -DiskName 'adVM-DataDisk1' -Disk $diskConfig -ResourceGroupName $rgName
$vm = Add-AzVMDataDisk -VM $vm -Name 'adVM-DataDisk1' -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1
$cred = Get-Credential -Message "Type the name and password of the local administrator account for adVM."
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName adVM -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $vm
# Create the Exchange virtual machine
Test-AzDnsAvailability -DomainQualifiedName $EXvmDNSName -Location $locName

# Create an availability set for Exchange virtual machines
New-AzAvailabilitySet -ResourceGroupName $rgName -Name exAvailabilitySet -Location $locName -Sku Aligned  -PlatformUpdateDomainCount 5 -PlatformFaultDomainCount 2
# Specify the virtual machine name and size
$avSet = Get-AzAvailabilitySet -Name exAvailabilitySet -ResourceGroupName $rgName
$exvm = New-AzVMConfig -VMName $exvmName -VMSize $exvmSize -AvailabilitySetId $avSet.Id
# Create the NIC for the virtual machine
$nicName = $exvmName + "-NIC"
$pipName = $exvmName + "-PublicIP"
$pip = New-AzPublicIpAddress -Name $pipName -ResourceGroupName $rgName -DomainNameLabel $EXvmDNSName -Location $locName -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress "10.0.0.5"
# Create and configure the virtual machine
$exvm = Set-AzVMOSDisk -VM $exvm -Name ($exvmName + "-OS") -DiskSizeInGB 128 -CreateOption FromImage -StorageAccountType "Standard_LRS"
$exvm = Set-AzVMOperatingSystem -VM $exvm -Windows -ComputerName $exvmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$exvm = Set-AzVMSourceImage -VM $exvm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$exvm = Add-AzVMNetworkInterface -VM $exvm -Id $nic.Id
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $exvm

#save $

Stop-AzVM -Name $exvmName -ResourceGroupName $rgName -Force
Stop-AzVM -Name $adVMName -ResourceGroupName $rgName -Force

#spend $

Start-AzVM -Name $adVMName -ResourceGroupName $rgName
Start-AzVM -Name $exvmName -ResourceGroupName $rgName
