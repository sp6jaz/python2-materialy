# Jak pracować na tym kursie — przewodnik studenta

**Programowanie w Pythonie II** | Politechnika Opolska
**Prowadzący:** dr hab. inż. Jarosław Zygarlicki

---

## 1. Twoje repozytorium — centrum pracy

Przez cały semestr pracujesz w **jednym repozytorium Git** na GitHubie. To jest Twoje portfolio — prowadzący ma do niego wgląd na bieżąco.

### Struktura repozytorium

```
python2-lab/
├── README.md              ← wizytówka (opis Ciebie i kursu)
├── .gitignore             ← co NIE idzie do repo (.venv/, __pycache__/)
├── requirements.txt       ← lista pakietów
│
├── lab01/                 ← folder na każde laboratorium
│   ├── lab01_setup.ipynb
│   └── hello_data.py
│
├── lab02/
│   ├── lab02_pipeline.ipynb
│   └── README.md          ← opcjonalnie: notatki z labu
│
├── lab03/
│   ├── lab03_numpy.ipynb
│   └── ...
│
├── ...                    ← kolejne laboratoria
│
└── projekt/               ← mini-projekt (W11-W15)
    ├── README.md          ← opis projektu, pytanie badawcze
    ├── dane.csv           ← dataset
    └── analiza.ipynb      ← notebook z analizą
```

### Jak to utworzyć

```bash
# Na początku semestru (L01):
mkdir python2-lab
cd python2-lab
git init

# Struktura
mkdir lab01 lab02 lab03 lab04 lab05 lab06 lab07 lab08 lab09 lab10 lab11 lab12 lab13 lab14 projekt

# Plik .gitignore
cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
.ipynb_checkpoints/
.DS_Store
EOF

# README.md — Twoja wizytówka
# (uzupełnij szablon z ćwiczenia 3 na L01)

# Pierwszy commit
git add .
git commit -m "Inicjalizacja repozytorium kursu Python II"
```

---

## 2. Workflow każdego laboratorium

Każde laboratorium ma ten sam schemat pracy:

```
PRZED LABEM:
  1. Otwórz VS Code
  2. Aktywuj środowisko: source .venv/bin/activate
  3. Utwórz nowy folder labXX/ (jeśli nie istnieje)

PODCZAS LABU:
  4. Twórz notebook .ipynb lub skrypt .py
  5. Rozwiązuj ćwiczenia — kod + komentarze
  6. Commituj po każdym ćwiczeniu (nie na koniec!)

PO LABIE:
  7. git push — wypchnij na GitHub
  8. Sprawdź w przeglądarce czy wszystko widać
```

### Szczegółowo — krok po kroku

**Krok 1: Przygotowanie (przed zajęciami lub na początku)**

```bash
cd ~/python2-lab
source .venv/bin/activate     # Linux/macOS
# .venv\Scripts\Activate.ps1  # Windows

# Utwórz folder na dzisiejsze lab (np. lab03)
mkdir -p lab03
cd lab03
```

**Krok 2: Praca podczas labu**

Otwórz VS Code w głównym katalogu projektu:
```bash
cd ~/python2-lab
code .
```

Utwórz notebook w folderze labXX — nazwa wg schematu:
```
lab03_numpy.ipynb      ← notebook z ćwiczeniami
lab05_pandas.ipynb     ← kolejne labki
```

**Krok 3: Commitowanie — ROBISZ TO REGULARNIE, nie na koniec!**

```bash
# Po skończeniu ćwiczenia 1:
git add lab03/lab03_numpy.ipynb
git commit -m "L03: Ćw. 1 — tworzenie tablic NumPy"

# Po skończeniu ćwiczenia 2:
git add lab03/lab03_numpy.ipynb
git commit -m "L03: Ćw. 2 — operacje wektorowe i broadcasting"

# Po skończeniu wszystkich ćwiczeń:
git push
```

**Dlaczego commitować po każdym ćwiczeniu?**
- Masz historię pracy (widać że pracowałeś/pracowałaś)
- Jeśli coś zepsujesz — możesz wrócić do poprzedniej wersji
- Prowadzący widzi progres, nie jeden commit z wszystkim

---

## 3. Dokumentacja w Markdown

