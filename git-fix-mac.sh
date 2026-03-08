#!/bin/bash
echo "============================================"
echo " Git Fix - naprawa push 403 (macOS)"
echo "============================================"
echo

# Sprawdz czy git jest dostepny
if ! command -v git &>/dev/null; then
    echo " BLAD: Git nie znaleziony."
    echo " Zainstaluj: xcode-select --install"
    echo
    exit 1
fi

echo "[1/4] Czyszczenie starych poswiadczen GitHub z Keychain..."
# Usun wpisy github.com z macOS Keychain
security delete-internet-password -s github.com 2>/dev/null
# Powtarzaj — moze byc kilka wpisow
while security delete-internet-password -s github.com 2>/dev/null; do :; done
echo "      Wyczyszczone."
echo

echo "[2/4] Wylaczanie zapamietywania hasel..."
git config --global --unset credential.helper 2>/dev/null
git config --global --unset-all credential.helper 2>/dev/null
echo "      Credentials nie beda zapisywane na tym komputerze."
echo "      Kazdy push bedzie pytal o token - bezpieczniej na uczelni."
echo

echo "[3/4] Konfiguracja Git (imie i email)..."
while true; do
    read -rp "      Twoje imie i nazwisko: " GIT_NAME
    [ -n "$GIT_NAME" ] && break
    echo "      Imie nie moze byc puste!"
done
while true; do
    read -rp "      Twoj email: " GIT_EMAIL
    [ -n "$GIT_EMAIL" ] && break
    echo "      Email nie moze byc pusty!"
done
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "      Ustawiono: $GIT_NAME ($GIT_EMAIL)"
echo

echo "[4/4] Jak pushowac?"
echo
echo "  1. Wejdz do folderu z repo i wpisz: git push"
echo "  2. Username: twoj login GitHub"
echo "  3. Password: wklej Personal Access Token (NIE haslo konta!)"
echo
echo "  Nie masz tokena? Stworz go tutaj:"
echo "  github.com -> Settings -> Developer settings -> Personal access tokens"
echo "  Zaznacz uprawnienie \"repo\" i skopiuj token."
echo
echo "============================================"
echo " Gotowe!"
echo "============================================"
