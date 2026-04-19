# L08 — Ćwiczenia laboratoryjne

## Temat: Pandas — łączenie i agregacja

**Programowanie w Pythonie II** | Laboratorium 8
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Po tym laboratorium potrafisz:

1. **Łączyć** dwie tabele funkcją `merge()` z wybranym typem złączenia (Bloom 3)
2. **Łączyć** w łańcuchu trzy tabele i dodawać kolumny wyliczane (Bloom 3)
3. **Analizować** dane za pomocą `groupby()` + `.agg()` z named aggregation (Bloom 4)
4. **Tworzyć** raporty w formie `pivot_table()` i `crosstab()` (Bloom 5)

Na wykładzie zobaczyliście merge, groupby i pivot na przykładzie wypożyczalni samochodów. Dziś przenosicie te techniki na **inną branżę**: e-sklep z książkami.

---

## Start

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: `lab08_pandas_merge.ipynb`

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Pandas — `merge()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.merge.html |
| Pandas — Merge, join, concat | https://pandas.pydata.org/docs/user_guide/merging.html |
| Pandas — `groupby()` (user guide) | https://pandas.pydata.org/docs/user_guide/groupby.html |
| Pandas — `pivot_table()` | https://pandas.pydata.org/docs/reference/api/pandas.pivot_table.html |
| Pandas — `crosstab()` | https://pandas.pydata.org/docs/reference/api/pandas.crosstab.html |
| SQL → Pandas porównanie | https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html |

### Ściąga typów `merge` — miej pod ręką

| `how=` | Co zachowuje | Kiedy używać |
|--------|--------------|--------------|
| `'inner'` (domyślny) | Tylko wspólne klucze (A ∩ B) | Standard — szukasz kompletnych rekordów |
| `'left'` | Wszystko z lewej + dopasowania z prawej | Zachowujesz wszystkie zamówienia, nawet bez danych autora |
| `'right'` | Wszystko z prawej + dopasowania z lewej | Zachowujesz wszystkich autorów, nawet bez książek |
| `'outer'` | Unia (wszystko z obu) | Audyt danych |

---

## Dane startowe — wklej jako pierwszą komórkę notebooka

```python
import pandas as pd
import numpy as np

# --- Tabela 1: autorzy ---
autorzy = pd.DataFrame({
    'autor_id':  [1, 2, 3, 4, 5, 6, 7, 8],
    'imie':      ['Olga', 'Stanisław', 'Andrzej', 'Wisława', 'Ryszard',
                   'Dorota', 'Szczepan', 'Jacek'],
    'nazwisko':  ['Tokarczuk', 'Lem', 'Sapkowski', 'Szymborska', 'Kapuściński',
                   'Masłowska', 'Twardoch', 'Dehnel'],
    'kraj':      ['Polska', 'Polska', 'Polska', 'Polska', 'Polska',
                   'Polska', 'Polska', 'Polska'],
    'nagrody':   ['Nobel', 'SFF', 'SFF', 'Nobel', 'Reporter',
                   'Polityka', 'NIKE', 'NIKE']
})

# --- Tabela 2: książki ---
ksiazki = pd.DataFrame({
    'ksiazka_id': [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112],
    'autor_id':   [1, 1, 2, 2, 3, 3, 4, 5, 6, 7, 7, 8],
    'tytul':      ['Księgi Jakubowe', 'Bieguni', 'Solaris', 'Cyberiada',
                    'Wiedźmin', 'Narrenturm', 'Wiersze wybrane', 'Podróże z Herodotem',
                    'Wojna polsko-ruska', 'Morfina', 'Król', 'Lala'],
    'kategoria':  ['historyczna', 'obyczajowa', 'sci-fi', 'sci-fi',
                    'fantasy', 'fantasy', 'poezja', 'reportaz',
                    'obyczajowa', 'historyczna', 'historyczna', 'obyczajowa'],
    'cena':       [79.90, 49.00, 39.00, 42.00, 45.00, 55.00, 35.00,
                    52.00, 38.00, 48.00, 59.00, 44.00],
    'strony':     [912, 376, 198, 295, 320, 512, 180, 263, 153, 618, 688, 432]
})