Każde repozytorium powinno mieć **README.md** — to pierwsza rzecz, którą widzi każdy kto wejdzie na Twój profil GitHub.

### Główne README.md (w katalogu głównym)

```markdown
# Python II — Laboratorium

**Imię Nazwisko** | Analityka danych w biznesie, semestr 2
Politechnika Opolska, 2025/2026

## Spis treści

| Lab | Temat | Folder |
|-----|-------|--------|
| L01 | Konfiguracja środowiska | [lab01/](lab01/) |
| L02 | Pipeline analityczny, Jupyter | [lab02/](lab02/) |
| L03 | NumPy — podstawy | [lab03/](lab03/) |
| L04 | NumPy — zaawansowane | [lab04/](lab04/) |
| L05 | Pandas — Series i DataFrame | [lab05/](lab05/) |
| L06 | Pandas — selekcja i filtrowanie | [lab06/](lab06/) |
| L07 | Pandas — czyszczenie danych | [lab07/](lab07/) |
| L08 | Pandas — merge i groupby | [lab08/](lab08/) |
| L09 | Matplotlib — podstawy | [lab09/](lab09/) |
| L10 | Seaborn i dashboardy | [lab10/](lab10/) |
| L11 | Statystyka opisowa | [lab11/](lab11/) |
| L12 | Testy hipotez | [lab12/](lab12/) |
| L13 | scikit-learn, Plotly | [lab13/](lab13/) |
| L14 | AI w analizie danych | [lab14/](lab14/) |
| Projekt | Mini-projekt | [projekt/](projekt/) |

## Narzędzia

- Python 3.12+ z uv
- VS Code + Jupyter extension
- Git + GitHub

## Kontakt

- GitHub: [@moj-login](https://github.com/moj-login)
- Email: moj.email@student.po.edu.pl
```

### README.md w folderze projektu

```markdown
# Mini-projekt: [Tytuł analizy]

## Pytanie badawcze
[Jaki problem biznesowy rozwiązujesz?]

## Dataset
- Źródło: [skąd dane]
- Rozmiar: [ile wierszy × kolumn]
- Opis: [co zawiera]

## Metody
- Czyszczenie danych (NaN, duplikaty)
- Wizualizacja (matplotlib, seaborn)
- Statystyka (korelacja, test t)

## Kluczowe odkrycia
1. [Odkrycie 1]
2. [Odkrycie 2]
3. [Odkrycie 3]

## Jak uruchomić
```bash
cd projekt/
source ../.venv/bin/activate
jupyter notebook analiza.ipynb
```
```

---

## 4. Git i GitHub — codzienny workflow

### Podstawowe komendy (używasz CODZIENNIE)

```bash
# Sprawdź co się zmieniło
git status

# Dodaj pliki do commita
git add lab03/lab03_numpy.ipynb
# lub dodaj wszystkie zmienione pliki:
git add .

# Zapisz commit z opisem
git commit -m "L03: rozwiązanie ćwiczenia 2 — broadcasting"

# Wypchnij na GitHub
git push

# Pobierz zmiany (jeśli pracujesz na kilku komputerach)
git pull
```

### Zasady dobrych commitów

```
DOBRZE:
  git commit -m "L05: Ćw. 3 — filtrowanie DataFrame po warunkach"
  git commit -m "L09: dodaj wykres słupkowy przychodów per kategoria"
  git commit -m "Projekt: czyszczenie danych — usunięcie duplikatów"

ŹLE:
  git commit -m "zmiany"
  git commit -m "update"
  git commit -m "aaaa"
  git commit -m "lab gotowe"
```

Wzorzec: `"LXX: co zrobiłeś — szczegół"`

### Co NIE idzie do repozytorium

Plik `.gitignore` chroni Twoje repo przed śmieciami:

```
.venv/                 ← środowisko wirtualne (kilkaset MB!)
__pycache__/           ← skompilowany Python
*.pyc                  ← j.w.
.ipynb_checkpoints/    ← automatyczne kopie notebooków
.DS_Store              ← macOS
Thumbs.db              ← Windows
*.env                  ← klucze API (NIGDY w repo!)
```

---

## 5. Udostępnianie prowadzącemu

### Opcja A: Repozytorium publiczne (zalecane)

Tworzysz repozytorium jako **publiczne** (Public) na GitHubie. Prowadzący wchodzi pod adres:

