# L06 — Ćwiczenia laboratoryjne

## Temat: Pandas — selekcja, filtrowanie, sortowanie

**Programowanie w Pythonie II** | Laboratorium 6
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Start

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: `lab06_pandas_selection.ipynb`

```python
import pandas as pd
import numpy as np

tips = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv')
tips['tip_pct'] = (tips['tip'] / tips['total_bill'] * 100).round(1)
print(f"tips: {tips.shape[0]} wierszy, {tips.shape[1]} kolumn")
```

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| `DataFrame.loc[]` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.loc.html |
| `DataFrame.iloc[]` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.iloc.html |
| Boolean indexing | https://pandas.pydata.org/docs/user_guide/indexing.html#boolean-indexing |
| `query()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.query.html |
| `isin()` / `between()` | https://pandas.pydata.org/docs/reference/api/pandas.Series.isin.html |
| `sort_values()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.sort_values.html |

### Ściąga: `iloc` vs `loc`

| | `iloc` | `loc` |
|---|--------|-------|
| **Co przyjmuje** | Pozycję (0, 1, 2...) | Etykietę (nazwę) lub warunek |
| **Zakres** | `iloc[2:5]` → wiersze 2, 3, 4 | `loc['B':'D']` → B, C, D **włącznie!** |
| **Warunek** | Nie obsługuje | `df.loc[df['cena'] > 100]` ✓ |
| **90% czasu** | Rzadko | **To używasz** |

---

## Ćwiczenie 1: loc i iloc na nowym datasecie (20 min)

### Cel

Przećwicz selekcję na danych, których **nie było na wykładzie**.

### Dane: lotniska

```python
lotniska = pd.DataFrame({
    'miasto': ['Warszawa', 'Kraków', 'Gdańsk', 'Wrocław', 'Katowice',
               'Poznań', 'Rzeszów', 'Łódź', 'Szczecin', 'Bydgoszcz'],
    'kod': ['WAW', 'KRK', 'GDN', 'WRO', 'KTW',
            'POZ', 'RZE', 'LCJ', 'SZZ', 'BZG'],
    'pasazerowie_mln': [18.9, 9.3, 5.7, 3.8, 5.4,
                         2.6, 0.9, 0.3, 0.6, 0.4],
    'linie': [85, 42, 35, 28, 32, 22, 12, 5, 8, 6],
    'region': ['Mazowieckie', 'Małopolskie', 'Pomorskie', 'Dolnośląskie', 'Śląskie',
               'Wielkopolskie', 'Podkarpackie', 'Łódzkie', 'Zachodniopomorskie', 'Kujawsko-Pomorskie']
})
lotniska.index = lotniska['kod']
print(lotniska[['miasto', 'pasazerowie_mln', 'linie', 'region']])
```

### Zadania

**1a — iloc (pozycja):**
```python
# 1. Wyświetl 3 pierwsze lotniska (iloc)
# 2. Wyświetl lotniska od 5. do 8. (pozycje 4-7), tylko kolumny 0 i 2
# 3. Wyświetl co drugie lotnisko od końca (iloc[::-2])
```

**1b — loc (etykieta/warunek):**
```python
# 1. Wyświetl dane lotniska KRK (loc po etykiecie)
# 2. Wyświetl miasto i liczbę linii dla WAW, GDN i KTW (loc z listą etykiet)
# 3. Lotniska z więcej niż 5 mln pasażerów — które to? (loc + warunek)
# 4. Lotniska z mniej niż 20 liniami — wyświetl miasto i region (loc + warunek + kolumny)
```

**1c — łączone:**
```python
# 1. Ile lotnisk jest w regionach zaczynających się na literę "M"?
#    Podpowiedź: lotniska['region'].str.startswith('M')
# 2. Oblicz stosunek pasażerów do linii (pasazerowie_mln / linie * 1000000)
#    Wyświetl TOP-3 lotniska z najwyższym obłożeniem per linia
#    Podpowiedź: nlargest(3, 'kolumna') lub sort_values(..., ascending=False).head(3)
```

