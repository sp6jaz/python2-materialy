# L02 — Ćwiczenia laboratoryjne

## Temat: Jupyter Notebook i pierwsza eksploracja danych

**Programowanie w Pythonie II** | Laboratorium 2
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Przygotowanie stanowiska (zrób to PRZED ćwiczeniami)

Zanim zaczniesz pracę, musisz uruchomić swoje środowisko.

**Gdzie jest mój folder z projektem?** Na zajęciach L01 utworzyłeś folder (np. `moj-projekt`) z plikami `.venv`, `.gitignore`, `README.md`. Jeśli nie pamiętasz gdzie go masz — poszukaj folderu `.venv` na dysku.

**Nie byłeś na L01 / nie masz folderu?** Utwórz go teraz:
```powershell
cd ~\Desktop
mkdir moj-projekt
cd moj-projekt
uv venv
.venv\Scripts\Activate.ps1
uv pip install numpy pandas matplotlib jupyter ipykernel
git init
```
Pełna instrukcja: [01_srodowisko_pracy.md na GitHubie](https://github.com/sp6jaz/python2-materialy/blob/master/dzienne/tydzien-01/wyklad/01_srodowisko_pracy.md)

### Windows — krok po kroku

**Krok 1: Otwórz PowerShell**
- Naciśnij klawisz **Windows**, wpisz `PowerShell`, kliknij "Windows PowerShell"
- Zobaczysz czarne (lub niebieskie) okno z tekstem, np.: `PS C:\Users\Anna>`

**Krok 2: Przejdź do swojego folderu z projektem**

Jeśli na L01 utworzyłeś folder na Pulpicie:
```powershell
cd ~\Desktop\moj-projekt
```

Jeśli w Dokumentach:
```powershell
cd ~\Documents\moj-projekt
```

> `~` to skrót do Twojego katalogu domowego, np. `C:\Users\Anna`

**Krok 3: Sprawdź czy jesteś we właściwym miejscu**
```powershell
ls
```
Powinieneś zobaczyć m.in. folder `.venv` i plik `.gitignore`:
```
    Directory: C:\Users\Anna\Desktop\moj-projekt

Mode         Name
----         ----
d-----       .venv
-a----       .gitignore
-a----       README.md
```

Jeśli **nie widzisz `.venv`** — jesteś w złym folderze! Wróć do kroku 2.

**Krok 4: Aktywuj środowisko wirtualne**
```powershell
.venv\Scripts\Activate.ps1
```

Po aktywacji na początku linii pojawi się `(.venv)`:
```
(.venv) PS C:\Users\Anna\Desktop\moj-projekt>
```

Jeśli widzisz `(.venv)` — środowisko jest aktywne.

Jeśli widzisz **błąd "cannot be loaded because running scripts is disabled"**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Potem spróbuj ponownie: `.venv\Scripts\Activate.ps1`

**Krok 5: Sprawdź czy pakiety działają**
```powershell
python -c "import pandas; import matplotlib; print('Wszystko dziala!')"
```

Powinieneś zobaczyć:
```
Wszystko dziala!
```

Jeśli widzisz `ModuleNotFoundError` — zainstaluj pakiety:
```powershell
uv pip install numpy pandas matplotlib jupyter ipykernel
```

**Krok 6: Otwórz VS Code**
```powershell
code .
```

> Kropka `.` oznacza "otwórz VS Code w tym folderze, w którym teraz jestem". VS Code otworzy się i po lewej stronie (panel Explorer) zobaczysz swoje pliki: `.venv`, `.gitignore`, `README.md`.

### Linux / macOS

```bash
# Krok 1: Otwórz terminal
# Krok 2: Przejdź do folderu z projektem
cd ~/moj-projekt

# Krok 3: Sprawdź czy jesteś we właściwym miejscu
ls    # powinieneś widzieć .venv, .gitignore, README.md

# Krok 4: Aktywuj środowisko
source .venv/bin/activate   # pojawi się (.venv) na początku linii

# Krok 5: Sprawdź pakiety
python -c "import pandas; import matplotlib; print('Wszystko dziala!')"

# Krok 6: Otwórz VS Code
code .
```

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Jupyter Notebook — dokumentacja | https://jupyter-notebook.readthedocs.io/en/stable/ |
| Pandas — szybki start | https://pandas.pydata.org/docs/getting_started/intro_tutorials/ |
| Pandas — `read_csv()` | https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html |
| Pandas — `DataFrame.describe()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html |
| Matplotlib — `pyplot` tutorial | https://matplotlib.org/stable/tutorials/pyplot.html |
| Dataset tips — opis | https://www.kaggle.com/datasets/jsphyg/tipping |

### Kolumny datasetu `tips`

| Kolumna | Opis | Typ |
|---------|------|-----|
| `total_bill` | Całkowita kwota rachunku (USD) | float |
| `tip` | Napiwek (USD) | float |
| `sex` | Płeć osoby płacącej | kategoria: Male/Female |
| `smoker` | Czy osoba pali | kategoria: Yes/No |
| `day` | Dzień tygodnia | kategoria: Thur/Fri/Sat/Sun |
| `time` | Pora posiłku | kategoria: Lunch/Dinner |
| `size` | Liczba osób przy stoliku | int |

---

## Na wykładzie widzieliście `pipeline_demo.ipynb`

Prowadzący pokazał kompletny pipeline analityczny — od pytania biznesowego do wykresu. Teraz **stworzycie własny notebook od zera** i przejdziecie podobny proces samodzielnie.

---

## Ćwiczenie 1: Jupyter Notebook — opanuj narzędzie (20 min)

### Cel
Nauczysz się tworzyć notebook, używać komórek Code i Markdown, oraz poznasz najważniejsze skróty klawiszowe.

### Krok 1 — Utwórz notebook

1. W VS Code kliknij w górnym menu: **View → Command Palette** (albo naciśnij `Ctrl+Shift+P`)
   → pojawi się pasek tekstowy u góry ekranu
2. Zacznij wpisywać: `Create New Jupyter Notebook` → gdy zobaczysz tę opcję, kliknij ją lub naciśnij Enter
   → otworzy się nowy notebook z jedną pustą komórką
3. W **prawym górnym rogu** notebooka zobaczysz przycisk **"Select Kernel"** — kliknij go
   → wybierz **Python Environments** → wybierz pozycję z `.venv` w nazwie
   → jeśli nie widzisz `.venv`: zamknij VS Code, aktywuj venv w terminalu, wpisz `code .` i spróbuj ponownie
4. Zapisz notebook: `Ctrl+S` → nazwa: `lab02_eksploracja.ipynb`

### Krok 2 — Komórka kodu

Kliknij w pustą komórkę (zobaczysz migający kursor) i wpisz:

```python
# Moja pierwsza komórka
print("Witaj w Jupyter Notebook!")
2 + 2
```

Naciśnij **Shift+Enter** żeby uruchomić komórkę.

**Co powinieneś zobaczyć:**
```
Witaj w Jupyter Notebook!
4
```

Dlaczego dwa wyniki? `print()` wypisuje tekst, a notebook automatycznie wyświetla też wynik **ostatniego wyrażenia** w komórce (tutaj: `2 + 2 = 4`).

### Krok 3 — Komórka Markdown

Po uruchomieniu poprzedniej komórki pojawia się nowa pusta komórka pod wynikiem.

1. Kliknij na tę nową komórkę
2. Zmień jej typ na Markdown: w lewym górnym rogu komórki zobaczysz napis **"Code"** — kliknij go i wybierz **"Markdown"** z listy (alternatywnie: naciśnij `Esc` a potem klawisz `M`)
3. Wpisz:

```markdown
# Laboratorium 2 — Eksploracja danych

**Autor:** [Twoje imię]
**Data:** [dzisiejsza data]

## Cel
Wczytanie i eksploracja datasetu z danymi z restauracji.
```

4. Naciśnij `Shift+Enter` — tekst Markdown zamieni się w sformatowany nagłówek, pogrubienia itp.

**Co powinieneś zobaczyć:** Ładnie sformatowany tekst z dużym nagłówkiem "Laboratorium 2" i pogrubionym autorem. Jeśli nadal widzisz surowy tekst z `#` i `**` — upewnij się, że typ komórki to Markdown (nie Code).

### Krok 4 — Przećwicz skróty

Ważne: skróty klawiaturowe działają w **trybie komend** (niebieska/szara ramka wokół komórki). Żeby wejść w tryb komend, naciśnij `Esc`. Żeby wrócić do edycji, naciśnij `Enter`.

Przećwicz każdy skrót po kolei:

| Co zrobić | Jak |
|-----------|-----|
| Dodaj komórkę poniżej | `Esc` → `B` |
| Dodaj komórkę powyżej | `Esc` → `A` |
| Zmień na Markdown | `Esc` → `M` |
| Zmień na Code | `Esc` → `Y` |
| Usuń komórkę | `Esc` → `D D` (dwa razy D) |
| Cofnij usunięcie | `Esc` → `Z` |
| Uruchom i przejdź dalej | `Shift+Enter` |
| Uruchom i zostań | `Ctrl+Enter` |

### Sprawdzenie ✅

Twój notebook ma przynajmniej:
- 1 komórkę Markdown z nagłówkiem i opisem
- 2 komórki Code z uruchomionym kodem
- Wiesz jak dodawać i usuwać komórki

---

## Ćwiczenie 2: Wczytanie i poznanie danych (25 min)

### Cel
Wczytaj prawdziwy dataset i poznaj go używając metod Pandas. Nauczysz się wzorca, który będziesz powtarzać przy **każdej** analizie danych.

### Krok 1 — Import bibliotek

Dodaj nową komórkę Markdown (Esc → B → M) i wpisz:
```markdown
## Krok 1: Import bibliotek
```

Dodaj pod nią komórkę Code (Esc → B) i wpisz:
```python
import pandas as pd
import matplotlib.pyplot as plt
```

Uruchom ją (Shift+Enter). Nic się nie wyświetli — i to jest OK! Import bibliotek nie produkuje wyniku, po prostu "otwiera skrzynkę z narzędziami".

**Co oznacza ten kod:**
- `import pandas as pd` — ładujesz bibliotekę Pandas i nadajesz jej skrót `pd`. Od teraz zamiast pisać `pandas.read_csv()` piszesz krótko `pd.read_csv()`
- `import matplotlib.pyplot as plt` — ładujesz moduł do wykresów, skrót `plt`

### Krok 2 — Wczytaj dane

Komórka Markdown:
```markdown
## Krok 2: Wczytanie danych
Dataset: rachunki z restauracji (244 obserwacje, 7 zmiennych).
```

Komórka Code:
```python
df = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv')
print(f"Dane wczytane: {df.shape[0]} wierszy, {df.shape[1]} kolumn")
```

**Co powinieneś zobaczyć:**
```
Dane wczytane: 244 wierszy, 7 kolumn
```

**Co oznacza ten kod:**
- `pd.read_csv(...)` — wczytuje plik CSV (tabelka rozdzielona przecinkami) z podanego adresu URL
- `df` — to nazwa zmiennej, w której trzymasz tabelę. Skrót od DataFrame. Możesz nazwać ją jak chcesz, ale `df` to konwencja
- `df.shape` — zwraca krotkę `(wiersze, kolumny)`, więc `df.shape[0]` to liczba wierszy

Jeśli zamiast wyniku widzisz **błąd** — sprawdź:
- Czy masz internet? (dane pobierane z sieci)
- Czy skopiowałeś cały URL? (musi zaczynać się od `https://`)
- Czy uruchomiłeś komórkę z importem (Krok 1)?

### Krok 3 — Poznaj dane

Dodaj komórkę Markdown: `## Krok 3: Poznanie danych`

Każdą z poniższych metod uruchom w **osobnej komórce** (żeby widzieć wynik). Dodajesz nową komórkę: Esc → B.

```python
# Pierwsze 5 wierszy — ZAWSZE zacznij od tego!
df.head()
```

**Co zobaczysz:** Tabelka z 5 wierszami i 7 kolumnami. Każdy wiersz to jeden rachunek z restauracji. Przeczytaj nazwy kolumn — są po angielsku (total_bill = rachunek, tip = napiwek, itd.). Pełny opis kolumn znajdziesz w tabeli na górze tego dokumentu.

```python
# Ostatnie 5 wierszy
df.tail()
```

```python
# Informacje o typach i brakujących danych
df.info()
```

**Co zobaczysz:** Lista kolumn z typem danych (float64, int64, object) i liczbą niepustych wartości. Jeśli przy każdej kolumnie jest "244 non-null" — nie ma brakujących danych (w tym datasecie tak jest).

```python
# Statystyki opisowe — podsumowanie liczbowe
df.describe()
```

**Co zobaczysz:** Tabelka ze statystykami: count (ile), mean (średnia), std (odchylenie standardowe), min, 25%/50%/75% (kwartyle), max. Np. średni rachunek to ~19.79 $, a najwyższy — 50.81 $.

```python
# Typy danych w każdej kolumnie
df.dtypes
```

```python
# Nazwy kolumn
df.columns.tolist()
```

### Krok 4 — Napisz wnioski

Dodaj komórkę Markdown z wnioskami:

```markdown
## Wnioski z eksploracji
- Dataset zawiera ... wierszy i ... kolumn
- Kolumny numeryczne: ...
- Kolumny tekstowe: ...
- Brakujące wartości: ... (sprawdź wynik info())
- Średni rachunek wynosi ... $
```

### Sprawdzenie ✅

- Notebook ma minimum 8 komórek (Markdown + Code naprzemiennie)
- Wiesz ile wierszy i kolumn ma dataset
- Potrafisz powiedzieć jakie są typy danych w każdej kolumnie

---

## Ćwiczenie 3: Pytania biznesowe (25 min)

### Cel
Odpowiedz na pytania biznesowe korzystając z danych. Tu zaczynasz myśleć jak analityk — **dostajesz pytanie, szukasz odpowiedzi w danych**.

### Kontekst
Jesteś analitykiem w restauracji. Menedżer zadaje ci pytania — odpowiedz za pomocą kodu Python.

Dodaj komórkę Markdown: `## Pytania biznesowe`

### Pytanie 1: Jaki był najwyższy rachunek?

Chcemy wyciągnąć jedną wartość z kolumny. Wzorzec:
```python
df['nazwa_kolumny'].max()    # największa wartość
df['nazwa_kolumny'].min()    # najmniejsza wartość
df['nazwa_kolumny'].mean()   # średnia
```

Zamień `nazwa_kolumny` na właściwą kolumnę (podpowiedź: rachunek po angielsku to `total_bill`):

```python
# Pytanie 1: Najwyższy rachunek
# Twój kod tutaj
```

### Pytanie 2: Ile rachunków obsłużono w każdym dniu tygodnia?

Chcemy policzyć ile razy każda wartość występuje w kolumnie. Wzorzec:
```python
df['nazwa_kolumny'].value_counts()   # zlicza wystąpienia każdej wartości
```

Podpowiedź: kolumna z dniami tygodnia to `day`.

```python
# Pytanie 2: Rachunki wg dnia
# Twój kod tutaj
```

### Pytanie 3: Jaki jest średni napiwek dla palaczy vs niepalących?

Tu potrzebujemy pogrupować dane (jak tabela przestawna w Excelu). Wzorzec:
```python
df.groupby('kolumna_grupująca')['kolumna_liczbowa'].mean()
```

Tłumaczenie: "weź dane, pogrupuj je wg [kolumna_grupująca], i dla każdej grupy policz średnią z [kolumna_liczbowa]".

Podpowiedź: palący/niepalący to kolumna `smoker`, napiwek to `tip`.

```python
# Pytanie 3: Napiwki — palący vs niepalący
# Twój kod tutaj
```

### Pytanie 4: Jaki procent rachunku stanowi napiwek (średnio)?

Tu tworzymy **nową kolumnę** w DataFrame — obliczoną z dwóch istniejących. Wzorzec:
```python
df['nowa_kolumna'] = df['kolumna_a'] / df['kolumna_b'] * 100
```

Podpowiedź: napiwek to `tip`, rachunek to `total_bill`. Po stworzeniu kolumny użyj `.mean()` żeby policzyć średnią.

```python
# Pytanie 4: Procent napiwku
# Twój kod tutaj
```

### Pytanie 5: Który dzień + pora (Lunch/Dinner) przynosi najwyższe rachunki?

To jak pytanie 3, ale grupujesz po **dwóch kolumnach naraz**. Wzorzec:
```python
df.groupby(['kolumna1', 'kolumna2'])['kolumna_liczbowa'].mean()
```

Podpowiedź: dzień to `day`, pora to `time`, rachunek to `total_bill`.

```python
# Pytanie 5: Dzień + pora → rachunki
# Twój kod tutaj
```

**Nie martw się jeśli nie udało się odpowiedzieć na wszystkie pytania.** Pytania 4 i 5 są trudniejsze — wrócisz do tych technik w kolejnych tygodniach i staną się naturalne.

### Sprawdzenie ✅

Oczekiwane odpowiedzi (sprawdź czy się zgadzają):
1. Najwyższy rachunek: **50.81 $**
2. Sobota ma najwięcej rachunków: **87**
3. Palący mają średnio wyższy napiwek (~3.01 $) niż niepalący (~2.99 $) — minimalna różnica
4. Średni procent napiwku: **~16.1%**
5. Najwyższe rachunki: niedziela, obiad (Dinner)

---

## Ćwiczenie 4: Pierwszy wykres + commit (10 min)

### Cel
Stwórz wykres i wypchnij notebook na GitHub — zamknij pętlę: kod → wynik → repozytorium.

### Krok 1 — Wykres

Dodaj komórkę Markdown: `## Wizualizacja`

Dodaj komórkę Code i wpisz (albo skopiuj — tym razem wolno!):

```python
# Średni napiwek wg dnia tygodnia
df.groupby('day')['tip'].mean().plot(kind='bar', title='Średni napiwek wg dnia tygodnia')
plt.ylabel('Napiwek ($)')
plt.tight_layout()
plt.show()
```

Uruchom (Shift+Enter).

**Co powinieneś zobaczyć:** Wykres słupkowy z 4 słupkami (Thur, Fri, Sat, Sun) — wysokość słupka to średni napiwek w danym dniu.

**Co oznacza ten kod:**
- `df.groupby('day')['tip'].mean()` — pogrupuj wg dnia i policz średni napiwek (znasz to z pytania 3!)
- `.plot(kind='bar')` — narysuj wykres słupkowy
- `plt.ylabel(...)` — dodaj podpis osi Y
- `plt.tight_layout()` — dopasuj marginesy żeby nic nie było ucięte
- `plt.show()` — wyświetl wykres

### Krok 2 — Bonus: drugi wykres (jeśli masz czas)

```python
# Rozkład rachunków — histogram
df['total_bill'].plot(kind='hist', bins=20, title='Rozkład kwot rachunków', edgecolor='black')
plt.xlabel('Rachunek ($)')
plt.ylabel('Liczba rachunków')
plt.tight_layout()
plt.show()
```

**Co zobaczysz:** Histogram — oś X to kwota rachunku, oś Y to ile rachunków miało taką kwotę. Większość rachunków jest w zakresie 10-25 $.

### Krok 3 — Zapisz i commituj

Zapisz notebook w VS Code (`Ctrl+S`), potem otwórz **terminal** w VS Code (menu: Terminal → New Terminal) lub wróć do PowerShell:

```powershell
# Windows (PowerShell)
git add lab02_eksploracja.ipynb
git commit -m "L02: eksploracja datasetu tips — pipeline analityczny"
git push
```

```bash
# Linux / macOS
git add lab02_eksploracja.ipynb
git commit -m "L02: eksploracja datasetu tips — pipeline analityczny"
git push
```

Jeśli `git push` pyta o login/hasło — wpisz swoją nazwę użytkownika GitHub i **token** (nie hasło!). Instrukcja tworzenia tokena: [jak_pracowac.md na GitHubie](https://github.com/sp6jaz/python2-materialy/blob/master/dzienne/tydzien-01/wyklad/jak_pracowac.md)

### Sprawdzenie ✅

- Wejdź na **github.com** → Twoje repozytorium → plik `lab02_eksploracja.ipynb` powinien być widoczny
- GitHub **renderuje notebooki** — zobaczysz kod, wyniki i wykresy bezpośrednio w przeglądarce
- Notebook zawiera komórki Markdown z opisami (nie sam kod!)

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Tworzyć i nawigować po Jupyter Notebook (skróty, typy komórek)
- ✅ Wczytać dane z CSV do DataFrame
- ✅ Poznać dane: head, info, describe, dtypes, shape
- ✅ Odpowiadać na pytania biznesowe kodem
- ✅ Tworzyć proste wykresy

**Na następnych zajęciach:** NumPy — szybkie obliczenia na tablicach danych.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| Notebook nie wyświetla wykresów | Dodaj `%matplotlib inline` jako pierwszą komórkę |
| `FileNotFoundError` przy `read_csv()` | Sprawdź URL — skopiuj cały link z instrukcji |
| `KeyError: 'kolumna'` | Sprawdź pisownię: `df.columns` pokaże nazwy kolumn |
| Nie wiem jak dodać nową komórkę | Naciśnij Esc → B (nowa komórka pod aktualną) lub Esc → A (nad) |
| Komórka nie wykonuje się | Naciśnij Shift+Enter lub Ctrl+Enter |
| `NameError: name 'df' is not defined` | Wykonaj komórkę z `df = pd.read_csv(...)` przed innymi |