# --- Tabela 3: zamówienia ---
np.random.seed(2026)
n = 80
zamowienia = pd.DataFrame({
    'zam_id':     range(5001, 5001 + n),
    'ksiazka_id': np.random.choice(ksiazki['ksiazka_id'], size=n),
    'ilosc':      np.random.randint(1, 6, size=n),
    'data':       pd.to_datetime('2026-01-01') + pd.to_timedelta(np.random.randint(0, 120, n), unit='D'),
    'kanal':      np.random.choice(['web', 'aplikacja', 'telefon'], size=n, p=[0.6, 0.3, 0.1]),
    'miasto':     np.random.choice(['Warszawa', 'Kraków', 'Wrocław', 'Gdańsk', 'Poznań'], size=n)
})

print(f"Autorzy:    {autorzy.shape}")
print(f"Ksiazki:    {ksiazki.shape}")
print(f"Zamowienia: {zamowienia.shape}")
```

### Schemat danych

```
autorzy (autor_id)  ←──┐
                        │ po autor_id
ksiazki (ksiazka_id) ←──┤
                        │ po ksiazka_id
zamowienia (zam_id) ←───┘
```

### Opis kolumn

| Tabela | Kolumna | Opis |
|--------|---------|------|
| `autorzy` | `autor_id` | klucz główny autora |
| `autorzy` | `nagrody` | najważniejsza nagroda autora |
| `ksiazki` | `autor_id` | klucz obcy do `autorzy` |
| `ksiazki` | `kategoria` | historyczna / obyczajowa / sci-fi / fantasy / poezja / reportaż |
| `zamowienia` | `ksiazka_id` | klucz obcy do `ksiazki` |
| `zamowienia` | `ilosc` | liczba egzemplarzy w zamówieniu |
| `zamowienia` | `kanal` | web / aplikacja / telefon |

---

## Ćwiczenie 1: `merge()` — łączenie dwóch tabel (20 min)

### Cel
Nauczyć się łączyć dwie tabele funkcją `merge()` i sprawdzić różnice między typami złączenia.

### Krok 1 — prosty merge (inner)

```python
# Połącz ksiazki + autorzy po kluczu autor_id
ksiazki_z_autorami = ksiazki.merge(autorzy, on='autor_id')
print(f"Shape: {ksiazki_z_autorami.shape}")
ksiazki_z_autorami.head()
```

**Zadanie 1a:** Odpowiedz w komórce Markdown:
- Ile wierszy ma wynik?
- Ile kolumn?
- Jakie nowe kolumny pojawiły się (z tabeli `autorzy`)?

### Krok 2 — cztery typy `how`

Dodaj do tabeli `ksiazki` wiersz z `autor_id=999` (nieistniejącym):

```python
ksiazki_test = pd.concat([
    ksiazki,
    pd.DataFrame({'ksiazka_id':[999], 'autor_id':[999],
                   'tytul':['Ksiazka bez autora'], 'kategoria':['test'],
                   'cena':[30.0], 'strony':[100]})
], ignore_index=True)
```

**Zadanie 1b:** Porównaj cztery typy złączenia:

```python
inner = ksiazki_test.merge(autorzy, on='autor_id', how='inner')
left  = ksiazki_test.merge(autorzy, on='autor_id', how='left')
right = ksiazki_test.merge(autorzy, on='autor_id', how='right')
outer = ksiazki_test.merge(autorzy, on='autor_id', how='outer')

