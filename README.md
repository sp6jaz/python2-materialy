# Programowanie w języku Python II

**Politechnika Opolska, WEAiI**
**Kierunek:** Analityka danych w biznesie, semestr 2
**Prowadzący:** dr hab. inż. Jarosław Zygarlicki

## O kursie

Kurs uczy praktycznego wykorzystania Pythona w analizie danych biznesowych. Poznasz profesjonalne narzędzia i biblioteki używane w branży.

## Jak wygląda semestr?

Kurs składa się z dwóch faz:

1. **W01–W10: Wspólne ćwiczenia** — wszyscy pracują na tych samych danych, poznając kolejne narzędzia (NumPy, Pandas, wykresy). Każdy tydzień dodaje nową umiejętność.
2. **W11–W14: Mini-projekt** — wybierasz własny dataset i stosujesz wszystkie poznane techniki: czyszczenie, analiza, wizualizacja, statystyka.
3. **W15: Prezentacja** — pokazujesz swój mini-projekt grupie.

Cały kod i wyniki trzymasz w swoim repozytorium na GitHubie — na koniec masz gotowe portfolio.

## Narzędzia

| Narzędzie | Do czego |
|-----------|----------|
| Python 3.10+ | język programowania |
| uv | menedżer pakietów (szybszy od pip) |
| VS Code | edytor + Jupyter + Git |
| Git + GitHub | kontrola wersji, portfolio |

## Struktura materiałów

```
dzienne/          ← studia stacjonarne (15 tygodni)
  tydzien-01/     ← materiały z 1. tygodnia
  tydzien-02/     ← materiały z 2. tygodnia
  ...
```

Materiały pojawiają się **tydzień po tygodniu** zgodnie z harmonogramem zajęć.

> **Skrypt do samodzielnej nauki** — w przygotowaniu, pojawi się w trakcie semestru.

## Harmonogram — studia dzienne (poniedziałki)

| Tydz. | Data | Temat |
|-------|------|-------|
| W01 | 23.02.2026 | Warsztat pracy analityka — Git, Markdown, VS Code |
| W02 | 02.03.2026 | Wprowadzenie do analizy danych — pipeline, Jupyter |
| W03 | 09.03.2026 | NumPy — podstawy |
| W04 | 16.03.2026 | NumPy — zaawansowane |
| W05 | 23.03.2026 | Pandas — Series i DataFrame |
| W06 | 30.03.2026 | Pandas — selekcja i filtrowanie |
| — | 06.04.2026 | *Przerwa świąteczna* |
| W07 | 13.04.2026 | Pandas — czyszczenie danych |
| W08 | 20.04.2026 | Pandas — łączenie i agregacja |
| W09 | 27.04.2026 | Matplotlib — podstawy |
| W10 | 04.05.2026 | Matplotlib + Seaborn — zaawansowane |
| W11 | 11.05.2026 | Statystyka opisowa |
| W12 | 18.05.2026 | Statystyka — rozkłady i testy |
| W13 | 25.05.2026 | Zaawansowane biblioteki |
| W14 | 01.06.2026 | LLM i AI w analizie danych |
| W15 | 08.06.2026 | Prezentacje mini-projektów |

### Logika kursu

| Tydzień | Rola w kursie | Co umiesz po tym bloku |
|---------|---------------|------------------------|
| W01 | Warsztat | Git, VS Code, venv — narzędzia gotowe do pracy |
| W02 | Panorama | Cały pipeline od pytania do decyzji — wiesz po co to wszystko |
| W03–04 | Fundament | NumPy — szybkie obliczenia na tablicach danych |
| W05–08 | Rdzeń kursu | Pandas — od wczytania danych po czyszczenie i agregację |
| W09–10 | Wizualizacja | Matplotlib + Seaborn — wykresy i dashboardy |
| W11–12 | Statystyka | Statystyka opisowa + testy hipotez — na własnym datasecie |
| W13 | Rozszerzenia | scikit-learn, Plotly — mini-projekt |
| W14 | AI | LLM i AI w analizie danych — mini-projekt |
| W15 | Zamknięcie | Prezentacje mini-projektów, podsumowanie semestru |

## Szybki start

```bash
# 1. Zainstaluj narzędzia (szczegóły w materiałach W01)
# Python: python.org | uv: astral.sh/uv | VS Code: code.visualstudio.com | Git: git-scm.com

# 2. Sklonuj to repo
git clone https://github.com/sp6jaz/python2-materialy.git
cd python2-materialy

# 3. Utwórz środowisko
uv venv
source .venv/bin/activate       # Linux/macOS
# .venv\Scripts\Activate.ps1    # Windows

# 4. Zainstaluj pakiety
uv pip install -r requirements.txt
```

## Kontakt

- Moodle: [link do kursu]
- GitHub prowadzącego: [sp6jaz](https://github.com/sp6jaz)
