- [ ] Export-ADUser - What if user adds file name to OutputFolderPath?
- [ ] Mike - Review ExchangeOnline switch in Export-ExchangeConfiguration Potential code reduction removing $Servers
- [ ] Need explanation of Export-MBMReport and MBMConfiguration
  - [ ] Potenial conversion of $report to Switch params? Or at least improved validtion set names
- [ ] Get-DistributionGroupMessageTrace needs longer description
- [ ] Get-MBMMigrationList $filterpath validate update to *.xl* ?
- [ ] Create function: switch-wavemoverequestcredential
- [ ] Export-MBMReport -CompoundReport has Validate set, but only one possible set. Change to switch or develop further
- [ ] Updated Get-MBMWaveMoveRequest to include param sets.
- [ ] Several of the get-wave... functions don't have mandatory params, including -wave
- [ ] Functions seem to rely on Get-Variable functions like Get-WaveMoveRequestVariableValue but no messaging currently exists to explain which function to run to create the variables those functions rely on
- [ ] Reset-WaveMoveRequest params unclear. Missing mandatorys and some confusion on Wave vs WaveMembers compared to other functions in the module
- [ ] Complete Update-MBMDatabaseSchema. Currently only param does nothing