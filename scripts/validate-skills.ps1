# Validate Kore agent skills - check for secrets, missing files, and structure issues.
param(
    [string]$SkillsDir = "$PSScriptRoot\..\skills"
)

$ErrorActionPreference = "Stop"
$secretPatterns = @("API_KEY", "SECRET", "TOKEN", "PASSWORD", "PRIVATE_KEY", "BEGIN RSA", "BEGIN OPENSSH", "DATABASE_URL", "REDIS_URL", "EVOLUTION_API_KEY")
$errors = @()
$warnings = @()

Write-Host ""
Write-Host "=== Kore Agent Skills Validator ===" -ForegroundColor Cyan
Write-Host "Skills directory: $SkillsDir"
Write-Host ""

if (-not (Test-Path $SkillsDir)) { Write-Error "Skills directory not found: $SkillsDir"; exit 1 }

$dirs = Get-ChildItem $SkillsDir -Directory
if ($dirs.Count -eq 0) { Write-Error "No skill directories found"; exit 1 }

foreach ($dir in $dirs) {
    $name = $dir.Name
    Write-Host "  Checking: $name"

    $hasSkill = Test-Path "$($dir.FullName)\SKILL.md"
    $hasReadme = Test-Path "$($dir.FullName)\README.md"
    if (-not $hasSkill -and -not $hasReadme) {
        $errors += "$name : missing SKILL.md or README.md"
        Write-Host "    WARN: no SKILL.md or README.md" -ForegroundColor Yellow
    }

    $files = Get-ChildItem $dir.FullName -Recurse -File -Exclude "*.png","*.jpg","*.gif","*.mp4","*.svg","*.ico"
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        foreach ($pattern in $secretPatterns) {
            if ($content -match $pattern) {
                $warnings += "$($file.Name) : contains '$pattern' - verify it is a placeholder"
                Write-Host "    WARN: $($file.Name) contains '$pattern'" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""
Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host "  Skills found: $($dirs.Count)"
Write-Host "  Errors: $($errors.Count)"
Write-Host "  Warnings: $($warnings.Count)"

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Errors:" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host "  $e" -ForegroundColor Red }
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings (review manually):" -ForegroundColor Yellow
    foreach ($w in $warnings) { Write-Host "  $w" -ForegroundColor Yellow }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
exit 0
