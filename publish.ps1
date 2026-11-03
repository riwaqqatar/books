# Publishes this folder to github.com/ahmadyoussef62/riwaq-books and turns on GitHub Pages.
# First run: creates the public repo. Later runs: uploads any new or changed books.
$gh = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\gh.exe"
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

# 3. Create the public repo the first time, otherwise just upload
& $gh repo view ahmadyoussef62/riwaq-books --json name *> $null
if ($LASTEXITCODE -ne 0) {
    & $gh repo create ahmadyoussef62/riwaq-books --public --description "Riwaq stories as flipbooks" --source . --remote origin --push
    if ($LASTEXITCODE -ne 0) { Fail "Could not create the repo on GitHub." }
    & $gh api -X POST repos/ahmadyoussef62/riwaq-books/pages -f "source[branch]=main" -f "source[path]=/" | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail "Repo uploaded, but GitHub Pages did not switch on." }
} else {
    git remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) { git remote add origin https://github.com/ahmadyoussef62/riwaq-books.git }
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { Fail "Upload to GitHub failed." }
}

Write-Host ""
Write-Host "Done. In 1-2 minutes the books are live at:" -ForegroundColor Green
Write-Host "  https://ahmadyoussef62.github.io/riwaq-books/"
Write-Host "  https://ahmadyoussef62.github.io/riwaq-books/saud/"