### Sprawdzenie ✅

- 1a.1: Pierwsze 3 → WAW, KRK, GDN
- 1b.3: >5 mln pasażerów → 4 lotniska (WAW 18.9, KRK 9.3, GDN 5.7, KTW 5.4)
- 1c.1: Regiony na "M" → 2 (Mazowieckie, Małopolskie)

---

## Ćwiczenie 2: Filtrowanie — pytania menedżera restauracji (20 min)

### Cel

Menedżer restauracji zadaje Ci pytania. Odpowiadasz kodem.

### Kontekst

Pracujesz jako analityk w restauracji. Menedżer przychodzi z pytaniami o dane sprzedażowe.
Masz dataset `tips` — 244 rachunki z informacjami o napiwkach, dniu, porze i grupie.

### Pytania menedżera

**Runda 1 — Proste filtry:**
```python
# "Ile rachunków mieliśmy w piątek?"
# "Ile rachunków złożyły grupy 1-osobowe? A 6-osobowe?"
# "Jaki jest najwyższy rachunek od kobiety?"
```

**Runda 2 — Łączone warunki (AND, OR):**
```python
# "Ilu niepalących mężczyzn jadło u nas obiad w weekend?"
#   (sex == Male) & (smoker == No) & (time == Dinner) & (day isin Sat/Sun)
#
# "Podaj średni rachunek dla dużych grup (4+) w czwartek."
#
# "Ilu klientów dało napiwek powyżej 25% przy rachunku poniżej 10$?"
#   To są podejrzanie hojni — sprawdź czy to nie błędy w danych.
```

**Runda 3 — isin, between, query:**
```python
# "Rachunki z weekendu (Sat, Sun) w zakresie 15-30$ — ile ich jest?"
#   Użyj isin + between w jednym filtrze.
#
# "Przepisz powyższy filtr używając query() — co jest czytelniejsze?"
#
# Bonus: "Ile rachunków od niepalących mężczyzn na obiedzie przekracza średnią?"
#   srednia = tips['total_bill'].mean()
#   Użyj query z @srednia
```

### Sprawdzenie ✅

- Runda 1: Piątek: 19; Grupy 1-os.: 4; 6-os.: 4; Max rachunek kobiety: 44.30$
- Runda 2: Niepalący mężczyźni, obiad, weekend: 75; Duże grupy czwartek, śr. rachunek: ~31.3$
- Runda 3: Weekend 15-30$: 93 rachunki

---

## Ćwiczenie 3: Analiza filmów — samodzielna praca (30 min)

### Kontekst

Jesteś analitykiem w firmie streamingowej. Dyrektor chce raport: **które filmy kupować do katalogu?**
Masz dane o 20 filmach — budżet, przychód, ocena, gatunek. Twoim zadaniem jest znaleźć wzorce.

### Dane

```python
filmy = pd.DataFrame({
    'tytul': ['Incepcja', 'Parasite', 'Avengers: Endgame', 'Joker', 'Coco',
              'Get Out', 'Dune', 'Whiplash', 'Mad Max: Fury Road', 'Spider-Man: No Way Home',
              'The Batman', 'Everything Everywhere', 'Oppenheimer', 'Barbie', 'La La Land',
              'Blade Runner 2049', 'Knives Out', '1917', 'Jojo Rabbit', 'Midsommar'],
    'rok': [2010, 2019, 2019, 2019, 2017,
            2017, 2021, 2014, 2015, 2021,
            2022, 2022, 2023, 2023, 2016,
            2017, 2019, 2019, 2019, 2019],
    'gatunek': ['Sci-Fi', 'Thriller', 'Akcja', 'Dramat', 'Animacja',
                'Horror', 'Sci-Fi', 'Dramat', 'Akcja', 'Akcja',
                'Akcja', 'Sci-Fi', 'Dramat', 'Komedia', 'Musical',
                'Sci-Fi', 'Kryminał', 'Wojenny', 'Komedia', 'Horror'],
    'budzet_mln': [160, 11, 356, 55, 175,
                   4.5, 165, 3.3, 150, 200,
                   185, 25, 100, 145, 30,
                   150, 40, 95, 14, 9],
    'przychod_mln': [836, 258, 2798, 1074, 807,
                     255, 407, 49, 380, 1916,
                     771, 141, 952, 1442, 447,
                     259, 311, 384, 90, 48],
    'ocena_imdb': [8.8, 8.5, 8.4, 8.4, 8.4,
                   7.7, 8.0, 8.5, 8.1, 8.2,
                   7.8, 7.8, 8.3, 6.8, 8.0,
                   8.0, 7.9, 8.3, 7.9, 7.1]
})
filmy['roi'] = (filmy['przychod_mln'] / filmy['budzet_mln']).round(1)
print(filmy[['tytul', 'gatunek', 'budzet_mln', 'przychod_mln', 'roi', 'ocena_imdb']])
```

