[CmdletBinding()]
param(
    [switch]$SimulateLowSpace
)

$threshold = 15
$testMode = [bool]$SimulateLowSpace

if ($SimulateLowSpace) {
    $freeGB = 5
}
else {
    $drive = Get-PSDrive -Name C
    $freeGB = [math]::Round($drive.Free / 1GB, 2)
}

if ($freeGB -lt $threshold) {
    $status = "LOW_DISK_SPACE"
    $severity = "HIGH"
}
else {
    $status = "HEALTHY"
    $severity = "NONE"
}

$result = [PSCustomObject]@{
    Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Drive       = "C:"
    FreeGB      = $freeGB
    ThresholdGB = $threshold
    Status      = $status
    Severity    = $severity
    TestMode    = $testMode
}

$logPath = Join-Path $PSScriptRoot "disk-space-log.csv"
$result | Export-Csv -LiteralPath $logPath -Append -NoTypeInformation -Encoding UTF8

$result | Format-List | Out-Host
$result
