#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Kore agent skills into a Codex/OpenAI coding agent project.

.PARAMETER TargetProjectPath
    Absolute path to the target project directory.

.EXAMPLE
    .\install\install-codex.ps1 -TargetProjectPath "E:\Projects\kore-app"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetProjectPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$BlockStart = '<!-- KORE_AGENT_SKILLS_START -->'
$BlockEnd   = '<!-- KORE_AGENT_SKILLS_END -->'

# ---------------------------------------------------------------------------
# Resolve paths
# ---------------------------------------------------------------------------

$SkillsSourcePath = Join-Path $PSScriptRoot '..\skills'
$SkillsDestPath   = Join-Path $TargetProjectPath '.agents\skills'
$AgentsMdPath     = Join-Path $TargetProjectPath 'AGENTS.md'

if (-not (Test-Path $TargetProjectPath -PathType Container)) {
    Write-Error "Target project path does not exist: $TargetProjectPath"
    exit 1
}

if (-not (Test-Path $SkillsSourcePath -PathType Container)) {
    Write-Error "Skills source directory not found: $SkillsSourcePath"
    exit 1
}

# ---------------------------------------------------------------------------
# Copy skills
# ---------------------------------------------------------------------------

Write-Host "Installing skills into: $SkillsDestPath"

$SkillDirs = Get-ChildItem -Path $SkillsSourcePath -Directory

foreach ($SkillDir in $SkillDirs) {
    $DestSkillDir = Join-Path $SkillsDestPath $SkillDir.Name

    if (-not (Test-Path $DestSkillDir)) {
        New-Item -ItemType Directory -Path $DestSkillDir -Force | Out-Null
    }

    $SkillFiles = Get-ChildItem -Path $SkillDir.FullName -File -Recurse

    foreach ($File in $SkillFiles) {
        $RelativePath = $File.FullName.Substring($SkillDir.FullName.Length).TrimStart('\', '/')
        $DestFile     = Join-Path $DestSkillDir $RelativePath
        $DestDir      = Split-Path $DestFile -Parent

        if (-not (Test-Path $DestDir)) {
            New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
        }

        Copy-Item -Path $File.FullName -Destination $DestFile -Force
        Write-Host "  Copied: .agents\skills\$($SkillDir.Name)\$RelativePath"
    }
}

# ---------------------------------------------------------------------------
# Build the managed block content
# ---------------------------------------------------------------------------

$SkillSummaries = [System.Text.StringBuilder]::new()

foreach ($SkillDir in $SkillDirs) {
    $SkillMdPath = Join-Path $SkillDir.FullName 'SKILL.md'
    $Description = ''

    if (Test-Path $SkillMdPath) {
        $Lines = Get-Content -Path $SkillMdPath

        # Extract description from YAML frontmatter
        $InFrontmatter = $false
        foreach ($Line in $Lines) {
            if ($Line -eq '---') {
                if (-not $InFrontmatter) { $InFrontmatter = $true; continue }
                else { break }
            }
            if ($InFrontmatter -and $Line -match '^description:\s*(.+)$') {
                $Description = $Matches[1].Trim()
                break
            }
        }
    }

    [void]$SkillSummaries.AppendLine("- **$($SkillDir.Name)** — $Description")
}

$ManagedBlock = @"
$BlockStart
## Kore Agent Skills

Skills are stored in `.agents/skills/<skill-name>/SKILL.md`.

### How to use a skill

When asked to use a skill, read the corresponding `.agents/skills/<skill-name>/SKILL.md` before implementing.
The skill file describes the purpose, trigger phrases, rules, process, and expected output for that skill.

Example: to use the `security-audit` skill, read `.agents/skills/security-audit/SKILL.md` first.

### Available skills

$($SkillSummaries.ToString().TrimEnd())

### Rules

- Do not store secrets, tokens, or credentials in skill files or agent instructions.
- Skills operate within the Kore security and permissions model.
- Each skill requires a final Markdown report in `.dev-reports/`.
$BlockEnd
"@

# ---------------------------------------------------------------------------
# Create or update AGENTS.md
# ---------------------------------------------------------------------------

if (Test-Path $AgentsMdPath) {
    $ExistingContent = Get-Content -Path $AgentsMdPath -Raw -Encoding UTF8

    if ($ExistingContent -match [regex]::Escape($BlockStart)) {
        # Replace existing managed block
        $Pattern        = [regex]::Escape($BlockStart) + '[\s\S]*?' + [regex]::Escape($BlockEnd)
        $UpdatedContent = [regex]::Replace($ExistingContent, $Pattern, $ManagedBlock.Trim())
        Set-Content -Path $AgentsMdPath -Value $UpdatedContent -Encoding UTF8
        Write-Host "Updated managed block in: AGENTS.md"
    } else {
        # Append managed block to existing file
        $Separator = if ($ExistingContent.TrimEnd().Length -gt 0) { "`n`n" } else { '' }
        $UpdatedContent = $ExistingContent.TrimEnd() + $Separator + $ManagedBlock.Trim() + "`n"
        Set-Content -Path $AgentsMdPath -Value $UpdatedContent -Encoding UTF8
        Write-Host "Appended managed block to existing: AGENTS.md"
    }
} else {
    Set-Content -Path $AgentsMdPath -Value ($ManagedBlock.Trim() + "`n") -Encoding UTF8
    Write-Host "Created: AGENTS.md"
}

Write-Host ""
Write-Host "Done. Skills installed into $SkillsDestPath"
