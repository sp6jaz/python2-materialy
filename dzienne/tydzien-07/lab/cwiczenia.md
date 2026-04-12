# L07 — Ćwiczenia laboratoryjne

## Temat: Pandas — czyszczenie danych

**Programowanie w Pythonie II** | Laboratorium 7
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Po tym laboratorium potrafisz:

1. **Diagnozować** jakość danych metodami `info()`, `isna()`, `describe()`
2. **Stosować** `fillna()` i `dropna()` z uzasadnionym wyborem strategii
3. **Wykrywać i usuwać** duplikaty (`duplicated()`, `drop_duplicates()`)
4. **Konwertować** typy: `pd.to_numeric()`, `pd.to_datetime()` z `errors='coerce'`
5. **Czyścić** teksty: `str.strip()`, `str.title()`, `str.replace()`, `str.contains()`
6. **Budować** kompletny pipeline czyszczenia od brudnych danych do raportu

---

## Start

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: **`lab07_cleaning.ipynb`**

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Pandas — Working with missing data | https://pandas.pydata.org/docs/user_guide/missing_data.html |
| Pandas — `isna()` / `notna()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.isna.html |
| Pandas — `fillna()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.fillna.html |
| Pandas — `dropna()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.dropna.html |
| Pandas — `duplicated()` / `drop_duplicates()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.duplicated.html |
| Pandas — `astype()` (zmiana typów) | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.astype.html |
| Pandas — `str` accessor (operacje tekstowe) | https://pandas.pydata.org/docs/user_guide/text.html |

### Pipeline czyszczenia danych — schemat

Typowy pipeline czyszczenia wykonujesz zawsze w tej kolejności:
1. **Diagnoza** — `df.info()`, `df.isna().sum()`, `df.duplicated().sum()`
2. **Duplikaty** — `df.drop_duplicates()`
3. **Braki (NaN)** — `df.fillna()` lub `df.dropna()`
4. **Typy danych** — `pd.to_numeric()`, `pd.to_datetime()`, `df.astype()`
5. **Tekst** — `df['kol'].str.strip()`, `.str.lower()`, `.str.replace()`
6. **Walidacja** — `df.info()`, `df.describe()` — sprawdź czy wszystko OK

---

## Dane — brudny dataset HR

Na dzisiejszych zajęciach będziemy czyścić dane z działu HR pewnej firmy.
Dataset zawiera: brakujące wartości, duplikaty, liczby zapisane jako tekst, niespójne nazwy działów.

