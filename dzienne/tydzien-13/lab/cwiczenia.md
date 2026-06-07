# L13 — Ćwiczenia: Zaawansowane biblioteki (scikit-learn, Polars, Plotly)

**Programowanie w Pythonie II** | Laboratorium 13
**Czas:** 90 min | Notebook: `lab13_advanced_libs.ipynb`

---

## Start (Windows, laboratorium uczelniane)

```powershell
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Następnie w VS Code: **File → New File → `dzienne\lab13\lab13_advanced_libs.ipynb`**. Wybierz kernel `.venv`.

---

## Przygotowanie — uruchom PRZED ćwiczeniami

W notebooku `lab13_advanced_libs.ipynb` jako **pierwszą komórkę** wpisz:

```python
# Instalacja bibliotek (uruchom raz na początku)
# pyarrow jest potrzebny do mostu Pandas <-> Polars na kolumnach tekstowych
%pip install scikit-learn plotly polars pyarrow -q

# Imports
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score, mean_squared_error
import plotly.express as px
import polars as pl
import time

np.random.seed(42)  # powtarzalność: te same liczby losowe przy każdym uruchomieniu

print("Wszystkie biblioteki załadowane poprawnie!")
print(f"scikit-learn wersja: {__import__('sklearn').__version__}")
print(f"plotly wersja: {__import__('plotly').__version__}")
print(f"polars wersja: {pl.__version__}")
```

## Przydatne materiały

| Temat | Link |
|-------|------|
| scikit-learn — Getting Started | https://scikit-learn.org/stable/getting_started.html |
| scikit-learn — `KMeans` | https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html |
| scikit-learn — `StandardScaler` | https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html |
| scikit-learn — `LinearRegression` | https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html |
| scikit-learn — `train_test_split` | https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html |
| Polars — User Guide | https://docs.pola.rs/ |
| Polars — `select` / `filter` / expressions | https://docs.pola.rs/user-guide/concepts/expressions-and-contexts/ |
| Polars — `group_by` + `agg` | https://docs.pola.rs/user-guide/transformations/aggregation/ |
| Polars — Lazy API (leniwa ewaluacja) | https://docs.pola.rs/user-guide/lazy/ |
| Polars — porównanie z Pandas | https://docs.pola.rs/user-guide/migration/pandas/ |
| Plotly — Python Quick Start | https://plotly.com/python/getting-started/ |
| Plotly — Scatter plots | https://plotly.com/python/line-and-scatter/ |
| Plotly — Bar charts | https://plotly.com/python/bar-charts/ |
| Plotly — `px.scatter()` | https://plotly.com/python-api-reference/generated/plotly.express.scatter |

### Kluczowe pojęcia

- **KMeans** — algorytm klasteryzacji (clustering — automatyczny podział danych na grupy bez podanych z góry etykiet). Dzieli dane na k grup tak, by punkty w grupie były blisko siebie.
- **StandardScaler** — normalizacja danych (przeskalowanie tak, by każda kolumna miała średnią=0 i odchylenie standardowe=1). **Obowiązkowy przed KMeans** — bez niego skala danych zaburzy wyniki.
- **Regresja liniowa** — model: y = a₁x₁ + a₂x₂ + ... + b. Szuka najlepszych współczynników minimalizując błąd.
- **R²** (współczynnik determinacji) — liczba 0-1. Im bliżej 1, tym lepiej model wyjaśnia dane. R²=0.86 → model wyjaśnia 86% zmienności.
- **RMSE** (pierwiastek ze średniego błędu kwadratowego) — średni błąd predykcji w jednostkach zmiennej celu, łatwy w interpretacji.
- **train/test split** (podział na zbiór treningowy i testowy) — dzielimy dane: na treningowym model się uczy, na testowym oceniamy jego jakość na danych, których „nie widział”. Typowo 80/20.
- **overfitting** (przeuczenie) — model zbyt dobrze dopasowany do danych treningowych, słabo działa na nowych. Dlatego oceniamy na zbiorze testowym, nie treningowym.
- **Polars** — biblioteka do pracy z danymi (jak Pandas), napisana w języku Rust. **DataFrame kolumnowy** (dane ułożone w pamięci kolumnami, nie wierszami — szybsze operacje analityczne). Bywa 5-20× szybszy od Pandas na dużych zbiorach.
- **expression API** (`pl.col(...)`) — w Polars operacje na kolumnach zapisujemy jako *wyrażenia* (expression — przepis na obliczenie), np. `pl.col('cena') > 100`, zamiast indeksować nawiasami jak w Pandas.
- **lazy evaluation** (leniwa ewaluacja, `.lazy()...collect()`) — Polars potrafi zbudować *plan* zapytania, zoptymalizować go i wykonać dopiero przy `.collect()`. Robi mniej pracy = szybciej.
- **brak indeksu** — Polars (w odróżnieniu od Pandas) nie ma indeksu wiersza. Każda kolumna jest równoprawna, odwołujesz się po nazwie — mniej `reset_index()`.
- **Plotly Express** (`px`) — biblioteka do interaktywnych wykresów. **hover** (najechanie myszą — pokazuje wartości punktu), zoom, legenda klikalna — idealne do eksploracji.

---

## Ćwiczenie 1: KMeans — segmentacja klientów (18 min)

**Cel:** Osoba studiująca stosuje KMeans do podziału klientów e-commerce na segmenty i interpretuje każdy segment biznesowo.

### Kontekst
Jesteś analitykiem danych w firmie e-commerce. Masz dane 300 klientów: średnią wartość zamówienia (PLN) i liczbę zamówień w roku. Chcesz podzielić ich na 3 segmenty, żeby móc kierować do nich różne kampanie marketingowe.

### Krok 1 — Generowanie danych

```python
np.random.seed(42)

