$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$publishScript = Join-Path $repoRoot "scripts\publish-pages.ps1"
$expectedFiles = @("index.html", "styles.css", "this.jpg")
$blockedPaths = @("docs", "legacy", "AGENTS.md", "CLAUDE.md", "notes.txt", "nested")
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("matthewemery-pages-publish-" + [System.Guid]::NewGuid().ToString("N"))
$destinationRepo = Join-Path $tempRoot "pages-repo"
$remoteRepo = Join-Path $tempRoot "pages-remote.git"

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,

        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory
    )

    $output = & git -C $WorkingDirectory @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed in '$WorkingDirectory': $($output -join [Environment]::NewLine)"
    }

    return @($output)
}

function Initialize-DestinationRepo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath
    )

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Invoke-Git -Arguments @("init", "--initial-branch=main") -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("config", "user.name", "Codex Test") -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("config", "user.email", "codex@example.invalid") -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("remote", "add", "origin", $RemotePath) -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("config", "branch.main.remote", "origin") -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("config", "branch.main.merge", "refs/heads/main") -WorkingDirectory $Path | Out-Null
}

function Write-SeedContent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    New-Item -ItemType Directory -Path (Join-Path $Path "nested") -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $Path "README.md") -Value "Private pages repo notes" -NoNewline
    Set-Content -LiteralPath (Join-Path $Path "notes.txt") -Value "do not publish" -NoNewline
    Set-Content -LiteralPath (Join-Path $Path "nested\secret.txt") -Value "secret" -NoNewline
}

function Commit-All {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Invoke-Git -Arguments @("add", "--all") -WorkingDirectory $Path | Out-Null
    Invoke-Git -Arguments @("commit", "-m", $Message) -WorkingDirectory $Path | Out-Null
}

function Get-TrackedFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return Invoke-Git -Arguments @("ls-files") -WorkingDirectory $Path | Sort-Object
}

function Get-StagedFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return @(Invoke-Git -Arguments @("diff", "--cached", "--name-only") -WorkingDirectory $Path | Sort-Object)
}

function Get-HeadCommit {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $headCommit = Invoke-Git -Arguments @("rev-parse", "HEAD") -WorkingDirectory $Path | Select-Object -First 1
    return ([string]$headCommit).Trim()
}

function Get-RemoteMainCommit {
    $output = & git -C $remoteRepo rev-parse --verify --quiet "refs/heads/main" 2>&1
    if ($LASTEXITCODE -eq 1) {
        return $null
    }

    if ($LASTEXITCODE -ne 0) {
        throw "git rev-parse --verify --quiet refs/heads/main failed in '$remoteRepo': $($output -join [Environment]::NewLine)"
    }

    return ([string]($output | Select-Object -First 1)).Trim()
}

function Assert-RemoteMainAbsent {
    if (Get-RemoteMainCommit) {
        throw "Expected origin/main to be absent."
    }
}

function Invoke-PublishScript {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $output = & pwsh -NoProfile -File $publishScript @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "publish-pages.ps1 failed: $($output -join [Environment]::NewLine)"
    }

    return @($output)
}

function Assert-PublicFilesInWorkingTree {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $expectedWorkingTree = @($expectedFiles | Sort-Object)
    $actualNames = Get-ChildItem -LiteralPath $Path -Force |
        Where-Object { $_.Name -ne ".git" } |
        Select-Object -ExpandProperty Name |
        Sort-Object

    if (($actualNames -join "|") -ne ($expectedWorkingTree -join "|")) {
        throw "Expected destination contents '$($expectedWorkingTree -join ", ")' but found '$($actualNames -join ", ")'."
    }

    foreach ($blockedPath in $blockedPaths) {
        if (Test-Path -LiteralPath (Join-Path $Path $blockedPath)) {
            throw "Blocked path '$blockedPath' exists after publish."
        }
    }

    foreach ($file in $expectedFiles) {
        $sourceHash = (Get-FileHash -LiteralPath (Join-Path $repoRoot $file) -Algorithm SHA256).Hash
        $publishedHash = (Get-FileHash -LiteralPath (Join-Path $Path $file) -Algorithm SHA256).Hash

        if ($sourceHash -ne $publishedHash) {
            throw "Hash mismatch for '$file'."
        }
    }
}

function Assert-NoStagedChanges {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $stagedFiles = @(Get-StagedFiles -Path $Path)
    if ($stagedFiles.Count -ne 0) {
        throw "Expected no staged changes, but found '$($stagedFiles -join ", ")'."
    }
}

function Assert-CommittedPublicFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $expectedTrackedFiles = @($expectedFiles | Sort-Object)
    $trackedFiles = @(Get-TrackedFiles -Path $Path)

    if (($trackedFiles -join "|") -ne ($expectedTrackedFiles -join "|")) {
        throw "Expected tracked files '$($expectedTrackedFiles -join ", ")' but found '$($trackedFiles -join ", ")'."
    }
}

try {
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    Invoke-Git -Arguments @("init", "--bare", $remoteRepo) -WorkingDirectory $tempRoot | Out-Null
    Initialize-DestinationRepo -Path $destinationRepo -RemotePath $remoteRepo

    Write-SeedContent -Path $destinationRepo
    Commit-All -Path $destinationRepo -Message "Initial private content"

    $headBeforeDefaultPublish = Get-HeadCommit -Path $destinationRepo
    Assert-RemoteMainAbsent

    Invoke-PublishScript -Arguments @("-Destination", $destinationRepo)

    Assert-PublicFilesInWorkingTree -Path $destinationRepo
    Assert-NoStagedChanges -Path $destinationRepo
    $headAfterDefaultPublish = Get-HeadCommit -Path $destinationRepo
    if ($headAfterDefaultPublish -ne $headBeforeDefaultPublish) {
        throw "Expected HEAD to remain unchanged during default publish."
    }

    Assert-RemoteMainAbsent

    Set-Content -LiteralPath (Join-Path $destinationRepo "README.md") -Value "stale publish content" -NoNewline
    Commit-All -Path $destinationRepo -Message "Reintroduce junk"

    $beforeCommitPublishHead = Get-HeadCommit -Path $destinationRepo

    Invoke-PublishScript -Arguments @(
        "-Destination", $destinationRepo,
        "-Stage",
        "-CommitMessage", "Publish public site",
        "-Push"
    )

    Assert-PublicFilesInWorkingTree -Path $destinationRepo

    $afterCommitPublishHead = Get-HeadCommit -Path $destinationRepo
    if ($afterCommitPublishHead -eq $beforeCommitPublishHead) {
        throw "Expected a new commit when -CommitMessage is used, but HEAD did not change."
    }

    Assert-NoStagedChanges -Path $destinationRepo
    Assert-CommittedPublicFiles -Path $destinationRepo

    $remoteMainCommit = Get-RemoteMainCommit
    if (-not $remoteMainCommit) {
        throw "Expected origin/main to exist after -Push."
    }

    if ($remoteMainCommit -ne $afterCommitPublishHead) {
        throw "Expected pushed commit '$afterCommitPublishHead' but origin/main points to '$remoteMainCommit'."
    }

    Write-Host "PASS: publish-pages verification succeeded."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
