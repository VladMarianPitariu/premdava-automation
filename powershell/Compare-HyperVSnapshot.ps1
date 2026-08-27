[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SnapshotRoot,

    [Parameter(Mandatory = $true)]
    [string]$HyperVHost
)

$ErrorActionPreference = 'Stop'
$snapshotDirectory = Join-Path $SnapshotRoot $HyperVHost
$latestPath = Join-Path $snapshotDirectory 'latest.json'
$previousPath = Join-Path $snapshotDirectory 'previous.json'
$reportPath = Join-Path $snapshotDirectory 'last-drift-report.json'

if (-not (Test-Path -LiteralPath $latestPath)) {
    throw "No current snapshot found: $latestPath"
}

$current = Get-Content -Raw -LiteralPath $latestPath | ConvertFrom-Json

if (-not (Test-Path -LiteralPath $previousPath)) {
    Copy-Item -LiteralPath $latestPath -Destination $previousPath
    [ordered]@{
        hyperv_host = $HyperVHost
        status = 'baseline_created'
        differences = @()
        compared_at_utc = [DateTime]::UtcNow.ToString('o')
    } | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding UTF8
    Write-Output "Baseline created: $previousPath"
    exit 0
}

$previous = Get-Content -Raw -LiteralPath $previousPath | ConvertFrom-Json
$currentComparable = $current | Select-Object * -ExcludeProperty captured_at_utc
$previousComparable = $previous | Select-Object * -ExcludeProperty captured_at_utc
$currentJson = $currentComparable | ConvertTo-Json -Depth 8 -Compress
$previousJson = $previousComparable | ConvertTo-Json -Depth 8 -Compress
$changed = $currentJson -cne $previousJson

$status = if ($changed) { 'drift_detected' } else { 'no_change' }
$report = [ordered]@{
    hyperv_host = $HyperVHost
    status = $status
    compared_at_utc = [DateTime]::UtcNow.ToString('o')
    previous_snapshot = $previousPath
    current_snapshot = $latestPath
    differences = if ($changed) { @('Configuration differs from previous hourly snapshot') } else { @() }
}
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding UTF8

if ($changed) {
    Write-Warning "Configuration drift detected for $HyperVHost"
} else {
    Write-Output "No configuration drift detected for $HyperVHost"
}

Move-Item -LiteralPath $latestPath -Destination $previousPath -Force