klienci = pd.DataFrame({
    'srednia_wartosc': np.concatenate([
        np.random.normal(400, 60, 100),    # segment 0
        np.random.normal(1100, 120, 100),  # segment 1
        np.random.normal(2400, 180, 100)   # segment 2
    ]),
    'zamowienia_rok': np.concatenate([
        np.random.normal(2, 0.5, 100),
        np.random.normal(7, 1.2, 100),
        np.random.normal(18, 2.5, 100)
    ])
})

# Usuń wartości ujemne (mogą wystąpić przy małych średnich)
klienci = klienci.clip(lower=0)
klienci.describe().round(2)
```

### Krok 2 — Skalowanie i klastrowanie

Uzupełnij kod:

```python
# TODO: Stwórz obiekt StandardScaler
scaler = ___

# TODO: Zastosuj fit_transform na obu kolumnach
X_scaled = ___

# TODO: Stwórz KMeans z k=3, random_state=42, n_init=10
kmeans = ___

# TODO: Dopasuj model do danych
___

# TODO: Przypisz etykiety klastrów do DataFrame
klienci['segment'] = ___

print("Rozkład klientów per segment:")
print(klienci['segment'].value_counts().sort_index())
```

### Krok 3 — Analiza segmentów

```python
# TODO: Oblicz średnie wartości per segment
srednie = klienci.groupby('segment')[['srednia_wartosc', 'zamowienia_rok']].mean().round(1)
print(srednie)
```

### Krok 4 — Wizualizacja (matplotlib na razie)

```python
fig, ax = plt.subplots(figsize=(10, 6))
kolory = {0: 'blue', 1: 'orange', 2: 'green'}
for seg in [0, 1, 2]:
    dane_seg = klienci[klienci['segment'] == seg]
    ax.scatter(dane_seg['srednia_wartosc'], dane_seg['zamowienia_rok'],
               c=kolory[seg], label=f'Segment {seg}', alpha=0.7)
