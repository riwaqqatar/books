# Publishes this folder to github.com/ahmadyoussef62/riwaq-books and turns on GitHub Pages.
# First run: creates the public repo. Later runs: uploads any new or changed books.
$ErrorActionPreference = 'Stop'
$gh = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\gh.exe"
Set-Location $PSScriptRoot

if (-not (Test-Path .git)) {
    git init -q -b main
    git config user.name "Ahmad El Youssef"
    git config user.email "ahmadyoussef62@users.noreply.github.com"
}
& $gh auth setup-git
git add -A
git commit -q -m "Update Riwaq Books" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"

$exists = $true
try { & $gh repo view ahmadyoussef62/riwaq-books --json name | Out-Null } catch { $exists = $false }
if ($LASTEXITCODE -ne 0) { $exists = $false }

if (-not $exists) {
    & $gh repo create ahmadyoussef62/riwaq-books --public --description "Riwaq stories as flipbooks" --source . --remote origin --push
    & $gh api -X POST repos/ahmadyoussef62/riwaq-books/pages -f "source[branch]=main" -f "source[path]=/" | Out-Null
} else {
    git push -u origin main
}
Write-Host ""
Write-Host "Done. In 1-2 minutes the books are live at:" -ForegroundColor Green
Write-Host "  https://ahmadyoussef62.github.io/riwaq-books/"
Write-Host "  https://ahmadyoussef62.github.io/riwaq-books/saud/"