```python
import pandas as pd
import numpy as np

data = {
    'id_pracownika': [1,2,3,4,5,6,7,8,9,10,
                      11,12,13,14,15,16,17,18,19,20,
                      3,7,12,18,5,      # duplikaty — te same id!
                      21,22,23,24,25],
    'imie': ['Anna', 'Bartek', 'CELINA', 'darek', 'Ewa',
             'Filip', 'Gosia', 'HENRYK', 'irena', 'Jan',
             'Kasia', 'Leszek', 'Marta', 'norbert', 'OLGA',
             'Piotr', 'Renata', 'sławek', 'Teresa', 'Urszula',
             'CELINA', 'Gosia', 'Leszek', 'sławek', 'Ewa',
             'Wanda', 'Xawery', 'Yvonne', 'Zbyszek', 'Agata'],
    'dzial': ['Sprzedaz', 'IT', 'HR', 'sprzedaz', 'IT',
              'HR', 'Sprzedaz', 'it', 'HR', 'Sprzedaz',
              'IT', 'HR', 'sprzedaz', 'IT', 'HR',
              'Sprzedaz', 'it', 'HR', 'Sprzedaz', 'IT',
              'HR', 'Sprzedaz', 'HR', 'HR', 'IT',
              'Sprzedaz', 'IT', 'hr', 'Sprzedaz', 'IT'],
    'wynagrodzenie': ['4500', '6200', '3800', '5100', '7500',
                      '4200', '5800', '6900', '3500', '4800',
                      '7200', '4100', '5500', '6800', '3900',
                      '5200', '4700', '6100', '3800', '5400',
                      '3800', '5800', '4100', '6100', '7500',
                      'brak', '5000', None, '4300', '6600'],
    'data_zatrudnienia': ['2020-03-15', '2019-07-22', '2021-01-10',
                          '2018-05-30', '2022-11-01', '2020-08-14',
                          '2019-12-05', '2021-06-18', '2017-09-23',
                          '2023-02-07', '2020-04-11', '2018-11-28',
                          '2022-07-15', '2019-03-19', '2021-10-08',
                          '2020-06-25', '2018-08-31', '2022-02-14',
                          '2019-05-07', '2021-09-20', '2021-01-10',
                          '2019-12-05', '2018-11-28', '2022-02-14',
                          '2022-11-01', '2023-01-15', '2022-05-20',
                          None, '2020-10-11', '2019-08-03'],
    'ocena_roczna': [4.5, 3.8, None, 4.2, 5.0,
                     3.5, 4.7, None, 4.1, 3.9,
                     5.0, 4.3, 3.6, None, 4.8,
                     3.7, 4.4, 4.9, None, 3.8,
                     None, 4.7, 4.3, 4.9, 5.0,
                     4.6, None, 4.9, 3.5, 4.1]
}

df = pd.DataFrame(data)
print(f"Wczytano dataset: {df.shape[0]} wierszy, {df.shape[1]} kolumn")
df.head(10)
```

---

## Ćwiczenie 1: Brakujące wartości (20 min)

### Cel
Osoba studiująca stosuje `isna()`, `fillna()`, `dropna()` do diagnozy i uzupełniania brakujących wartości.

### Zadanie 1a — Diagnoza

```python
# 1. Wyświetl info() aby zobaczyć typy danych i liczbę wartości non-null
# 2. Policz brakujące wartości w każdej kolumnie (isna().sum())
# 3. Oblicz procent braków per kolumna (zaokrąglij do 1 miejsca po przecinku)
# 4. Wyświetl wiersze, które mają przynajmniej jeden brak (any(axis=1))
```

**Wskazówki:**
- `df.info()` — przegląd typów i braków
- `df.isna().sum()` — suma NaN per kolumna
- `df.isna().sum() / len(df) * 100` — procent
- `df[df.isna().any(axis=1)]` — wiersze z NaN

### Zadanie 1b — Wynagrodzenie: 'brak' i None

Kolumna `wynagrodzenie` ma dwa problemy:
1. Wartość tekstowa `'brak'` zamiast NaN
2. Wartość `None` (staje się NaN przy wczytaniu)

```python
# 1. Sprawdź unikalne wartości w kolumnie wynagrodzenie
#    df['wynagrodzenie'].unique()

# 2. Zamień 'brak' na np.nan
#    df['wynagrodzenie'] = df['wynagrodzenie'].replace('brak', np.nan)

# 3. Skonwertuj wynagrodzenie na float używając pd.to_numeric z errors='coerce'
#    df['wynagrodzenie'] = pd.to_numeric(df['wynagrodzenie'], errors='coerce')

# 4. Ile NaN jest teraz w wynagrodzenie?
```

### Zadanie 1c — Strategie fillna

```python
# 1. Oblicz medianę wynagrodzenia (ignorując NaN — to domyślne zachowanie)
#    mediana = df['wynagrodzenie'].median()
#    print(f"Mediana: {mediana}")

# 2. Wypełnij NaN w wynagrodzeniu medianą
#    df['wynagrodzenie'] = df['wynagrodzenie'].fillna(mediana)

# 3. Oblicz średnią ocena_roczna (zaokrąglij do 2 miejsc)
#    srednia = round(df['ocena_roczna'].mean(), 2)
#    print(f"Srednia ocena: {srednia}")

# 4. Wypełnij NaN w ocena_roczna średnią
#    df['ocena_roczna'] = df['ocena_roczna'].fillna(srednia)

# 5. Sprawdź ile NaN zostało w każdej kolumnie
```