ax.set_xlabel('Średnia wartość zamówienia [PLN]')
ax.set_ylabel('Liczba zamówień w roku')
ax.set_title('Segmentacja klientów — KMeans k=3')
ax.legend()
plt.tight_layout()
plt.show()
```

### Krok 5 — Interpretacja biznesowa

Na podstawie wartości średnich z Kroku 3, przypisz nazwy do segmentów:

```python
# TODO: Wpisz nazwy segmentów na podstawie wartości średnich
# Uwaga: numery klastrów (0/1/2) bywają w innej kolejności — nazwij je na podstawie
# faktycznych średnich z Kroku 3, nie po numerze.
nazwy_segmentow = {
    0: '___',  # dlaczego?
    1: '___',  # dlaczego?
    2: '___',  # dlaczego?
}
klienci['nazwa_segmentu'] = klienci['segment'].map(nazwy_segmentow)
print(klienci.groupby('nazwa_segmentu')[['srednia_wartosc', 'zamowienia_rok']].mean().round(1))
```

### Pytania do przemyślenia
1. Dlaczego używamy `StandardScaler` przed KMeans? Co by się stało bez skalowania?
2. Jak dobierasz liczbę klastrów k? Co to jest metoda łokcia (elbow method)?
3. Który segment warto obsłużyć priorytetowo z perspektywy biznesowej?

### Sprawdzenie 1 ✅

- [ ] 3 segmenty widoczne na scatter plot (różne kolory)
- [ ] `StandardScaler` użyty PRZED KMeans
- [ ] `klienci.groupby('segment').mean()` — różne średnie wartości dla każdego segmentu
- [ ] Nazwy segmentów przypisane logicznie (np. "Okazjonalni", "Regularni", "VIP")
- [ ] Inertia (`kmeans.inertia_`) obliczona — mniejsza = lepszy podział

---

## Ćwiczenie 2: Regresja liniowa — prognoza sprzedaży (18 min)

**Cel:** Osoba studiująca projektuje pipeline regresji liniowej do przewidywania sprzedaży na podstawie wydatków reklamowych i ocenia jakość modelu.

### Kontekst
Masz dane z 200 regionów sprzedaży. Dla każdego regionu znasz wydatki na reklamę TV i radio (w tys. PLN) oraz osiągniętą sprzedaż. Chcesz zbudować model, który przewidzi sprzedaż na podstawie budżetu reklamowego.

### Krok 1 — Generowanie danych

```python
np.random.seed(42)
n = 200

reklama_tv = np.random.uniform(10, 300, n)
reklama_radio = np.random.uniform(5, 50, n)
szum = np.random.normal(0, 1.5, n)

# Prawdziwa zależność: sprzedaz = 5 + 0.05*tv + 0.12*radio + szum
sprzedaz = 5 + 0.05 * reklama_tv + 0.12 * reklama_radio + szum

df_reklama = pd.DataFrame({
    'tv': reklama_tv,
    'radio': reklama_radio,
    'sprzedaz': sprzedaz
})

print(df_reklama.describe().round(2))
```

### Krok 2 — Podział na zbiory treningowy i testowy

```python
X = df_reklama[['tv', 'radio']]
y = df_reklama['sprzedaz']

# TODO: Podziel dane na train/test
# test_size=0.2, random_state=42
X_train, X_test, y_train, y_test = ___

print(f"Zbiór treningowy: {len(X_train)} próbek")
print(f"Zbiór testowy: {len(X_test)} próbek")
```

### Krok 3 — Trening modelu

```python
# TODO: Stwórz model LinearRegression
model = ___

# TODO: Wytrenuj model na danych treningowych
___

print(f"Intercept (wyraz wolny): {model.intercept_:.3f}")
print(f"Współczynnik TV: {model.coef_[0]:.4f}  (prawdziwy: 0.05)")
print(f"Współczynnik Radio: {model.coef_[1]:.4f}  (prawdziwy: 0.12)")
```

Czy współczynniki są zbliżone do prawdziwych wartości (0.05 i 0.12)?

### Krok 4 — Ocena modelu

```python
# TODO: Wykonaj predykcje na zbiorze testowym
y_pred = ___

# TODO: Oblicz R² i RMSE
# Wskazówka RMSE: użyj np.sqrt(mean_squared_error(...))
# UWAGA: parametr squared=False został usunięty z nowego scikit-learn — nie używaj go
r2 = ___
rmse = ___

print(f"R² = {r2:.4f}")
print(f"RMSE = {rmse:.4f}")
```

### Krok 5 — Wykres predykcji vs rzeczywistość

```python
plt.figure(figsize=(8, 6))
plt.scatter(y_test, y_pred, alpha=0.6, edgecolors='black', linewidths=0.5)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()],
         'r--', lw=2, label='Idealna predykcja')
plt.xlabel('Sprzedaż rzeczywista')
plt.ylabel('Sprzedaż przewidywana')
plt.title(f'Regresja liniowa — predykcja vs rzeczywistość\nR²={r2:.3f}, RMSE={rmse:.3f}')
plt.legend()
plt.tight_layout()
plt.show()
```

### Krok 6 — Predykcja dla nowych danych

```python
# TODO: Przewidź sprzedaż dla budżetu TV=200 tys, Radio=30 tys
nowe_dane = pd.DataFrame({'tv': [200], 'radio': [30]})
prognoza = ___

