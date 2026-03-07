[CmdletBinding()]
param(
    [string]$Destination = "C:\matt\WEBSITES\matthewemery-pages",
    [switch]$Stage,
    [string]$CommitMessage,
    [switch]$Push
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$exportScript = Join-Path $repoRoot "scripts\export-pages.ps1"
$publicFiles = @("index.html", "styles.css", "this.jpg")
$destinationPath = (Resolve-Path -LiteralPath $Destination -ErrorAction SilentlyContinue)?.Path

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $output = & git -C $destinationPath @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed in '$destinationPath': $($output -join [Environment]::NewLine)"
    }

    return @($output)
}

if (-not (Test-Path -LiteralPath $exportScript)) {
    throw "Publish requires export script '$exportScript'."
}

if (-not $destinationPath) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    $destinationPath = (Resolve-Path -LiteralPath $Destination).Path
}

if (-not (Test-Path -LiteralPath (Join-Path $destinationPath ".git"))) {
    throw "Destination '$destinationPath' is not a Git repository."
}

& $exportScript -Destination $destinationPath

$keep = @(".git") + $publicFiles
Get-ChildItem -LiteralPath $destinationPath -Force | Where-Object { $keep -notcontains $_.Name } | Remove-Item -Recurse -Force

$statusOutput = Invoke-Git -Arguments @("status", "-sb")
$statusOutput | ForEach-Object { Write-Host $_ }

if ($Stage.IsPresent) {
    Invoke-Git -Arguments @("add", "-A") | Out-Null
}

if ($CommitMessage) {
    $stagedChanges = @(Invoke-Git -Arguments @("diff", "--cached", "--name-only"))
    if ($stagedChanges.Count -eq 0) {
        throw "Commit message was provided, but there are no staged changes to commit."
    }

    Invoke-Git -Arguments @("commit", "-m", $CommitMessage) | Out-Null
}

if ($Push.IsPresent) {
    $branchName = (Invoke-Git -Arguments @("rev-parse", "--abbrev-ref", "HEAD") | Select-Object -First 1).Trim()
    Invoke-Git -Arguments @("push", "origin", $branchName) | Out-Null
}
