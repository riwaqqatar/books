# Publishes this folder to github.com/riwaqqatar/books (GitHub Pages: https://riwaqqatar.github.io/books/).
# Run it after a new or changed book is added; it uploads everything that changed.
$gh = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\gh.exe"
$repo = "riwaqqatar/books"
Set-Location $PSScriptRoot
function Fail($msg) { Write-Host ""; Write-Host "STOPPED: $msg" -ForegroundColor Red; exit 1 }

# 1. Make sure this terminal is signed in to GitHub (opens the browser code page if not)
& $gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Sign in to GitHub: copy the code below, then approve it in the browser." -ForegroundColor Yellow
    & $gh auth login --web --hostname github.com --git-protocol https --scopes repo,workflow
    if ($LASTEXITCODE -ne 0) { Fail "GitHub sign-in did not finish." }
}
& $gh auth setup-git

# 2. Save the current files as a new version
if (-not (Test-Path .git)) { git init -q -b main }
git config user.name "Ahmad El Youssef"
git config user.email "ahmadyoussef62@users.noreply.github.com"
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) { git commit -q -m "Update Riwaq Books" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" }

# 3. Upload
git remote get-url origin *> $null
if ($LASTEXITCODE -ne 0) { git remote add origin "https://github.com/$repo.git" } else { git remote set-url origin "https://github.com/$repo.git" }
git push -u origin main
if ($LASTEXITCODE -ne 0) { Fail "Upload to GitHub failed." }

Write-Host ""
Write-Host "Done. In 1-2 minutes the books are live at:" -ForegroundColor Green
Write-Host "  https://riwaqqatar.github.io/books/"
Write-Host "  https://riwaqqatar.github.io/books/saud/"
Write-Host "  https://riwaqqatar.github.io/books/bayyadti/"