print(f"Prognoza sprzedaży dla TV=200, Radio=30: {prognoza[0]:.1f} tys. PLN")
# Sprawdzenie ręczne: 5 + 0.05*200 + 0.12*30 = ?
```

### Pytania do przemyślenia
1. Co oznacza R² = 0.86? Ile procent zmienności sprzedaży wyjaśnia nasz model?
2. Jak interpretujesz RMSE w kontekście prognozowania sprzedaży?
3. Dlaczego NIE stosujemy `fit_transform` na X_test? Co by się stało gdybyśmy tak zrobili (overfitting / wyciek danych)?

### Sprawdzenie 2 ✅

- [ ] R² na zbiorze testowym ≥ 0.80 (dane syntetyczne z wyraźną zależnością; przy szumie `normal(0, 1.5)` i n=200 wychodzi ~0.86)
- [ ] RMSE ≈ 1.5-2.0 (rząd wielkości szumu `np.random.normal(0, 1.5)`; faktycznie ~1.8)
- [ ] Współczynniki: TV ≈ 0.05, Radio ≈ 0.10-0.12, Intercept ≈ 5
- [ ] Wykres: wartości rzeczywiste vs przewidywane — punkty blisko linii y=x
- [ ] Predykcja: `model.predict([[200, 30]])` → sprzedaż ≈ 18

---

## Ćwiczenie 3: Polars — szybka agregacja (20 min)

**Cel:** Osoba studiująca stosuje Polars do wyboru, filtrowania i agregacji danych, korzysta z leniwej ewaluacji (lazy) i mierzy przewagę szybkości względem Pandas na dużym zbiorze.

### Kontekst
Dział danych dostaje plik z milionami transakcji. Skrypt w Pandas liczy go zbyt długo. Sprawdzasz Polars — bibliotekę DataFrame napisaną w Rust — żeby przyspieszyć przetwarzanie. Najpierw poznasz składnię na małych danych (z Ćwiczenia 1), potem zmierzysz przewagę na ~2 mln wierszy.

> **Uwaga:** to ćwiczenie korzysta z `klienci` (DataFrame z kolumną `segment`) utworzonego w Ćwiczeniu 1. Uruchom Ćwiczenie 1 najpierw.

### Składnia Pandas ↔ Polars — ściąga

| Operacja | Pandas | Polars |
|----------|--------|--------|
| Wybór kolumn | `df[['a', 'b']]` | `df.select('a', 'b')` |
| Filtr wierszy | `df[df['a'] > 5]` | `df.filter(pl.col('a') > 5)` |
| Nowa kolumna | `df['c'] = df['a'] * 2` | `df.with_columns((pl.col('a') * 2).alias('c'))` |
| Grupowanie + agregacja | `df.groupby('g')['a'].mean()` | `df.group_by('g').agg(pl.col('a').mean())` |
| Liczba wierszy w grupie | `.size()` | `pl.len()` |
| Z Pandas do Polars | — | `pl.from_pandas(df)` |
| Z Polars do Pandas | — | `pl_df.to_pandas()` |

### Krok 1 — Z Pandas do Polars

```python
# pl.from_pandas zamienia DataFrame Pandas na DataFrame Polars (i z powrotem: .to_pandas())
kl_pl = pl.from_pandas(klienci[['srednia_wartosc', 'zamowienia_rok', 'segment']])
print(type(kl_pl))   # <class 'polars.dataframe.frame.DataFrame'>
kl_pl.head(3)
```

Zwróć uwagę: Polars **nie ma indeksu wiersza** (brak kolumny indeksu po lewej, jak w Pandas).

### Krok 2 — Wybór i filtrowanie (`select`, `filter`, `pl.col`)

```python
# TODO: Wybierz tylko kolumny 'srednia_wartosc' i 'zamowienia_rok'
#       Użyj kl_pl.select(...)
wybrane = ___

# TODO: Wyfiltruj klientów premium o wartości zamówienia powyżej 1500 PLN
#       Użyj kl_pl.filter(pl.col('srednia_wartosc') > 1500)
drodzy = ___

