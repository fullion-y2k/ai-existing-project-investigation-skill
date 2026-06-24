[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$SkillRoot = "$HOME\.agents\skills",
    [string]$BackupRoot = "$HOME\.agents\skill-backups",
    [string]$AgentRoot = "$HOME\.codex\agents",
    [string]$AgentBackupRoot = "$HOME\.codex\agent-backups"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillName = "ai-existing-project-investigation"
$Source = Join-Path $RepoRoot "skills\$SkillName"
$Destination = Join-Path $SkillRoot $SkillName
$AgentSource = Join-Path $RepoRoot "agents\openai-codex"

function Write-Step {
    param([string]$Message)
    Write-Host "[ai-existing-project-investigation] $Message"
}

function Invoke-Step {
    param(
        [string]$Message,
        [scriptblock]$Action
    )

    if ($DryRun) {
        Write-Step "DRY-RUN: $Message"
        return
    }

    Write-Step $Message
    & $Action
}

if (!(Test-Path -LiteralPath $Source)) {
    throw "Skill source not found: $Source"
}

$SkillFile = Join-Path $Source "SKILL.md"
if (!(Test-Path -LiteralPath $SkillFile)) {
    throw "SKILL.md not found: $SkillFile"
}

Write-Step "Source: $Source"
Write-Step "Destination: $Destination"
Write-Step "Agent source: $AgentSource"
Write-Step "Agent destination: $AgentRoot"

Invoke-Step "Ensure skill root exists: $SkillRoot" {
    New-Item -ItemType Directory -Force -Path $SkillRoot | Out-Null
}

if (Test-Path -LiteralPath $Destination) {
    $Timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $BackupPath = Join-Path $BackupRoot "$SkillName.backup-$Timestamp"

    Invoke-Step "Backup existing skill to: $BackupPath" {
        New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
        Move-Item -LiteralPath $Destination -Destination $BackupPath
    }
}

Invoke-Step "Install skill" {
    Copy-Item -Recurse -Force -LiteralPath $Source -Destination $Destination
}

if (Test-Path -LiteralPath $AgentSource) {
    Invoke-Step "Ensure agent root exists: $AgentRoot" {
        New-Item -ItemType Directory -Force -Path $AgentRoot | Out-Null
    }

    $AgentFiles = Get-ChildItem -LiteralPath $AgentSource -Filter "*.toml" -File
    foreach ($AgentFile in $AgentFiles) {
        $AgentDestination = Join-Path $AgentRoot $AgentFile.Name
        if (Test-Path -LiteralPath $AgentDestination) {
            $Timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $BackupPath = Join-Path $AgentBackupRoot "$($AgentFile.BaseName).backup-$Timestamp.toml"
            Invoke-Step "Backup existing agent to: $BackupPath" {
                New-Item -ItemType Directory -Force -Path $AgentBackupRoot | Out-Null
                Move-Item -LiteralPath $AgentDestination -Destination $BackupPath
            }
        }

        Invoke-Step "Install agent: $($AgentFile.Name)" {
            Copy-Item -Force -LiteralPath $AgentFile.FullName -Destination $AgentDestination
        }
    }
}

Write-Step "Done."
Write-Step "Start a new Codex session or restart Codex so the skill list is refreshed."