print(f"inner:  {inner.shape[0]} wierszy")
print(f"left:   {left.shape[0]} wierszy")
print(f"right:  {right.shape[0]} wierszy")
print(f"outer:  {outer.shape[0]} wierszy")
```

### Krok 3 — diagnostyka z `indicator=True`

```python
audyt = ksiazki_test.merge(autorzy, on='autor_id', how='outer', indicator=True)
audyt['_merge'].value_counts()
```

**Zadanie 1c:** W komórce Markdown odpowiedz: dlaczego `inner` ma mniej wierszy niż `left`? Wyjaśnij w 1-2 zdaniach.

### Sprawdzenie

- **1a**: `shape = (12, 10)`; nowe kolumny: `imie`, `nazwisko`, `kraj`, `nagrody`
- **1b**: inner=12, left=13 (z 999 i NaN po prawej), right=12 (każdy autor ma książkę), outer=13
- **1c**: `inner` wymaga dopasowania po obu stronach. Książka z `autor_id=999` nie ma pasującego autora, więc inner ją pomija. `left` zachowuje ją z `NaN` w kolumnach z tabeli `autorzy`.

---

## Ćwiczenie 2: Merge łańcuchowy + kolumny wyliczane (20 min)

### Cel
Połączyć trzy tabele w jedną, dodać kolumny wyliczane i przygotować dane do analizy.

### Krok 1 — łańcuch 3 tabel

```python
# Połącz: zamowienia + ksiazki + autorzy
pelne = (
    zamowienia
    .merge(ksiazki, on='ksiazka_id')
    .merge(autorzy, on='autor_id')
)
print(f"Pelna tabela: {pelne.shape}")
pelne.head()
```

### Krok 2 — kolumny wyliczane

**Zadanie 2a:** Dodaj cztery nowe kolumny:

```python
# 1. Wartość zamówienia
pelne['wartosc'] = pelne['ilosc'] * pelne['cena']
# 2. Miesiąc zamówienia
pelne['miesiac'] = pelne['data'].dt.month
# 3. Pełne imię i nazwisko autora
pelne['autor_pelne'] = pelne['imie'] + ' ' + pelne['nazwisko']
# 4. Kategoria cenowa książki
pelne['kategoria_cenowa'] = np.where(pelne['cena'] >= 50, 'droga', 'tania')
```

### Krok 3 — pierwsze wnioski

**Zadanie 2b:** Odpowiedz na pytania:

```python
# 1. Ile jest wszystkich zamówień?
# 2. Jaki jest łączny przychód?
# 3. Jaka jest średnia wartość zamówienia?
# 4. Ile książek (unikalnych tytułów) się sprzedało? (nunique)
```

### Sprawdzenie

- **2a**: tabela ma dodatkowe 4 kolumny wyliczane
- **2b**: liczba zamówień 80; przychód rzędu 14-16 tys. zł; śr. wartość ok. 180-200 zł; do 12 unikalnych tytułów

---

## Ćwiczenie 3: `groupby` + `.agg()` — raporty per kategoria (30 min)

### Cel
Zbudować kilka raportów na połączonych danych używając `groupby` z różnymi stylami agregacji.

### Krok 1 — podstawowy groupby

**Zadanie 3a:** Dla każdej `kategoria` policz łączny przychód (suma `wartosc`) i posortuj malejąco:

```python
# pelne.groupby('kategoria')['wartosc'].sum().sort_values(ascending=False)
```

### Krok 2 — wiele funkcji naraz

**Zadanie 3b:** Dla każdej `kategoria` policz: liczbę zamówień, średnią wartość, łączną wartość:

```python
# Użyj .agg(['count', 'mean', 'sum']) i .round(2)
```

### Krok 3 — named aggregation (styl nowoczesny)

**Zadanie 3c:** Zbuduj raport per autor używając named aggregation.

Oczekiwana struktura:

| autor_pelne | liczba_zamowien | laczna_sprzedaz | sredni_ilosc |
|-------------|-----------------|-----------------|--------------|
| ... | ... | ... | ... |

```python
# pelne.groupby('autor_pelne').agg(
#     liczba_zamowien=('zam_id', 'count'),
#     laczna_sprzedaz=('wartosc', 'sum'),
#     sredni_ilosc=('ilosc', 'mean')
# ).round(2).sort_values('laczna_sprzedaz', ascending=False)
```

### Krok 4 — groupby po wielu kolumnach

**Zadanie 3d:** Policz łączną wartość zamówień per `kategoria` × `kanal`:

```python
# pelne.groupby(['kategoria', 'kanal'])['wartosc'].sum()
```

### Krok 5 — udział procentowy (`transform`)

**Zadanie 3e:** Dodaj do `pelne` kolumnę `udzial_w_kategorii_pct`:

```python
# pelne['wartosc_kat'] = pelne.groupby('kategoria')['wartosc'].transform('sum')
# pelne['udzial_w_kategorii_pct'] = (pelne['wartosc'] / pelne['wartosc_kat'] * 100).round(2)
```

### Sprawdzenie

- **3a**: TOP 2 zwykle `historyczna` / `obyczajowa`
- **3b**: kolumny wynikowe `count`, `mean`, `sum`
- **3c**: 8 wierszy (po jednym per autor), czytelne nazwy kolumn
- **3d**: MultiIndex (kategoria, kanal), wartości = sumy
- **3e**: `pelne.groupby('kategoria')['udzial_w_kategorii_pct'].sum()` = 100% w każdej kategorii

---

## Ćwiczenie 4: `pivot_table` + `crosstab` — raport biznesowy (20 min)

### Cel
Zbudować raport 2D w formie tabel przestawnych — dokładnie takich, jakie kierownik sprzedaży wstawiłby do prezentacji.

### Krok 1 — pivot_table: kategoria × miesiąc

**Zadanie 4a:** Zbuduj tabelę przestawną z łącznym przychodem:

```python
# pd.pivot_table(pelne, index='kategoria', columns='miesiac',
#                values='wartosc', aggfunc='sum', fill_value=0)
```

### Krok 2 — pivot_table z sumami brzegowymi

**Zadanie 4b:** Dodaj `margins=True, margins_name='RAZEM'`.

### Krok 3 — crosstab: rozkład zamówień per kanał i miasto

**Zadanie 4c:**

```python
# pd.crosstab(pelne['kanal'], pelne['miasto'])
```

### Krok 4 — crosstab z normalize

**Zadanie 4d:** Przekształć w rozkład procentowy w wierszu:

```python
# pd.crosstab(pelne['kanal'], pelne['miasto'], normalize='index') * 100
```

### Krok 5 — raport biznesowy (refleksja)

**Zadanie 4e:** W komórce Markdown napisz **3-5 zdań** — wnioski z twojej analizy. Które kategorie, miesiące, kanały dominują? Co by powiedział kierownik sprzedaży otwierając twój notebook?

Przykład formuły: *„Kategoria X wygenerowała największy przychód (Y zł), co stanowi Z% łącznej sprzedaży."*

### Commit

```
cd C:\Users\student\python2
git add lab08_pandas_merge.ipynb
git commit -m "L08: merge, groupby, pivot — analiza sprzedazy e-sklepu ksiazek"
git push
```

### Sprawdzenie

- **4a**: tabela 6 kategorii × 4-5 miesięcy
- **4b**: dodatkowy wiersz/kolumna RAZEM
- **4c**: crosstab 3 × 5
- **4d**: wartości w każdym wierszu sumują się do 100%
- **4e**: refleksja — liczy się umiejętność wyciągnięcia wniosków

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- Łączyć dwie tabele funkcją `merge()` z wyborem typu złączenia
- Łączyć trzy tabele w łańcuchu i dodawać kolumny wyliczane
- Budować raporty grupowane z `groupby` + `.agg()` (w tym named aggregation)
- Analizować dane 2D przez `pivot_table` i `crosstab`
- Formułować wnioski biznesowe na podstawie tabel przestawnych

**Na następnych zajęciach:** Matplotlib — wizualizacja. Wszystkie tabele zamienimy w wykresy.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `KeyError: 'kolumna'` w merge | Sprawdź pisownię: `df.columns`. Klucz musi istnieć w obu tabelach. |
| Merge ma więcej wierszy niż się spodziewasz | Duplikaty klucza po obu stronach — iloczyn kartezjański. Sprawdź: `df['klucz'].duplicated().sum()` |
| `groupby` pokazuje FutureWarning | Dodaj `observed=True` przy grupowaniu po kolumnie kategorycznej |
| Named aggregation nie działa | Składnia wymaga krotki: `agg(nazwa=('kol', 'sum'))` |
| `pivot_table` pokazuje dużo `NaN` | Dodaj `fill_value=0` |
| Niechciany `NaN` w kolumnach po merge | Typ klucza się nie zgadza (`int` vs `str`) — zunifikuj: `df['klucz'] = df['klucz'].astype(int)` |
| `transform` vs `agg` | `transform` gdy chcesz wynik tej samej długości, `agg` gdy skrócony |
| Wynik trudny do odczytu | `.round(2)`, `.sort_values(...)`, `.reset_index()` |
| `pivot` zgłasza błąd "duplicate entries" | Użyj `pivot_table` — agreguje duplikaty |

---

## Dla zaawansowanych

Wszystko gotowe? Spróbuj:

1. **Ranking autorów per kategoria** — TOP 1 w każdej kategorii wg wartości sprzedaży (`groupby + nlargest`)
2. **Korelacja liczba stron ↔ średnia ilość zamawianych egzemplarzy** — `pelne.groupby('ksiazka_id').agg(strony=('strony','first'), sr_ilosc=('ilosc','mean')).corr()`
3. **Analiza kanałów** — jaki kanał generuje najwyższą średnią wartość zamówienia?