print(f"Klientów premium (>1500 PLN): {drodzy.height}")
drodzy.head(3)
```

### Krok 3 — Grupowanie i agregacja (`group_by().agg()`)

```python
# TODO: Pogrupuj po 'segment' i policz dla każdego segmentu:
#   - średnią 'srednia_wartosc' (zaokrągloną), alias 'sr_wartosc'
#   - średnią 'zamowienia_rok' (zaokrągloną do 1 miejsca), alias 'sr_zamowienia'
#   - liczbę klientów (pl.len()), alias 'liczba'
# Wzór agregacji: pl.col('kolumna').mean().round(0).alias('nazwa')
profil_pl = (
    kl_pl.group_by('segment')
    .agg(
        ___,
        ___,
        ___,
    )
    .sort('segment')
)
profil_pl
```

### Krok 4 — Leniwa ewaluacja (`.lazy()...collect()`)

W trybie leniwym (lazy) budujesz *plan* zapytania; Polars go optymalizuje i wykonuje dopiero przy `.collect()`.

```python
# TODO: Uzupełnij łańcuch lazy:
#   1) kl_pl.lazy()
#   2) .filter(pl.col('zamowienia_rok') > 5)
#   3) .group_by('segment')
#   4) .agg(pl.col('srednia_wartosc').mean().alias('sr_wartosc'))
#   5) .sort('segment')
#   6) .collect()   <-- bez tego dostaniesz tylko PLAN (LazyFrame), nie dane!
wynik = (
    kl_pl.lazy()
    .filter(___)
    .group_by('segment')
    .agg(___)
    .sort('segment')
    .___   # <- wykonaj plan
)
wynik
```

### Krok 5 — Mini-benchmark: Pandas vs Polars na ~2 mln wierszy

```python
np.random.seed(42)
n_rows = 2_000_000
big_pd = pd.DataFrame({
    'kategoria': np.random.choice(['A', 'B', 'C', 'D'], n_rows),
    'wartosc': np.random.normal(1000, 200, n_rows),
})
big_pl = pl.from_pandas(big_pd)

# TODO: Zmierz czas group_by w Pandas (time.perf_counter PRZED i PO)
t0 = time.perf_counter()
_ = big_pd.groupby('kategoria')['wartosc'].mean()
czas_pd = time.perf_counter() - t0

# TODO: Zmierz czas tej samej operacji w Polars
t0 = time.perf_counter()
_ = ___   # big_pl.group_by('kategoria').agg(pl.col('wartosc').mean())
czas_pl = time.perf_counter() - t0

print(f"Pandas: {czas_pd*1000:6.1f} ms")
print(f"Polars: {czas_pl*1000:6.1f} ms")
print(f"Polars szybszy ~{czas_pd/czas_pl:.1f}x na {n_rows:,} wierszach")
```

> Czasy zależą od komputera — liczy się *rząd różnicy*, nie dokładne sekundy. Na sprzęcie laboratoryjnym Polars zwykle 3-10× szybszy na tej operacji.

### Pytania do przemyślenia
1. Dlaczego Polars bywa szybszy od Pandas? (podpowiedź: wielowątkowość, format kolumnowy, lazy)
2. Co zwraca `kl_pl.lazy().filter(...)` BEZ `.collect()`? Dlaczego to nie są jeszcze dane?
3. Kiedy wybrałbyś Pandas, a kiedy Polars? (mały zbiór i integracja ze sklearn vs duży zbiór i szybkość)
4. Czym różni się `pl.col('a') > 5` (wyrażenie Polars) od `df['a'] > 5` (Pandas)?

### Sprawdzenie 3 ✅

- [ ] `pl.from_pandas` utworzył `DataFrame` Polars (typ `polars...DataFrame`)
- [ ] `filter(pl.col('srednia_wartosc') > 1500)` zwraca tylko klientów premium
- [ ] `group_by('segment').agg(...)` daje tabelę z `sr_wartosc`, `sr_zamowienia`, `liczba` per segment
- [ ] Łańcuch lazy kończy się `.collect()` i zwraca dane (nie `LazyFrame`)
- [ ] Benchmark: Polars wyraźnie szybszy od Pandas na 2 mln wierszy (≥ 2×)

---

## Ćwiczenie 4: Plotly — interaktywny dashboard (18 min)

**Cel:** Osoba studiująca tworzy trzy interaktywne wykresy Plotly Express (scatter, bar, line) prezentujące wyniki segmentacji i trend sprzedaży, i eksportuje wynik do pliku HTML.

**Uwaga:** To ćwiczenie korzysta z danych z Ćwiczenia 1 (`klienci` z kolumną `nazwa_segmentu`). Używamy **wyłącznie Plotly Express (`px`)** — tak jak na wykładzie.

### Krok 1 — Interaktywny scatter plot segmentacji

```python
# TODO: Stwórz interaktywny scatter plot
# x='srednia_wartosc', y='zamowienia_rok'
# color='nazwa_segmentu'
# size='srednia_wartosc' (rozmiar punktu proporcjonalny do wartości)
# title='Segmentacja klientów — KMeans k=3'
# Ustaw odpowiednie labels