### Zadania

**3a: Eksploracja i rankingi**
```python
# 1. TOP-5 filmów wg przychodu (nlargest)
# 2. TOP-5 filmów wg ROI (zwrot z inwestycji) — czy to te same filmy?
# 3. 5 filmów z najwyższą oceną IMDB
# 4. Które filmy miały budżet poniżej 15 mln$? Ile zarobiły?
```

**3b: Pytania dyrektora**
```python
# 1. "Ile filmów z gatunku Akcja mamy? Jaki ich średni ROI?"
#
# 2. "Filmy z oceną >= 8.0 I budżetem < 50 mln$ — to nasze 'perełki'. Które to?"
#
# 3. "Porównaj średni ROI per gatunek. Który gatunek daje najlepszy zwrot?"
#    Podpowiedź: pętla for po gatunek, jak na wykładzie
#
# 4. "Filmy z lat 2019-2023 z ROI > 5 — jakie wnioski dla zakupów?"
```

**3c: Łańcuch operacji (chaining)**
```python
# Napisz JEDEN łańcuch operacji:
# "TOP-3 filmy wg ROI, z oceną >= 7.5, tylko tytuł, gatunek, ROI i ocena"
#
# wynik = (filmy
#     [filmy['ocena_imdb'] >= ___]
#     .nlargest(___, '___')
#     [['tytul', 'gatunek', 'roi', 'ocena_imdb']]
# )
```

### Sprawdzenie ✅

- 3a.1: Najwyższy przychód: Avengers: Endgame (2798 mln$)
- 3a.2: Najwyższy ROI: Get Out (56.7) — niskobudżetowy horror!
- 3b.2: Perełki (ocena >= 8.0, budżet < 50 mln): Parasite, Whiplash, La La Land (3 filmy)
- 3b.3: Najwyższy śr. ROI: Horror (obie pozycje: Get Out i Midsommar)

---

## Ćwiczenie 4: Segmentacja filmów + wizualizacja + commit (15 min)

### Cel

Podziel filmy na segmenty i zwizualizuj wyniki. Zapisz pracę na GitHubie.

### Zadanie

**4a: Segmentacja**
```python
# Podziel filmy na segmenty wg ROI (użyj np.select — jak na wykładzie):
# - 'Hit':       ROI > 10
# - 'Zyskowny':  ROI > 3
# - 'Przeciętny': reszta (default)
#
# filmy['segment'] = np.select(
#     [filmy['roi'] > ___, filmy['roi'] > ___],
#     ['___', '___'],
#     default='___'
# )
#
# Wyświetl: ile filmów w każdym segmencie? Jaka średnia ocena per segment?
```

**4b: Wizualizacja**
```python
import matplotlib.pyplot as plt

# Scatter: budżet vs przychód, kolory = segment
fig, ax = plt.subplots(figsize=(8, 5))
kolory = {'Hit': 'green', 'Zyskowny': 'blue', 'Przeciętny': 'red'}

for seg, kolor in kolory.items():
    dane = filmy[filmy['segment'] == seg]
    ax.scatter(dane['budzet_mln'], dane['przychod_mln'],
               c=kolor, label=seg, s=60, alpha=0.7)

ax.set_xlabel('Budżet (mln $)')
ax.set_ylabel('Przychód (mln $)')
ax.set_title('Filmy: budżet vs przychód — segmentacja')
ax.legend()
plt.tight_layout()
plt.show()

# Pytanie: Co widzisz na wykresie? Czy droższe filmy = wyższy przychód?
```

