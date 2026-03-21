# L05 — Ćwiczenia laboratoryjne

## Temat: Pandas — Series, DataFrame, eksploracja danych

**Programowanie w Pythonie II** | Laboratorium 5
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Po tym laboratorium potrafisz:

1. **Tworzyć** Series z listy i słownika, wykonywać operacje i filtrowanie (Bloom 3)
2. **Tworzyć** DataFrame z dict i wczytywać dane z pliku CSV (Bloom 3)
3. **Stosować** metody eksploracyjne: `head()`, `info()`, `describe()`, `value_counts()`, `isna()` (Bloom 3)
4. **Analizować** dane i formułować obserwacje biznesowe (Bloom 4)

Na wykładzie poznaliście Series, DataFrame i EDA. Teraz przećwiczycie to samodzielnie na danych biznesowych.

---

## Start

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: `lab05_pandas_intro.ipynb`

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Pandas — oficjalna dokumentacja | https://pandas.pydata.org/docs/ |
| Pandas — 10 Minutes to Pandas | https://pandas.pydata.org/docs/user_guide/10min.html |
| Pandas — `Series` | https://pandas.pydata.org/docs/reference/api/pandas.Series.html |
| Pandas — `DataFrame` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html |
| Pandas — `read_csv()` | https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html |
| Pandas — `describe()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html |
| Palmer Penguins — opis datasetu | https://allisonhorst.github.io/palmerpenguins/ |

### Kolumny datasetu `penguins`

| Kolumna | Opis | Typ |
|---------|------|-----|
| `species` | Gatunek pingwina | kategoria: Adelie/Chinstrap/Gentoo |
| `island` | Wyspa na Antarktydzie | kategoria: Torgersen/Biscoe/Dream |
| `bill_length_mm` | Długość dzioba (mm) | float |
| `bill_depth_mm` | Głębokość dzioba (mm) | float |
| `flipper_length_mm` | Długość płetwy (mm) | float |
| `body_mass_g` | Masa ciała (g) | int |
| `sex` | Płeć | kategoria: Male/Female |

---

## Ćwiczenie 1: Series — tworzenie i operacje (20 min)

### Cel
Utwórz Series z różnych źródeł i wykonaj podstawowe operacje.

### Krok 1 — Series z listy i dict

```python
import pandas as pd
import numpy as np

# Series z listy — domyślny indeks (0, 1, 2, ...)
oceny = pd.Series([4.5, 3.0, 5.0, 3.5, 4.0])
print(oceny)
```

**Zadanie 1a:** Utwórz Series `pensje` z dict:
```python
# Klucze: 'Anna', 'Jan', 'Ewa', 'Marek', 'Kasia'
# Wartości: 5500, 7200, 4800, 9100, 6300
```

**Zadanie 1b:** Odpowiedz na pytania o `pensje`:
```python
# 1. Wyświetl imię osoby zarabiającej najwięcej (użyj idxmax())
# 2. Oblicz średnią pensję
# 3. Wyświetl imiona osób zarabiających powyżej średniej (filtrowanie boolean)
# 4. Policz ile osób zarabia poniżej 6000 (użyj len() lub .sum())
```

### Krok 2 — Operacje na Series

**Zadanie 1c:** Oblicz pensje po zmianach:
```python
# 1. Oblicz pensje po podwyżce 10% dla wszystkich (pensje * 1.10)
# 2. Oblicz pensje po premii 500 zł dla wszystkich (pensje + 500)
# 3. Oblicz nową pensję = (pensja * 1.10) + 500
# 4. Wyświetl ranking nowych pensji od najwyższej (użyj sort_values)
```

### Sprawdzenie ✅

- 1a: `pensje['Marek']` = 9100
- 1b: Najwięcej: Marek; Średnia: 6580.0; Powyżej średniej: Jan (7200), Marek (9100) — Kasia (6300 < 6580) nie łapie się
- 1c: Nowa pensja Anny = 5500 * 1.10 + 500 = 6550.0

---

## Ćwiczenie 2: DataFrame — tworzenie i atrybuty (20 min)

### Cel
Utwórz DataFrame z dict i wczytaj dane z pliku CSV.

### Krok 1 — DataFrame z dict

```python
# Dane o produktach sklepu internetowego
sklep = pd.DataFrame({
    'produkt': ['Laptop', 'Tablet', 'Smartfon', 'Słuchawki', 'Monitor'],
    'cena': [3500, 1800, 2500, 350, 2200],
    'stan_magazynowy': [45, 120, 200, 500, 75],
    'kategoria': ['Komputery', 'Mobilne', 'Mobilne', 'Akcesoria', 'Komputery']
})
```

**Zadanie 2a:** Zbadaj DataFrame `sklep`:
```python
# 1. Wyświetl kształt tabeli (shape)
# 2. Wyświetl nazwy kolumn (columns)
# 3. Wyświetl typy danych w każdej kolumnie (dtypes)
# 4. Wyświetl pierwsze 3 wiersze (head)
```

**Zadanie 2b:** Dodaj nowe kolumny do DataFrame `sklep`:
```python
# 1. Dodaj kolumnę 'wartosc_magazynu' = cena * stan_magazynowy
# 2. Dodaj kolumnę 'cena_z_vat' = cena * 1.23
# 3. Wyświetl cały DataFrame z nowymi kolumnami
```

### Krok 2 — Wczytanie CSV

```python
# Wczytaj dataset tips
url = 'https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv'
tips = pd.read_csv(url)
```

**Zadanie 2c:** Podstawowa eksploracja datasetu `tips`:
```python
# 1. Wyświetl ile wierszy i kolumn ma dataset (shape)
# 2. Wyświetl ostatnie 5 wierszy (tail)
# 3. Wyświetl 3 losowe wiersze (sample)
# 4. Wyświetl typy danych w każdej kolumnie (dtypes)
```

### Sprawdzenie ✅

- 2a: shape = (5, 4); kolumny = ['produkt', 'cena', 'stan_magazynowy', 'kategoria']
- 2b: Wartość magazynu Laptop = 3500 × 45 = 157500
- 2c: tips.shape = (244, 7)

---

## Ćwiczenie 3: Eksploracja datasetu — samodzielna analiza (30 min)

### Cel
Przeprowadź pełną eksplorację EDA na prawdziwym datasecie.

### Dane

```python
url = 'https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv'
penguins = pd.read_csv(url)
```

### Zadania

**Zadanie 3a: Pierwszy rzut oka**
```python
# 1. Wyświetl head(10)
# 2. Wyświetl shape
# 3. Uruchom info() — ile brakujących wartości widzisz?
```

**Zadanie 3b: Statystyki opisowe**
```python
# 1. Uruchom describe() — co mówią ci średnie i odchylenia?
# 2. Uruchom describe(include='all') — co dodają kolumny tekstowe?
# 3. Jaka jest mediana masy ciała (body_mass_g)?
```

**Zadanie 3c: Rozkłady wartości**
```python
# 1. Ile jest pingwinów każdego gatunku? (value_counts na 'species')
# 2. Ile pingwinów na każdej wyspie? (value_counts na 'island')
# 3. Rozkład płci (value_counts na 'sex') — czy jest zbalansowany?
# 4. Jaki procent to gatunek Adelie? (normalize=True)
```

**Zadanie 3d: Brakujące dane**
```python
# 1. Policz brakujące wartości w każdej kolumnie (isna().sum())
# 2. Jaki procent danych brakuje w kolumnie 'sex'?
#    Podpowiedź: braki / len(penguins) * 100
```

**Zadanie 3e: Wnioski (refleksja)**
W komórce Markdown napisz **minimum 5 obserwacji** o datasecie. Każda obserwacja to jedno zdanie poparte liczbą z twoich obliczeń powyżej. Przykłady:
- "Dataset zawiera X pingwinów z Y gatunków..."
- "Najczęstszy gatunek to... (X osobników, Y%)"
- "Brakuje danych w kolumnach... (łącznie X braków)"
- "Średnia masa ciała to... g (mediana: ... g)"
- "Pingwiny mieszkają na X wyspach, najliczniej na..."

### Sprawdzenie ✅

- 3a: shape = (344, 7); info() pokaże, że 4 kolumny mają po 342 non-null, sex ma 333 non-null
- 3b: Mediana body_mass_g = 4050.0 g
- 3c: Adelie: 152, Gentoo: 124, Chinstrap: 68; Adelie = 44.2%
- 3d: sex: 11 braków → 11/344 = 3.2%

---

## Ćwiczenie 4: Pytania biznesowe + commit (15 min)

### Cel
Odpowiedz na pytania biznesowe o danych i zapisz pracę w Git.

### Dane — wróć do datasetu tips

```python
tips = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv')

