#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Kore agent skills into a Claude Code project.

.PARAMETER TargetProjectPath
    Absolute path to the target project directory.

.EXAMPLE
    .\install\install-claude.ps1 -TargetProjectPath "E:\Projects\kore-app"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetProjectPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Resolve paths
# ---------------------------------------------------------------------------

$SkillsSourcePath = Join-Path $PSScriptRoot '..\skills'
$SkillsDestPath   = Join-Path $TargetProjectPath '.claude\skills'

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
        Write-Host "  Copied: .claude\skills\$($SkillDir.Name)\$RelativePath"
    }
}

Write-Host ""
Write-Host "Done. Skills installed into $SkillsDestPath"