### Zadanie 1d — dropna

```python
# 1. Ile wierszy zostanie po usunięciu wierszy z brakiem w 'data_zatrudnienia'?
#    df_bez_brakow = df.dropna(subset=['data_zatrudnienia'])
#    print(len(df_bez_brakow))

# Uwaga: NIE nadpisujemy df — tylko liczymy, ile wierszy by zostało
```

### Sprawdzenie ✅

- **1a.** Całkowita liczba NaN w oryginalnym df: **8** (policz isna().sum().sum())
- **1a.** Kolumna z największą liczbą braków: **ocena_roczna (6)**
- **1b.** Liczba NaN w wynagrodzenie po `replace('brak', np.nan)` + `to_numeric`: **2**
- **1c.** Mediana wynagrodzenia: **5150.0** (uwaga: liczona na 30 wierszach z duplikatami; w Ćw. 3 po usunięciu duplikatów mediana wyniesie 5100.0)
- **1c.** Średnia ocena_roczna (zaokrąglona do 2 miejsc): **4.34**
- **1d.** Liczba wierszy po `dropna(subset=['data_zatrudnienia'])`: **29**

---

## Ćwiczenie 2: Duplikaty + konwersja typów (20 min)

### Cel
Osoba studiująca wykrywa i usuwa duplikaty oraz konwertuje typy danych.

**Uwaga:** Pracuj na **nowej kopii** oryginalnego df:

```python
# Zacznij od świeżej kopii
df2 = pd.DataFrame(data)  # ta sama definicja 'data' co wyżej

# Najpierw napraw wynagrodzenie (tak samo jak w Ćw. 1b)
df2['wynagrodzenie'] = df2['wynagrodzenie'].replace('brak', np.nan)
df2['wynagrodzenie'] = pd.to_numeric(df2['wynagrodzenie'], errors='coerce')
```

### Zadanie 2a — Wykrycie duplikatów

```python
# 1. Ile pełnych duplikatów (identycznych wierszy) ma dataset?
#    df2.duplicated().sum()

# 2. Wyświetl zduplikowane wiersze (te które są kopiami)
#    df2[df2.duplicated()]

# 3. Czy liczba duplikatów wg id_pracownika jest taka sama?
#    df2.duplicated(subset=['id_pracownika']).sum()

# 4. Wyświetl ile razy pojawia się każde id_pracownika
#    df2['id_pracownika'].value_counts().sort_index()
```

### Zadanie 2b — Usunięcie duplikatów

```python
# 1. Usuń pełne duplikaty i zresetuj indeks
#    df2 = df2.drop_duplicates().reset_index(drop=True)

# 2. Wyświetl nowy kształt DataFrame
#    print(df2.shape)
```

### Zadanie 2c — Konwersja daty

```python
# 1. Sprawdź aktualny typ kolumny data_zatrudnienia
#    print(df2['data_zatrudnienia'].dtype)

# 2. Skonwertuj na datetime
#    df2['data_zatrudnienia'] = pd.to_datetime(df2['data_zatrudnienia'], errors='coerce')

# 3. Sprawdź nowy typ
#    print(df2['data_zatrudnienia'].dtype)

# 4. Wyodrębnij rok zatrudnienia do nowej kolumny 'rok_zatrudnienia'
#    df2['rok_zatrudnienia'] = df2['data_zatrudnienia'].dt.year
#    print(df2['rok_zatrudnienia'].dropna().unique())
```

### Zadanie 2d — Pytanie biznesowe

```python
# Używając df2 po czyszczeniu:
# 1. Ile pracowników zostało zatrudnionych po 2021 roku (włącznie)?
# 2. Ile pracowników ma wynagrodzenie powyżej 6000?
# Uwaga: najpierw wyczyść dzial — str.strip().str.title()
#         df2['dzial'] = df2['dzial'].str.strip().str.title()
# 3. Ilu pracowników jest w dziale 'It' (po title())?
```

