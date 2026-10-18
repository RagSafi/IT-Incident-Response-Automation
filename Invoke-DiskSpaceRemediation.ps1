[CmdletBinding()]
param(
    [switch]$Preview,
    [switch]$LabSimulation
)

$ErrorActionPreference = "Stop"

$thresholdGB = 15
$targetPath = Join-Path $PSScriptRoot "Test-Lab"
$logPath = Join-Path $PSScriptRoot "remediation-log-automated.csv"
$cutoffDate = (Get-Date).AddDays(-7)

# Safety check: only allow the dedicated test folder
$expectedPath = [System.IO.Path]::GetFullPath(
    (Join-Path $PSScriptRoot "Test-Lab")
)
$actualPath = [System.IO.Path]::GetFullPath($targetPath)

if ($actualPath -ne $expectedPath -or
    -not (Test-Path -LiteralPath $targetPath -PathType Container)) {
    throw "Safety check failed. Test-Lab folder is required."
}

$drive = Get-PSDrive -Name C
$freeBeforeGB = [math]::Round($drive.Free / 1GB, 2)

Write-Host "=== Disk Remediation Lab ===" -ForegroundColor Cyan
Write-Host "Free space before: $freeBeforeGB GB"
Write-Host "Target: $targetPath"

if ($freeBeforeGB -ge $thresholdGB -and -not $LabSimulation) {
    Write-Host "Disk status: HEALTHY" -ForegroundColor Green
    Write-Host "No remediation required. No files will be processed."
    return
}

if ($LabSimulation) {
    Write-Host "Lab simulation enabled. Only Test-Lab files may be processed." -ForegroundColor Yellow
}

$files = @(
    Get-ChildItem -LiteralPath $targetPath -File -Recurse |
    Where-Object { $_.LastWriteTime -lt $cutoffDate }
)

$processed = 0
$deleted = 0
$failed = 0

foreach ($file in $files) {
    $action = "Preview"
    $details = "No deletion performed"

if (-not $Preview -and $LabSimulation) {
        try {
            Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
            $action = "Deleted"
            $details = "Deletion successful"
            $deleted++
        }
        catch {
            $action = "Failed"
            $details = $_.Exception.Message
            $failed++
        }
    }

    [PSCustomObject]@{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        File      = $file.FullName
        Action    = $action
        Details   = $details
        Preview   = [bool]$Preview
    } | Export-Csv -LiteralPath $logPath -Append -NoTypeInformation -Encoding UTF8

    $processed++
}

$remainingOldFiles = @(
    Get-ChildItem -LiteralPath $targetPath -File -Recurse |
    Where-Object { $_.LastWriteTime -lt $cutoffDate }
).Count

Write-Host "Eligible files: $($files.Count)"
Write-Host "Processed: $processed"
Write-Host "Deleted: $deleted"
Write-Host "Failed: $failed"
Write-Host "Old files remaining: $remainingOldFiles"
Write-Host "Audit log: $logPath"