fig_scatter = px.scatter(
    klienci,
    x=___,
    y=___,
    color=___,
    size=___,
    title=___,
    labels={
        'srednia_wartosc': ___,
        'zamowienia_rok': ___,
        'nazwa_segmentu': 'Segment'
    },
    hover_data=['srednia_wartosc', 'zamowienia_rok']
)
fig_scatter.show()
```

Sprawdź interaktywność:
- Najedź myszą na punkt (hover) — czy widzisz wszystkie wartości?
- Kliknij na segment w legendzie — czy ukrywa/pokazuje punkty?
- Zaznacz obszar — czy zoom działa?

### Krok 2 — Bar chart: średnie wartości per segment

```python
# Przygotowanie danych
srednie_seg = (klienci.groupby('nazwa_segmentu')
               [['srednia_wartosc', 'zamowienia_rok']]
               .mean()
               .reset_index()
               .round(1))

# TODO: Stwórz bar chart przez px.bar(...)
# x='nazwa_segmentu', y='srednia_wartosc'
# color='nazwa_segmentu'
# title='Średnia wartość zamówienia per segment'
# text_auto='.0f' (etykiety liczbowe na słupkach)

fig_bar = ___
fig_bar.update_layout(showlegend=False)
fig_bar.show()
```

### Krok 3 — Line chart: trend sprzedaży miesięcznej

```python
# Generuj dane trendu
np.random.seed(42)
miesiace = list(range(1, 13))
nazwy_miesiecy = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze',
                  'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru']

sprzedaz_2023 = [80 + i*4 + np.random.normal(0, 5) for i in miesiace]
sprzedaz_2024 = [100 + i*6 + np.random.normal(0, 7) for i in miesiace]

df_trend = pd.DataFrame({
    'miesiac': nazwy_miesiecy * 2,
    'sprzedaz': sprzedaz_2023 + sprzedaz_2024,
    'rok': ['2023'] * 12 + ['2024'] * 12
})

# TODO: Stwórz line chart przez px.line(...)
# x='miesiac', y='sprzedaz'
# color='rok'
# markers=True
# title='Trend sprzedaży 2023 vs 2024'

fig_line = ___
fig_line.show()
```

### Krok 4 — Eksport do HTML

```python
# TODO: Zapisz wykres scatter do pliku HTML
# fig.write_html('nazwa.html') — plik otworzysz w przeglądarce, działa BEZ Pythona
fig_scatter.write_html('segmentacja_klienci.html')
print("Wykres zapisany jako segmentacja_klienci.html — otwórz w przeglądarce.")
```

### Pytania do przemyślenia
1. Co daje `hover_data` w `px.scatter`? Dlaczego interaktywność jest lepsza niż statyczny obrazek z matplotlib?
2. Po co `color=` musi być kolumną kategoryczną (tekst), a nie liczbą? (patrz „Jeśli utkniesz”)
3. `fig.write_html()` zapisuje plik HTML — komu możesz go wysłać i co odbiorca musi mieć, żeby go otworzyć?

### Sprawdzenie 4 ✅

- [ ] 3 wykresy: scatter (segmenty), bar (średnie z etykietami), line (trend z markerami)
- [ ] Każdy wykres ma tytuł, etykiety osi i legendę
- [ ] Hover pokazuje wartości po najechaniu myszą
- [ ] Kolory kodują segmenty / lata
- [ ] Plik `segmentacja_klienci.html` zapisany i otwiera się w przeglądarce

### Rozszerzenie dla szybkich (opcjonalne — wykracza poza wykład)

Jeśli skończysz wcześniej, zbuduj **wielopanelowy dashboard 2×2** z użyciem `make_subplots` i `plotly.graph_objects` (go). To wyższy poziom Plotly — łączy kilka wykresów w jedną siatkę.

```python
from plotly.subplots import make_subplots
import plotly.graph_objects as go

fig_dashboard = make_subplots(
    rows=2, cols=2,
    subplot_titles=[
        'Segmentacja klientów', 'Średnie wartości per segment',
        'Trend sprzedaży', 'Rozkład wartości zamówień'
    ]
)

# Panel 1: Scatter segmentacji
for seg_name in klienci['nazwa_segmentu'].unique():
    dane_seg = klienci[klienci['nazwa_segmentu'] == seg_name]
    fig_dashboard.add_trace(
        go.Scatter(x=dane_seg['srednia_wartosc'], y=dane_seg['zamowienia_rok'],
                   mode='markers', name=seg_name, marker=dict(opacity=0.7)),
        row=1, col=1
    )