### Sprawdzenie ✅

- **2a.** Pełnych duplikatów: **5**
- **2a.** Duplikatów wg id_pracownika: **5**
- **2b.** Shape po `drop_duplicates()`: **(25, 6)**  (lub 7 jeśli zrobiłeś rok_zatrudnienia)
- **2c.** Typ data_zatrudnienia po konwersji: **datetime64[ns]** (w Pandas ≥ 2.0 może być `datetime64[us]` — oba są poprawne)
- **2c.** Unikalne lata zatrudnienia: **2017, 2018, 2019, 2020, 2021, 2022, 2023**
- **2d.** Pracownicy zatrudnieni >= 2021: **10** (oblicz: `df2[df2['rok_zatrudnienia'] >= 2021].shape[0]`)
- **2d.** Pracownicy z wynagrodzeniem > 6000: **7**
- **2d.** Pracownicy w dziale 'IT' (po title + replace, na 25 wierszach po dedup): **9**

---

## Ćwiczenie 3: Pełny pipeline czyszczenia (25 min)

### Cel
Osoba studiująca buduje kompletny pipeline czyszczenia od brudnych danych do gotowych do analizy — samodzielna praca.

### Kontekst biznesowy
Jesteś analitykiem danych w firmie. Dostałeś/aś eksport z systemu HR — to jest ten dataset. Szef HR chce raport: „Jakie są średnie wynagrodzenia i oceny per dział?" Zanim zaczniesz liczyć — musisz wyczyścić dane.

### Zadanie

Utwórz zmienną `df_clean` i przeprowadź pełny pipeline czyszczenia w kolejności:

```python
df_clean = pd.DataFrame(data)  # zacznij od świeżego df

# KROK 1: Zamień 'brak' na np.nan i skonwertuj wynagrodzenie na float
# (pd.to_numeric z errors='coerce')

# KROK 2: Usuń duplikaty (drop_duplicates) i zresetuj indeks

# KROK 3: Wypełnij NaN w wynagrodzeniu medianą

# KROK 4: Oblicz średnią ocena_roczna i wypełnij NaN tą średnią
# (zaokrąglij do 2 miejsc)

# KROK 5: Wyczyść kolumnę 'imie': str.strip() + str.title()

# KROK 6: Wyczyść kolumnę 'dzial':
#   a) str.strip() + str.title()
#   b) str.replace('Hr', 'HR', regex=False)
#   c) str.replace('It', 'IT', regex=False)

# KROK 7: Skonwertuj 'data_zatrudnienia' na datetime (errors='coerce')

# WERYFIKACJA — uruchom te linijki żeby sprawdzić wyniki:
print("=== WERYFIKACJA ===")
print(f"Shape: {df_clean.shape}")
print(f"\nDtypes:\n{df_clean.dtypes}")
print(f"\nNaN per kolumna:\n{df_clean.isna().sum()}")
print(f"\nUnikalne działy: {sorted(df_clean['dzial'].unique())}")
print(f"\nPierwsze imiona: {df_clean['imie'].tolist()[:8]}")
```

### Pytania biznesowe (po wyczyszczeniu)

```python
# Używając df_clean:

# Pytanie 1: Jakie jest średnie wynagrodzenie per dział?
# Wskazówka: df_clean.groupby('dzial')['wynagrodzenie'].mean().round(2)

# Pytanie 2: Jaka jest średnia ocena per dział?
# Wskazówka: df_clean.groupby('dzial')['ocena_roczna'].mean().round(2)

# Pytanie 3: Kto jest najlepiej opłacany (top 3)?
# Wskazówka: df_clean.nlargest(3, 'wynagrodzenie')[['imie', 'dzial', 'wynagrodzenie']]

# Pytanie 4: Ilu pracowników jest w każdym dziale?
# Wskazówka: df_clean['dzial'].value_counts()
```