**4c: Wniosek dla dyrektora**
```python
# Napisz 1-2 zdania w komentarzu: jaką strategię zakupową rekomendujesz?
# Czy firma powinna kupować drogie blockbustery czy tanie perełki?
# Odpowiedź uzasadnij danymi z analizy.

# REKOMENDACJA:
# ...
```

### Sprawdzenie ✅

- 4a: Hit (ROI > 10): Get Out (56.7), Parasite (23.5), Joker (19.5), La La Land (14.9), Whiplash (14.8) — 5 filmów
- 4a: Zyskowny (ROI > 3): Incepcja, Avengers, Coco, Spider-Man, Barbie, Oppenheimer... — 12 filmów
- 4a: Przeciętny (reszta): Dune, Mad Max, Blade Runner 2049 — 3 filmy
- 4b: Na wykresie widać, że Hity (zielone) to głównie tanie filmy — niski budżet, wysoki zwrot

### Commit

```bash
git add lab06_pandas_selection.ipynb
git commit -m "L06: selekcja, filtrowanie, analiza filmów, segmentacja"
git push
```

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Wybierać dane za pomocą iloc (pozycja) i loc (etykieta/warunek)
- ✅ Filtrować z &, |, ~, isin, between, query
- ✅ Tworzyć rankingi i odpowiadać na pytania biznesowe
- ✅ Segmentować dane i wizualizować wyniki
- ✅ Prowadzić analizę od surowych danych do rekomendacji

**Na następnych zajęciach:** Czyszczenie danych — brakujące wartości, duplikaty, błędne typy.
Przekonacie się, że prawdziwe dane nigdy nie są czyste.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `KeyError` przy `loc[]` | Sprawdź etykietę: `print(df.index)`. loc używa etykiet, nie pozycji! |
| `IndexError` przy `iloc[]` | Indeks poza zakresem. `df.shape[0]` powie ile jest wierszy |
| `ValueError: ambiguous` | Użyj `&` zamiast `and`, `\|` zamiast `or`. **Nawiasy obowiązkowe!** |
| Filtr zwraca pustą tabelę | Sprawdź: `df['kol'].unique()` pokaże dostępne wartości |
| `query()` nie działa | Nazwy kolumn bez spacji. Stringi w pojedynczym cudzysłowie wewnątrz podwójnego |
| `isin()` nie filtruje | Argument = lista: `.isin(['A', 'B'])`, nie `.isin('A', 'B')` |
| Nie wiem jak zacząć ćw. 3 | Zacznij od `filmy.head()` i `filmy.describe()` — zobacz co masz |
| Wykres się nie wyświetla | Dodaj `plt.show()` na końcu |

---

## Dla zaawansowanych

Wszystko gotowe? Spróbuj:

1. **Korelacja budżet-ocena:** Czy droższe filmy mają wyższe oceny? Oblicz średnią ocenę
   dla filmów z budżetem < 50 mln vs > 100 mln.

2. **Analiza czasowa:** Pogrupuj filmy wg roku. Czy ROI rośnie czy maleje w czasie?

3. **Własny dataset:** Wczytaj dataset `diamonds` z seaborn i odpowiedz:
   ```python
   diamonds = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/diamonds.csv')
   ```
   Ile diamentów ma > 2 karaty? Który szlif (`cut`) ma najwyższą średnią cenę?
   Znajdź „okazje": diament >= 1 karat, cena < 5000$, czystość (`clarity`) >= VS2.
   Podpowiedź: clarity to kategoria — zdefiniuj listę `['VS2','VS1','VVS2','VVS1','IF']` i użyj `isin()`.