# Panel 2: Bar chart
fig_dashboard.add_trace(
    go.Bar(x=srednie_seg['nazwa_segmentu'], y=srednie_seg['srednia_wartosc'],
           showlegend=False, marker_color=['#636EFA', '#EF553B', '#00CC96']),
    row=1, col=2
)

# Panel 3: Line chart trendu
for rok_val in ['2023', '2024']:
    dane_rok = df_trend[df_trend['rok'] == rok_val]
    fig_dashboard.add_trace(
        go.Scatter(x=dane_rok['miesiac'], y=dane_rok['sprzedaz'],
                   mode='lines+markers', name=f'Sprzedaż {rok_val}', showlegend=False),
        row=2, col=1
    )

# Panel 4: Histogram wartości zamówień
fig_dashboard.add_trace(
    go.Histogram(x=klienci['srednia_wartosc'], nbinsx=30,
                 showlegend=False, marker_color='#AB63FA', opacity=0.8),
    row=2, col=2
)

fig_dashboard.update_layout(height=800,
    title_text='Dashboard Analityczny — Segmentacja Klientów 2024', title_font_size=16)
fig_dashboard.show()
fig_dashboard.write_html('dashboard_klienci.html')
print("Dashboard zapisany jako dashboard_klienci.html")
```

---

## Ćwiczenie 5: Mini-projekt — pełny pipeline Polars → scikit-learn → Plotly (18 min)

**Cel:** Osoba studiująca integruje wszystkie trzy biblioteki w jeden łańcuch przetwarzania (Polars agreguje → scikit-learn segmentuje → Plotly pokazuje) i zatwierdza pracę przez git commit. To realny przepływ pracy analityka.

### Zadanie

Symulujesz surowe transakcje, agregujesz je do profilu klienta (Polars), segmentujesz klientów (KMeans) i pokazujesz wynik interaktywnie (Plotly).

**Wymaganie minimalne (10 pkt):**
1. Wygeneruj surowe transakcje w Polars (`klient_id`, `kwota`)
2. **Polars**: zagreguj do profilu per klient — liczba zamówień + średnia kwota (`group_by().agg()`)
3. **scikit-learn**: most do Pandas (`.to_pandas()`) → `StandardScaler` → `KMeans(k=3)`
4. **Plotly**: scatter `color='segment'` profilu klientów
5. Opisz każdy segment jednym zdaniem w komentarzu

**Wymaganie rozszerzone (+ 5 pkt):**
6. Dodaj `size='srednia_kwota'` do scatter plotu
7. Wyeksportuj wykres jako HTML: `fig.write_html('pipeline_segmentacja.html')`

### Szablon do wypełnienia

```python
# ============================================================
# MINI-PROJEKT: Pipeline Polars -> scikit-learn -> Plotly
# Imię i nazwisko: [TWOJE DANE]
# Data: 2026-06-XX
# ============================================================

# 0) Surowe transakcje (Polars): 50 000 transakcji, 800 klientów
np.random.seed(7)
n_tx = 50_000
transakcje = pl.DataFrame({
    'klient_id': np.random.randint(1, 801, n_tx),
    'kwota': np.abs(np.random.normal(250, 120, n_tx)).round(2),
})

# 1) POLARS — profil per klient: liczba zamówień + średnia kwota
# TODO: group_by('klient_id').agg( pl.len().alias('liczba_zamowien'),
#       pl.col('kwota').mean().round(2).alias('srednia_kwota') ).sort('klient_id')
profil = ___
print(f"Klientów po agregacji: {profil.height}")
profil.head(3)

# 2) SCIKIT-LEARN — segmentacja (most Polars -> Pandas)
profil_pd = profil.to_pandas()
# TODO: StandardScaler().fit_transform na ['liczba_zamowien', 'srednia_kwota']
X = ___
# TODO: KMeans(k=3, random_state=42, n_init=10).fit_predict(X)
profil_pd['segment'] = ___
profil_pd['segment'] = profil_pd['segment'].astype(str)   # tekst -> osobne kolory w Plotly

# 3) PLOTLY — interaktywna wizualizacja
fig_mp = px.scatter(
    profil_pd, x='srednia_kwota', y='liczba_zamowien', color='segment',
    title='Pipeline: Polars -> scikit-learn -> Plotly (800 klientów)',
    labels={'srednia_kwota': 'Średnia kwota [PLN]',
            'liczba_zamowien': 'Liczba zamówień', 'segment': 'Segment'},
    opacity=0.6,
    # size='srednia_kwota',   # <- odkomentuj dla wymagania rozszerzonego
)
fig_mp.show()