### Sprawdzenie ✅

**Pipeline — weryfikacja krok po kroku:**

- **Po kroku 1:** NaN w wynagrodzenie = **2** (zamienione 'brak' i None)
- **Po kroku 2:** df_clean.shape = **(25, 6)**
- **Po kroku 3:** NaN w wynagrodzenie = **0**, mediana użyta do wypełnienia = **5100.0** (po usunięciu duplikatów)
- **Po kroku 4:** NaN w ocena_roczna = **0**, średnia użyta = **4.26** (po usunięciu duplikatów)
- **Po kroku 6:** df_clean['dzial'].unique() = **['HR', 'IT', 'Sprzedaz']** (3 unikalne)
- **Po kroku 7:** data_zatrudnienia dtype = **datetime64[ns]** (lub `datetime64[us]` w Pandas ≥ 2.0), NaN w tej kolumnie = **1**

**Finalne df_clean:**
- Shape: **(25, 6)**
- Typ wynagrodzenie: **float64**
- Typ data_zatrudnienia: **datetime64[ns]** (lub `datetime64[us]` w Pandas ≥ 2.0)
- NaN razem: **1** (jedna brakująca data)

**Pytania biznesowe — oczekiwane odpowiedzi:**

| Dział | Śr. wynagrodzenie | Śr. ocena | Liczba pracowników |
|-------|------------------|-----------|-------------------|
| HR | 4385.71 | 4.39 | 7 |
| IT | 6255.56 | 4.32 | 9 |
| Sprzedaz | 4900.00 | 4.11 | 9 |

- **Top 3 wynagrodzenia:** Ewa (IT, 7500), Kasia (IT, 7200), Henryk (IT, 6900)

### Rozszerzenie biznesowe (dla szybkich)

```python
# Dodatkowe pytania dla kierownika HR:
# 1. Ile lat pracuje najdłuższy staż? (dzisiejsza data - najwcześniejsza data_zatrudnienia)
# 2. Kto ma najwyższą ocenę w każdym dziale? (groupby + idxmax)
# 3. Czy jest korelacja między stażem a wynagrodzeniem?
```

---

## Ćwiczenie 4: Operacje na tekstach + commit (10 min)

### Cel
Osoba studiująca stosuje str.contains(), str.startswith(), str.len() do analizy i filtrowania tekstu, następnie commituje pracę do Git.

### Zadanie 4a — Diagnoza przed czyszczeniem

Użyj oryginalnego (brudnego) df:

```python
df_str = pd.DataFrame(data)  # świeża kopia

# 1. Ile imion jest zapisanych WSZYSTKIMI WIELKIMI LITERAMI?
#    Wskazówka: str.isupper() zwraca True jeśli wszystkie litery wielkie
#    df_str['imie'].str.isupper().sum()

# 2. Ile imion zaczyna się małą literą?
#    Wskazówka: str[0].str.islower() — pierwsza litera
#    df_str['imie'].str[0].str.islower().sum()

# 3. Ile wierszy ma 'sprzedaz' w kolumnie dzial (niezależnie od wielkości)?
#    Wskazówka: str.lower().str.contains('sprzedaz')
#    df_str['dzial'].str.lower().str.contains('sprzedaz').sum()
```

### Zadanie 4b — Czyszczenie i analiza

```python
# 1. Wyczyść imie: strip() + title()
#    df_str['imie'] = df_str['imie'].str.strip().str.title()

# 2. Wyczyść dzial: strip() + title() + replace
#    df_str['dzial'] = df_str['dzial'].str.strip().str.title()
#    df_str['dzial'] = df_str['dzial'].str.replace('Hr', 'HR', regex=False)
#    df_str['dzial'] = df_str['dzial'].str.replace('It', 'IT', regex=False)

# 3. Ile pracowników ma imię zaczynające się na 'A'?
#    df_str[df_str['imie'].str.startswith('A')]

# 4. Utwórz kolumnę 'dlugosc_imienia' z długością imienia
#    df_str['dlugosc_imienia'] = df_str['imie'].str.len()
#    print(df_str['dlugosc_imienia'].describe())

# 5. Kto ma najdłuższe imię? (nlargest lub sort_values)
```

