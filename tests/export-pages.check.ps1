$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$exportScript = Join-Path $repoRoot "scripts\export-pages.ps1"
$destination = Join-Path ([System.IO.Path]::GetTempPath()) ("matthewemery-pages-export-" + [System.Guid]::NewGuid().ToString("N"))

try {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null

    & $exportScript -Destination $destination

    $expectedFiles = @("index.html", "styles.css", "this.jpg")
    $actualFiles = Get-ChildItem -Path $destination -File | Select-Object -ExpandProperty Name | Sort-Object

    $expectedList = @($expectedFiles | Sort-Object)
    $actualList = @($actualFiles | Sort-Object)

    if (($actualList -join "|") -ne ($expectedList -join "|")) {
        throw "Expected exported files '$($expectedFiles -join ", ")' but found '$($actualFiles -join ", ")'."
    }

    $blockedPaths = @("docs", "legacy", "AGENTS.md", "CLAUDE.md")
    foreach ($blockedPath in $blockedPaths) {
        if (Test-Path (Join-Path $destination $blockedPath)) {
            throw "Blocked path '$blockedPath' was exported."
        }
    }

    foreach ($file in $expectedFiles) {
        $sourceHash = (Get-FileHash -Path (Join-Path $repoRoot $file) -Algorithm SHA256).Hash
        $exportedHash = (Get-FileHash -Path (Join-Path $destination $file) -Algorithm SHA256).Hash

        if ($sourceHash -ne $exportedHash) {
            throw "Hash mismatch for '$file'."
        }
    }

    Write-Host "PASS: export-pages verification succeeded."
}
finally {
    if (Test-Path $destination) {
        Remove-Item -Path $destination -Recurse -Force
    }
}
