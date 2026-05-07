#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Kore agent skills into an OpenCode project.

.PARAMETER TargetProjectPath
    Absolute path to the target project directory.

.EXAMPLE
    .\install\install-opencode.ps1 -TargetProjectPath "E:\Projects\kore-app"
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

$SkillsSourcePath    = Join-Path $PSScriptRoot '..\skills'
$SkillsDestPath      = Join-Path $TargetProjectPath '.opencode\skills'
$OpenCodeJsonPath    = Join-Path $TargetProjectPath 'opencode.json'

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
        Write-Host "  Copied: .opencode\skills\$($SkillDir.Name)\$RelativePath"
    }
}

# ---------------------------------------------------------------------------
# Build skill permission entries
# ---------------------------------------------------------------------------

$SkillPermissions = [ordered]@{ '*' = 'allow' }

foreach ($SkillDir in $SkillDirs) {
    $SkillPermissions[$SkillDir.Name] = 'allow'
}

# ---------------------------------------------------------------------------
# Create or update opencode.json
# ---------------------------------------------------------------------------

if (Test-Path $OpenCodeJsonPath) {
    $RawJson = Get-Content -Path $OpenCodeJsonPath -Raw -Encoding UTF8

    try {
        $Config = $RawJson | ConvertFrom-Json
    } catch {
        Write-Error "opencode.json exists but is not valid JSON: $OpenCodeJsonPath"
        exit 1
    }

    # ConvertFrom-Json returns PSCustomObject; we need a hashtable to mutate it
    $ConfigHash = @{}
    $Config.PSObject.Properties | ForEach-Object { $ConfigHash[$_.Name] = $_.Value }

    if (-not $ConfigHash.ContainsKey('permission')) {
        $ConfigHash['permission'] = @{ skill = $SkillPermissions }
    } else {
        $PermHash = @{}
        $Config.permission.PSObject.Properties | ForEach-Object { $PermHash[$_.Name] = $_.Value }

        if (-not $PermHash.ContainsKey('skill')) {
            $PermHash['skill'] = $SkillPermissions
        } else {
            # Merge — add missing skill entries, keep existing values
            foreach ($Key in $SkillPermissions.Keys) {
                $ExistingSkill = @{}
                $Config.permission.skill.PSObject.Properties | ForEach-Object { $ExistingSkill[$_.Name] = $_.Value }

                if (-not $ExistingSkill.ContainsKey($Key)) {
                    $ExistingSkill[$Key] = $SkillPermissions[$Key]
                }
                $PermHash['skill'] = $ExistingSkill
            }
        }

        $ConfigHash['permission'] = $PermHash
    }

    $UpdatedJson = $ConfigHash | ConvertTo-Json -Depth 10
    Set-Content -Path $OpenCodeJsonPath -Value $UpdatedJson -Encoding UTF8
    Write-Host "Updated: opencode.json"
} else {
    $NewConfig = @{
        permission = @{
            skill = $SkillPermissions
        }
    }

    $NewJson = $NewConfig | ConvertTo-Json -Depth 10
    Set-Content -Path $OpenCodeJsonPath -Value $NewJson -Encoding UTF8
    Write-Host "Created: opencode.json"
}

Write-Host ""
Write-Host "Done. Skills installed into $SkillsDestPath"
