[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SnapshotRoot,

    [Parameter(Mandatory = $true)]
    [string]$HyperVHost
)

$ErrorActionPreference = 'Stop'
$snapshotDirectory = Join-Path $SnapshotRoot $HyperVHost
New-Item -ItemType Directory -Path $snapshotDirectory -Force | Out-Null

$snapshot = [ordered]@{
    schema_version = 1
    hyperv_host = $HyperVHost
    captured_at_utc = [DateTime]::UtcNow.ToString('o')
    host = [ordered]@{
        computer_name = $env:COMPUTERNAME
        os_caption = (Get-CimInstance Win32_OperatingSystem).Caption
        logical_processors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
        memory_bytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    }
    switches = @(Get-VMSwitch |
        Sort-Object Name |
        Select-Object Name, SwitchType, NetAdapterName, AllowManagementOS)
    vms = @(Get-VM |
        Sort-Object Name |
        Select-Object Name, State, Status, CPUCount, MemoryStartup, AutomaticStartAction, AutomaticStopAction)
    adapters = @(Get-VMNetworkAdapter -All |
        Sort-Object VMName, Name |
        Select-Object VMName, Name, SwitchName, Status, IPAddresses, MacAddress)
}

$latestPath = Join-Path $snapshotDirectory 'latest.json'
$temporaryPath = "$latestPath.tmp"
$snapshot | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
Move-Item -LiteralPath $temporaryPath -Destination $latestPath -Force
Write-Output "Snapshot written: $latestPath"