# 4) Eksport HTML (rozszerzenie)
# fig_mp.write_html('pipeline_segmentacja.html')

# TODO: Opisz segmenty (na podstawie wartości)
"""
Segment 0: [opis]
Segment 1: [opis]
Segment 2: [opis]

Rekomendacja marketingowa:
- Dla segmentu ...: [propozycja]
"""
```

### Commit

Po zakończeniu zatwierdź pracę:

```powershell
cd C:\Users\student\python2
git add dzienne\lab13\lab13_advanced_libs.ipynb
# Jeśli zapisałeś pliki HTML:
git add dzienne\lab13\segmentacja_klienci.html
git add dzienne\lab13\pipeline_segmentacja.html
git commit -m "L13: pipeline Polars + scikit-learn + Plotly"
git log --oneline -3
```

### Sprawdzenie 5 ✅

- [ ] Polars agreguje transakcje do profilu (800 klientów)
- [ ] Most `profil.to_pandas()` → StandardScaler → KMeans działa
- [ ] Scatter Plotly pokazuje 3 segmenty (kolory)
- [ ] Każdy segment opisany jednym zdaniem
- [ ] Commit z plikiem `.ipynb` widoczny w `git log`

---

## Podsumowanie zajęć

Co zrobiłeś na tych laboratoriach:
- **KMeans** clustering z `StandardScaler` — segmentacja bez etykiet (unsupervised)
- Pipeline **regresji**: `fit` → `predict` → `r2_score` + `mean_squared_error`
- **Polars**: `select` / `filter` / `group_by().agg()`, lazy evaluation, benchmark vs Pandas
- **Plotly Express**: `px.scatter`, `px.bar`, `px.line` + eksport HTML
- **Pełny pipeline** trzech narzędzi: Polars → scikit-learn → Plotly + commit do git

Następne laboratoria (L14): LLM i AI API — wywołania GPT-4/Claude przez Python, automatyzacja tekstu.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `ModuleNotFoundError: sklearn` | Zainstaluj: `uv pip install scikit-learn` (nie `sklearn`!) |
| `ModuleNotFoundError: plotly` | Zainstaluj: `uv pip install plotly` |
| `ModuleNotFoundError: polars` | Zainstaluj: `uv pip install polars` |
| KMeans daje inne klastry | Ustaw `random_state=42`. Uwaga: numery klastrów (0,1,2) mogą być w innej kolejności — to normalne |
| R² jest ujemne | Model gorszy niż średnia. Sprawdź czy nie zamieniłeś features z target |
| `TypeError: ... squared` przy RMSE | Parametr `squared=False` usunięto z nowego sklearn. Użyj `np.sqrt(mean_squared_error(...))` |
| `fig.show()` nie wyświetla Plotly | `uv pip install nbformat`, zrestartuj kernel. W VS Code: sprawdź Jupyter extension |
| Plotly scatter — wszystko jednego koloru | Kolumna `color=` musi być kategoryczna: `klienci['segment'] = klienci['segment'].astype(str)` |
| `StandardScaler` — po co? | Bez niego KMeans faworyzuje cechy o dużej skali (np. wartosc 0-3000 vs zamowienia 0-25) |
| Polars: `lazy()...filter()` zwraca dziwny obiekt `LazyFrame` | Brak `.collect()` na końcu — bez niego dostajesz PLAN, nie dane. Dodaj `.collect()` |
| Polars: `KeyError` / `df['kolumna']` nie działa jak w Pandas | Używaj `pl.col('kolumna')` w `filter`/`agg`, a do wyboru kolumn `df.select('a', 'b')` |
| Polars: jak wybrać wiersz po pozycji? | Polars **nie ma nazwanego indeksu** jak Pandas. Pozycyjnie `df.row(3)`, ale zwykle wybieraj przez `filter` |
| `pl.from_pandas` / `to_pandas` — `ImportError: pyarrow` | Zainstaluj most: `uv pip install pyarrow` (potrzebny dla kolumn tekstowych) |
| Benchmark Polars wolniejszy niż Pandas | Na bardzo małym zbiorze narzut Polars przeważa — przewaga rośnie z liczbą wierszy (miliony) |
| VS Code nie widzi kernela `.venv` | Ctrl+Shift+P → "Select Kernel" → wybierz `.venv\Scripts\python.exe` |