```
https://github.com/TWÓJ-LOGIN/python2-lab
```

i widzi wszystko: kod, notebooki, historię commitów.

**Zalety:** proste, nie wymaga zaproszenia, buduje publiczne portfolio.

### Opcja B: Repozytorium prywatne + zaproszenie

Jeśli chcesz mieć repo prywatne:
1. Na GitHubie: **Settings** → **Collaborators** → **Add people**
2. Wpisz login GitHub prowadzącego: **sp6jaz**
3. Prowadzący dostanie zaproszenie i zaakceptuje

### Co prowadzący sprawdza

```
CHECKLIST PROWADZĄCEGO:
✓ Czy repozytorium istnieje i jest dostępne
✓ Czy jest README.md z opisem
✓ Czy są foldery labXX/ z notebookami
✓ Czy jest historia commitów (nie jeden commit z wszystkim!)
✓ Czy commity mają sensowne opisy
✓ Czy .venv NIE jest w repozytorium
✓ Czy notebooki się uruchamiają (kod + wyniki widoczne)
```

### Podgląd notebooków na GitHubie

GitHub automatycznie renderuje pliki `.ipynb` — prowadzący widzi Twoje notebooki z kodem, wynikami i wykresami **bez konieczności uruchamiania** lokalnie.

Żeby wyniki były widoczne na GitHubie:
1. Przed commitem: uruchom notebook od początku do końca (**Restart & Run All**)
2. Zapisz notebook (`Ctrl+S`)
3. Commituj i push

```bash
# Po "Restart & Run All" w VS Code:
git add lab05/lab05_pandas.ipynb
git commit -m "L05: rozwiązane ćwiczenia 1-4 z wynikami"
git push
```

Teraz prowadzący widzi na GitHubie: kod + wyniki + wykresy.

---

## 6. Notebooki Jupyter — dobre praktyki

### Struktura notebooka laboratoryjnego

```
Komórka 1 (Markdown): # L05 — Pandas: Series i DataFrame
                       **Imię Nazwisko** | Data

Komórka 2 (kod):      # Importy i setup
                       import pandas as pd
                       import numpy as np

Komórka 3 (Markdown):  ## Ćwiczenie 1: Tworzenie Series
                       (opis zadania)

Komórka 4 (kod):      # Rozwiązanie ćwiczenia 1
                       ...

Komórka 5 (Markdown):  ## Ćwiczenie 2: ...

...

Ostatnia komórka (Markdown): ## Podsumowanie
                              - Czego się nauczyłem/łam
                              - Co było trudne
```

### Zasady

1. **Każde ćwiczenie w osobnej sekcji** (nagłówek Markdown + kod)
2. **Komentarze w kodzie** — nie za dużo, ale kluczowe kroki opisz
3. **Wyniki widoczne** — przed commitem uruchom cały notebook
4. **Nie zostawiaj błędów** — jeśli coś nie działa, zakomentuj i dopisz co nie wyszło

---

## 7. Typowe problemy i rozwiązania

| Problem | Rozwiązanie |
|---------|-------------|
| `git push` odmawia (403/401) | Token wygasł → wygeneruj nowy na GitHub |
| "Not a git repository" | Jesteś w złym katalogu → `cd ~/python2-lab` |
| Notebook nie widzi bibliotek | Nie aktywowałeś venv → `source .venv/bin/activate` |
| `.venv` trafił do repo | Dodaj do `.gitignore`, potem: `git rm -r --cached .venv/` |
| Merge conflict | Przeczytaj co git mówi, edytuj plik, commituj |
| Zapomniałem pushować | `git push` — nigdy nie jest za późno |
| Pracuję na 2 komputerach | `git pull` na początku, `git push` na koniec |

---

## 8. Podsumowanie — minimum na każdym laboratorium

```
✅ Notebook .ipynb z rozwiązanymi ćwiczeniami
✅ Wyniki uruchomione i widoczne (Restart & Run All)
✅ Minimum 2 commity z sensownymi opisami
✅ git push na koniec zajęć
✅ Sprawdzenie w przeglądarce że wszystko widać na GitHubie
```

Prowadzący sprawdza Twoje repo **w dowolnym momencie** — dbaj o porządek od pierwszych zajęć.
