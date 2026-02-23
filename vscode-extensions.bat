@echo off
chcp 65001 >nul
echo ============================================
echo  Instalacja rozszerzen VS Code
echo  Python, Jupyter, Mermaid, Markdown, Git
echo ============================================
echo.

:: Sprawdz czy code jest dostepny
where code >nul 2>&1
if %errorlevel% neq 0 (
    echo  BLAD: Polecenie "code" nie znalezione w PATH.
    echo.
    echo  Rozwiazania:
    echo  1. Otworz VS Code, nacisnij Ctrl+Shift+P
    echo     wpisz: Shell Command: Install 'code' command in PATH
    echo  2. Lub dodaj recznie do PATH:
    echo     C:\Users\TWOJ_USER\AppData\Local\Programs\Microsoft VS Code\bin
    echo.
    pause
    exit /b 1
)

set OK=0
set FAIL=0

:: Python
call :install ms-python.python
call :install ms-python.vscode-pylance
call :install ms-python.debugpy
call :install ms-python.vscode-python-envs

:: Jupyter
call :install ms-toolsai.jupyter
call :install ms-toolsai.jupyter-keymap
call :install ms-toolsai.jupyter-renderers
call :install ms-toolsai.vscode-jupyter-cell-tags
call :install ms-toolsai.vscode-jupyter-slideshow

:: Markdown
call :install yzhang.markdown-all-in-one
call :install bierner.markdown-preview-github-styles

:: Mermaid
call :install bierner.markdown-mermaid

:: Git
call :install mhutchie.git-graph
call :install eamodio.gitlens

echo.
echo ============================================
echo  Wynik: %OK% zainstalowanych, %FAIL% bledow
echo  Zrestartuj VS Code (Ctrl+Shift+P, Reload Window)
echo ============================================
pause
exit /b 0

:install
echo  Instalacja: %~1
call code --install-extension %~1 --force >nul 2>&1
if %errorlevel% equ 0 (
    echo    OK
    set /a OK+=1
) else (
    echo    BLAD!
    set /a FAIL+=1
)
exit /b
