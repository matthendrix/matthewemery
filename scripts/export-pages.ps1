[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Destination
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$destinationPath = (Resolve-Path -LiteralPath $Destination -ErrorAction SilentlyContinue)?.Path

if (-not $destinationPath) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    $destinationPath = (Resolve-Path -LiteralPath $Destination).Path
}

$publicFiles = @("index.html", "styles.css", "this.jpg")

foreach ($file in $publicFiles) {
    $sourcePath = Join-Path $repoRoot $file
    $targetPath = Join-Path $destinationPath $file

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Required public file '$file' was not found at '$sourcePath'."
    }

    if (Test-Path -LiteralPath $targetPath) {
        Remove-Item -LiteralPath $targetPath -Force
    }

    Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
}

Write-Host "Exported public site files to $destinationPath"
$publicFiles | ForEach-Object { Write-Host " - $_" }
