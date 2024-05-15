$WShell = New-Object -com “Wscript.Shell”

while ($true) { 

	$WShell.sendkeys(“{SCROLLLOCK}”)

	Write-Host "Feeling Sleepy"

	Start-Sleep -Milliseconds 100

	Write-Host "Waking Up"

	$WShell.sendkeys(“{SCROLLLOCK}”)

	Start-Sleep -Seconds 240

	Write-Host "Humming Along"

}