### Zadanie 4c — str.contains z wzorcem

```python
# str.contains() może używać wyrażeń regularnych!

# 1. Znajdź pracowników z działów IT lub HR (jeden zawiera drugi wzorzec)
#    df_str[df_str['dzial'].str.contains('IT|HR')]

# 2. Znajdź imiona zawierające literę 'a' (małą lub dużą)
#    df_str[df_str['imie'].str.contains('a', case=False)]

# 3. Ile pracowników ma imię kończące się na 'a'?
#    Wskazówka: str.endswith('a') lub str.contains('a$', regex=True)
```

### Commit

```bash
# Upewnij się że notebook jest zapisany (Ctrl+S w VS Code)
# Dodaj i commituj

git add lab07_cleaning.ipynb
git commit -m "L07: Pandas — czyszczenie danych (NaN, duplikaty, typy, str)"
git push
```

### Sprawdzenie ✅

- **4a.** Imiona pisane WSZYSTKIMI WIELKIMI LITERAMI w oryginalnym df: **4** (CELINA, HENRYK, OLGA + jedna CELINA w duplikacie)
- **4a.** Imiona zaczynające się małą literą: **5** (darek, irena, norbert, sławek + sławek w duplikacie)
- **4a.** Wiersze z 'sprzedaz' w dziale (case-insensitive): **10**
- **4b.** Pracownicy z imieniem na 'A': **2** (Anna, Agata) — uwaga: żadne z nich nie jest duplikatem
- **4c.** Pracownicy IT lub HR (po czyszczeniu, 30 wierszy): **20** (10 IT + 10 HR)
- **4c.** Imiona kończące się na 'a' (po title(), 30 wierszy): **16** wierszy (13 unikalnych: Agata, Anna, Celina, Ewa, Gosia, Irena, Kasia, Marta, Olga, Renata, Teresa, Urszula, Wanda)

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- Diagnozować brakujące wartości: `isna()`, `info()`
- Stosować strategie uzupełniania: `fillna()` (mediana, średnia, stała)
- Usuwać zbędne wiersze: `dropna()`, `drop_duplicates()`
- Konwertować typy: `pd.to_numeric(errors='coerce')`, `pd.to_datetime(errors='coerce')`
- Czyścić tekst: `str.strip()`, `str.title()`, `str.replace()`, `str.contains()`
- Budować kompletny pipeline czyszczenia danych

**Na L08:** merge (łączenie DataFramów jak JOIN w SQL), groupby (agregacja po grupach), pivot_table (tabele przestawne) — właściwa analiza na czystych danych.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `fillna()` nie zmienia DataFrame | Przypisz wynik: `df['kol'] = df['kol'].fillna(wartość)` (zawsze przypisuj — `inplace` jest przestarzały) |
| `to_numeric()` — ValueError | Dodaj `errors='coerce'`: `pd.to_numeric(df['kol'], errors='coerce')` — zamieni nieparsowalne na NaN |
| `str.strip()` nie działa | Kolumna musi być typu string. Sprawdź: `df['kol'].dtype`. Jeśli object → OK, jeśli float → zamień: `df['kol'].astype(str)` |
| Po `drop_duplicates()` indeksy mają luki | Zresetuj: `df = df.reset_index(drop=True)` |
| `replace()` nie zamienia | Sprawdź dokładną wartość: `df['kol'].unique()`. Może są spacje? Użyj `.str.strip()` najpierw |
| Nie wiem ile jest NaN | `df.isna().sum()` → liczba NaN per kolumna. `df.isna().sum().sum()` → łączna |
