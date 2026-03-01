#!/bin/bash
echo "============================================"
echo " Instalacja rozszerzen VS Code"
echo " Python, Jupyter, Mermaid, Markdown, Git"
echo "============================================"
echo

# Sprawdz czy code jest dostepny
if ! command -v code &>/dev/null; then
    echo " BLAD: Polecenie 'code' nie znalezione w PATH."
    echo
    echo " Rozwiazania:"
    echo " 1. Otworz VS Code, nacisnij Ctrl+Shift+P"
    echo "    wpisz: Shell Command: Install 'code' command in PATH"
    echo " 2. Lub zainstaluj VS Code:"
    echo "    sudo snap install code --classic"
    echo
    exit 1
fi

OK=0
FAIL=0

install_ext() {
    echo " Instalacja: $1"
    if code --install-extension "$1" --force &>/dev/null; then
        echo "   OK"
        ((OK++))
    else
        echo "   BLAD!"
        ((FAIL++))
    fi
}

# Python
install_ext ms-python.python
install_ext ms-python.vscode-pylance
install_ext ms-python.debugpy
install_ext ms-python.vscode-python-envs

# Jupyter
install_ext ms-toolsai.jupyter
install_ext ms-toolsai.jupyter-keymap
install_ext ms-toolsai.jupyter-renderers
install_ext ms-toolsai.vscode-jupyter-cell-tags
install_ext ms-toolsai.vscode-jupyter-slideshow

# Markdown
install_ext yzhang.markdown-all-in-one
install_ext bierner.markdown-preview-github-styles

# Mermaid
install_ext bierner.markdown-mermaid

# Git
install_ext mhutchie.git-graph
install_ext eamodio.gitlens

echo
echo "============================================"
echo " Wynik: $OK zainstalowanych, $FAIL bledow"
echo " Zrestartuj VS Code (Ctrl+Shift+P, Reload Window)"
echo "============================================"
