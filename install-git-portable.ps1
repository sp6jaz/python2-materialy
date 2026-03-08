# install-git-portable.ps1
# Instalacja Git Portable + GitHub CLI bez uprawnien administratora
# Uruchom w PowerShell: irm https://raw.githubusercontent.com/sp6jaz/python2-ns/main/install-git-portable.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Instalacja Git + GitHub CLI (bez admina)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "$env:USERPROFILE\portable-git"

# --- 1. Git Portable ---
Write-Host "[1/4] Pobieram Git Portable..." -ForegroundColor Yellow

$gitDir = "$baseDir\git"
if (Test-Path "$gitDir\bin\git.exe") {
    Write-Host "      Git juz zainstalowany: $gitDir" -ForegroundColor Green
} else {
    # Pobierz strone releasow i znajdz link do PortableGit 64-bit
    $releasePage = Invoke-WebRequest -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -UseBasicParsing
    $release = $releasePage.Content | ConvertFrom-Json
    $gitUrl = ($release.assets | Where-Object { $_.name -match "PortableGit.*64-bit.*\.7z\.exe$" }).browser_download_url

    if (-not $gitUrl) {
        Write-Host "      BLAD: Nie znaleziono linku do Git Portable." -ForegroundColor Red
        exit 1
    }

    $gitInstaller = "$env:TEMP\PortableGit.7z.exe"
    Write-Host "      Pobieram: $gitUrl"
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing

    Write-Host "      Rozpakowujem do $gitDir ..."
    New-Item -ItemType Directory -Path $gitDir -Force | Out-Null
    # PortableGit .7z.exe to samorozpakowujace archiwum — parametr -o ustawia katalog, -y = bez pytan
    & $gitInstaller -o"$gitDir" -y | Out-Null
    Remove-Item $gitInstaller -Force

    if (Test-Path "$gitDir\bin\git.exe") {
        Write-Host "      Git zainstalowany!" -ForegroundColor Green
    } else {
        Write-Host "      BLAD: git.exe nie znaleziony po rozpakowaniu." -ForegroundColor Red
        exit 1
    }
}

# --- 2. GitHub CLI ---
Write-Host "[2/4] Pobieram GitHub CLI..." -ForegroundColor Yellow

$ghDir = "$baseDir\gh"
if (Test-Path "$ghDir\bin\gh.exe") {
    Write-Host "      GitHub CLI juz zainstalowane: $ghDir" -ForegroundColor Green
} else {
    $ghRelease = Invoke-WebRequest -Uri "https://api.github.com/repos/cli/cli/releases/latest" -UseBasicParsing
    $ghJson = $ghRelease.Content | ConvertFrom-Json
    $ghUrl = ($ghJson.assets | Where-Object { $_.name -match "gh_.*_windows_amd64\.zip$" }).browser_download_url

    if (-not $ghUrl) {
        Write-Host "      BLAD: Nie znaleziono linku do GitHub CLI." -ForegroundColor Red
        exit 1
    }

    $ghZip = "$env:TEMP\gh.zip"
    Write-Host "      Pobieram: $ghUrl"
    Invoke-WebRequest -Uri $ghUrl -OutFile $ghZip -UseBasicParsing

    Write-Host "      Rozpakowujem..."
    $ghTemp = "$env:TEMP\gh-extract"
    Expand-Archive -Path $ghZip -DestinationPath $ghTemp -Force
    # W zipie jest podkatalog gh_x.y.z_windows_amd64 — przenosimy jego zawartosc
    $ghInner = Get-ChildItem -Path $ghTemp -Directory | Select-Object -First 1
    New-Item -ItemType Directory -Path $ghDir -Force | Out-Null
    Copy-Item -Path "$($ghInner.FullName)\*" -Destination $ghDir -Recurse -Force
    Remove-Item $ghZip -Force
    Remove-Item $ghTemp -Recurse -Force

    if (Test-Path "$ghDir\bin\gh.exe") {
        Write-Host "      GitHub CLI zainstalowane!" -ForegroundColor Green
    } else {
        Write-Host "      BLAD: gh.exe nie znaleziony po rozpakowaniu." -ForegroundColor Red
        exit 1
    }
}

# --- 3. PATH ---
Write-Host "[3/4] Ustawiam PATH..." -ForegroundColor Yellow

$gitBin = "$gitDir\bin"
$ghBin = "$ghDir\bin"
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")

$changed = $false
if ($userPath -notlike "*$gitBin*") {
    $userPath = "$gitBin;$userPath"
    $changed = $true
}
if ($userPath -notlike "*$ghBin*") {
    $userPath = "$ghBin;$userPath"
    $changed = $true
}

if ($changed) {
    [Environment]::SetEnvironmentVariable("PATH", $userPath, "User")
    Write-Host "      PATH zapisany na stale (dla Twojego konta)." -ForegroundColor Green
} else {
    Write-Host "      PATH juz ustawiony." -ForegroundColor Green
}

# Ustaw tez w biezacej sesji
$env:PATH = "$gitBin;$ghBin;$env:PATH"

# --- 4. Weryfikacja ---
Write-Host "[4/4] Weryfikacja..." -ForegroundColor Yellow
Write-Host ""

$gitVer = & "$gitBin\git.exe" --version 2>&1
$ghVer = & "$ghBin\gh.exe" --version 2>&1 | Select-Object -First 1

Write-Host "      git:  $gitVer" -ForegroundColor Green
Write-Host "      gh:   $ghVer" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Gotowe!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Zamknij i otworz ponownie PowerShell/VS Code," -ForegroundColor White
Write-Host "  zeby PATH zaczal dzialac." -ForegroundColor White
Write-Host ""
Write-Host "  Nastepny krok: gh auth login" -ForegroundColor White
Write-Host ""