# Dodaj kolumnę z procentem napiwku
tips['tip_pct'] = (tips['tip'] / tips['total_bill'] * 100).round(1)
```

### Pytania

**Zadanie 4a:**
```python
# 1. Oblicz średni rachunek (total_bill)
# 2. Oblicz średni napiwek w procentach (tip_pct)
# 3. Wyświetl który dzień ma najwięcej rachunków (value_counts na 'day')
# 4. Policz ile rachunków jest od palaczy (value_counts na 'smoker')
# 5. Wyświetl describe() tylko dla kolumny 'tip' — jaka jest mediana napiwku?
# 6. Jaki procent rachunków pochodzi z obiadu (Dinner)?
#    Podpowiedź: value_counts(normalize=True) na kolumnie 'time'
# 7. Ile unikalnych rozmiarów grup jest w danych? (nunique na 'size')
```

### Commit

W terminalu VS Code:
```
git add lab05_pandas_intro.ipynb
git commit -m "L05: Pandas — Series, DataFrame, eksploracja EDA"
git push
```

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Tworzyć Series z listy, dict i z kolumny DataFrame
- ✅ Tworzyć DataFrame z dict i wczytywać z CSV
- ✅ Eksplorować dane: head(), info(), describe(), value_counts(), isna()
- ✅ Dodawać nowe kolumny obliczone z istniejących
- ✅ Wyciągać wnioski z danych (EDA)

**Na następnych zajęciach:** loc/iloc, filtrowanie z warunkami logicznymi, sortowanie — zaczniecie odpowiadać na precyzyjne pytania o danych.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `KeyError: 'nazwa_kolumny'` | Sprawdź dokładną pisownię: `df.columns` wyświetli wszystkie kolumny |
| Różnica `df['kol']` vs `df.kol` | Oba działają, ale `df['kol']` jest bezpieczniejsze (działa zawsze, nawet gdy nazwa ma spacje) |
| `NaN` w wynikach | Dane zawierają brakujące wartości. `df.isna().sum()` pokaże ile w każdej kolumnie |
| Series vs DataFrame | `df['kol']` -> Series (jedna kolumna). `df[['kol1','kol2']]` -> DataFrame (tabela) |
| `read_csv()` — URLError | Sprawdź połączenie z internetem |
| Activate.ps1 nie działa (security) | `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` |
| Nie wiem jak filtrować | `df[df['kolumna'] > wartość]` — warunek w nawiasach kwadratowych |
