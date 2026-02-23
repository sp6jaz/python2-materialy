@echo off
chcp 65001 >nul
echo ============================================
echo  Git Fix - naprawa push 403 na uczelni
echo ============================================
echo.

:: Sprawdz czy git jest dostepny
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo  BLAD: Git nie znaleziony w PATH.
    echo  Zainstaluj git ze strony: https://git-scm.com
    echo.
    pause
    exit /b 1
)

echo [1/4] Czyszczenie starych poswiadczen GitHub...
cmdkey /delete:git:https://github.com >nul 2>&1
cmdkey /delete:LegacyGeneric:target=git:https://github.com >nul 2>&1
cmdkey /delete:github.com >nul 2>&1
:: Git Credential Manager przechowuje dane tez tutaj:
for /f "tokens=2 delims= " %%a in ('cmdkey /list ^| findstr /i "github"') do (
    cmdkey /delete:%%a >nul 2>&1
)
echo      Wyczyszczone.
echo.

echo [2/4] Wylaczanie zapamietywania hasel...
git config --global --unset credential.helper >nul 2>&1
git config --global --unset-all credential.helper >nul 2>&1
echo      Credentials nie beda zapisywane na tym komputerze.
echo      Kazdy push bedzie pytal o token - bezpieczniej na uczelni.
echo.

echo [3/4] Konfiguracja Git (imie i email)...
:ask_name
set /p GIT_NAME="      Twoje imie i nazwisko: "
if "%GIT_NAME%"=="" (
    echo      Imie nie moze byc puste!
    goto ask_name
)
:ask_email
set /p GIT_EMAIL="      Twoj email: "
if "%GIT_EMAIL%"=="" (
    echo      Email nie moze byc pusty!
    goto ask_email
)
git config --global user.name "%GIT_NAME%"
git config --global user.email "%GIT_EMAIL%"
echo      Ustawiono: %GIT_NAME% (%GIT_EMAIL%)
echo.

echo [4/4] Jak pushowac?
echo.
echo   1. Wejdz do folderu z repo i wpisz: git push
echo   2. Username: twoj login GitHub
echo   3. Password: wklej Personal Access Token (NIE haslo konta!)
echo.
echo   Nie masz tokena? Stworz go tutaj:
echo   github.com -^> Settings -^> Developer settings -^> Personal access tokens
echo   Zaznacz uprawnienie "repo" i skopiuj token.
echo.
echo ============================================
echo  Gotowe!
echo ============================================
pause
