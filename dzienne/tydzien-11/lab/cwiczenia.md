# L11 — Ćwiczenia: Statystyka opisowa w Pythonie

**Programowanie w Pythonie II** | Laboratorium 11
**Notebook:** `lab11_statystyka.ipynb`
**Dataset:** generowany w notebooku — 200 pracowników HR

---

## Po tym labie potrafisz

1. **Obliczać** miary centralne (średnia, mediana, dominanta) i rozproszenia (`std`, IQR, percentyle) za pomocą Pandas i NumPy
2. **Stosować** `scipy.stats` — `describe`, `pearsonr`, `spearmanr`, `zscore` — i interpretować wyniki biznesowo
3. **Wykrywać** wartości odstające (outliery) metodami IQR i z-score; oceniać ich wpływ na średnią/std
4. **Analizować** korelacje Pearson/Spearman, dobierać właściwą do typu danych (liniowe vs monotoniczne)
5. **Budować** kompletny raport statystyczny dla menedżera, łącząc liczby z interpretacją biznesową

---

## Start (3 komendy w terminalu Windows — PowerShell)

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: **`lab11_statystyka.ipynb`**.

> **Uwaga:** jeśli `scipy` nie jest zainstalowany — w aktywowanym venv: `uv pip install scipy`.

---

## Tabela referencyjna — statystyka w Pythonie

| Chcę... | Kod | Uwaga |
|---------|-----|-------|
| Średnia / mediana / dominanta | `df['kol'].mean()` / `.median()` / `.mode().iloc[0]` | mode zwraca Series — bierzemy pierwszą |
| Std / wariancja | `df['kol'].std()` / `.var()` | pandas: ddof=1 (próba) |
| Percentyle | `df['kol'].quantile([0.25, 0.5, 0.75])` | Q1, mediana, Q3 |
| IQR | `Q3 - Q1` lub `scipy.stats.iqr(arr)` | Q3-Q1 = środkowe 50% |
| Pearson | `from scipy.stats import pearsonr; r, p = pearsonr(x, y)` | zależność liniowa |
| Spearman | `from scipy.stats import spearmanr; r, p = spearmanr(x, y)` | zależność monotoniczna |
| Macierz korelacji | `df.corr()` (Pearson) lub `df.corr(method='spearman')` | tylko numeryczne kolumny |
| Skośność, kurtoza | `from scipy.stats import skew, kurtosis; skew(arr), kurtosis(arr)` | scipy: kurtoza Fishera |
| Pełen opis rozkładu | `from scipy.stats import describe; describe(arr)` | mean, var, skew, kurt, n |
| Z-score | `np.abs(stats.zscore(arr)) > 3` | outlier dla \|z\| > 3 |
| IQR-test outlier | `(arr < Q1-1.5*IQR) \| (arr > Q3+1.5*IQR)` | reguła Tukeya |
| Statystyki per grupa | `df.groupby('kol').describe()` | wszystkie podstawowe |
| Quick-and-dirty | `df.describe()` | mean, std, kwartyle |

---

## Setup — uruchom jako pierwszą komórkę

> **Uwaga:** dataset poniżej różni się od tego z wykładu — ten sam schemat HR, ale **inny zestaw outlierów** (5 wstawionych losowo) i **dodatkowe kolumny** (`wiek`, `ocena_roczna`). Nazwy kolumn (`dzial`, `staz_lat`) są takie same jak w wykładzie — kod z notebooka wykładowego można skopiować bez zmian.

```python
%matplotlib inline
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

# Seed zapewnia identyczne dane u każdego studenta
np.random.seed(42)
n = 200

dzialy = np.random.choice(['IT', 'Sprzedaz', 'HR', 'Marketing', 'Finanse'], n,
                           p=[0.30, 0.25, 0.15, 0.20, 0.10])
staz = np.random.gamma(shape=3, scale=2, size=n).clip(0.5, 20).round(1)
baza = {'IT': 9000, 'Sprzedaz': 7000, 'HR': 6500, 'Marketing': 7500, 'Finanse': 8500}
wynagrodzenie = np.array([
    baza[d] + staz[i] * 300 + np.random.normal(0, 1200)
    for i, d in enumerate(dzialy)
]).clip(4000, 25000).round(-2)

# 5 celowo wstawionych outlierów (błędy danych / kontrakty specjalne)
wynagrodzenie[np.random.choice(n, 5, replace=False)] = np.random.choice(
    [2000, 2500, 35000, 40000, 38000], 5, replace=False
)

df = pd.DataFrame({
    'dzial': dzialy,
    'staz_lat': staz,
    'wynagrodzenie': wynagrodzenie,
    'wiek': (25 + staz + np.random.normal(0, 3, n)).clip(22, 65).round().astype(int),
    'ocena_roczna': np.random.choice([1, 2, 3, 4, 5], n, p=[0.05, 0.10, 0.40, 0.35, 0.10])
})

print(f"Dataset HR: {df.shape[0]} pracowników, {df.shape[1]} kolumn")
print(df.head())
print("\nTypy kolumn:")
print(df.dtypes)
```

## Przydatne materiały

| Temat | Link |
|-------|------|
| SciPy — `scipy.stats` | https://docs.scipy.org/doc/scipy/reference/stats.html |
| SciPy — `describe()` | https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.describe.html |
| SciPy — `pearsonr()` | https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.pearsonr.html |
| SciPy — `spearmanr()` | https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.spearmanr.html |
| SciPy — `zscore()` | https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.zscore.html |
| Pandas — `describe()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html |
| Pandas — `groupby()` | https://pandas.pydata.org/docs/user_guide/groupby.html |
| Wikipedia — Statystyka opisowa | https://pl.wikipedia.org/wiki/Statystyka_opisowa |

### Kluczowe pojęcia

- **Średnia** (`mean`) — suma wartości / liczba obserwacji. Wrażliwa na wartości odstające.
- **Mediana** (`median`) — wartość środkowa po posortowaniu. Odporna na outliery.
- **Dominanta** (`mode`) — najczęściej występująca wartość.
- **Odchylenie standardowe** (`std`) — jak bardzo wartości rozpraszają się wokół średniej.
- **IQR** (rozstęp międzykwartylowy) — Q3 - Q1, obejmuje środkowe 50% danych. Stabilny miernik rozproszenia.
- **Korelacja Pearsona** (`r`) — siła liniowej zależności (-1 do +1). Wrażliwa na outliery.
- **Korelacja Spearmana** (`ρ`) — siła monotonicznej zależności. Oparta na rangach, odporniejsza.
- **Skośność** (`skewness`) — > 0 = prawostronna (długi prawy ogon), < 0 = lewostronna.
- **Z-score** — ile odchyleń standardowych od średniej. |z| > 3 = prawdopodobny outlier.

---

## Ćwiczenie 1: Statystyki opisowe na danych biznesowych (20 min)

**Kontekst biznesowy:** Jesteś analitykiem w dziale HR firmy technologicznej. Dyrektor personalny pyta: "Jak wyglądają nasze wynagrodzenia? Czy są zróżnicowane? Który dział płaci najlepiej?" Twoim zadaniem jest przygotowanie raportu statystycznego.

### 1a. Miary tendencji centralnej

Oblicz i wyświetl średnią, medianę i dominantę kolumny `wynagrodzenie`. Wynik sformatuj jako PLN.

```python
placa = df['wynagrodzenie']

# Uzupełnij: oblicz średnią, medianę i dominantę
srednia  = ___
mediana  = ___
dominanta = ___

print("=== MIARY TENDENCJI CENTRALNEJ ===")
print(f"Średnia:   {srednia:>10,.0f} PLN")
print(f"Mediana:   {mediana:>10,.0f} PLN")
print(f"Dominanta: {dominanta:>10,.0f} PLN")

# Odpowiedz na pytanie w komentarzu:
# Czy mediana < średnia? Co to mówi o rozkładzie?
```

**Pytanie:** Dlaczego mediana jest niższa od średniej? Jaki typ pracowników podnosi średnią?

### 1b. Miary rozproszenia

Oblicz odchylenie standardowe, IQR i rozstęp wynagrodzeń.

```python
# Uzupełnij
odch_std = ___
q1 = ___  # quantile(0.25)
q3 = ___  # quantile(0.75)
iqr = ___
rozstep = ___  # max - min

print("=== MIARY ROZPROSZENIA ===")
print(f"Odchylenie std: {odch_std:>10,.0f} PLN")
print(f"Q1 (P25):       {q1:>10,.0f} PLN")
print(f"Q3 (P75):       {q3:>10,.0f} PLN")
print(f"IQR:            {iqr:>10,.0f} PLN")
print(f"Rozstęp:        {rozstep:>10,.0f} PLN")

# Odpowiedz w komentarzu: dlaczego rozstęp jest tak duży?
```

### 1c. Statystyki per dział

Oblicz średnią, medianę i odchylenie standardowe per dział, posortowane malejąco po medianie.

```python
dzialy_stats = df.groupby('dzial', observed=True)['wynagrodzenie'].agg([
    'mean', 'median', 'std'
]).round(0).sort_values('median', ascending=False)
dzialy_stats.columns = ['Średnia', 'Mediana', 'Std']
print("=== WYNAGRODZENIA PER DZIAŁ ===")
print(dzialy_stats)
```

### 1d. Wizualizacja — histogram z miarami centralnymi

```python
fig, ax = plt.subplots(figsize=(10, 5))

# Uzupełnij ___ wartościami:
ax.hist(___, bins=___, color='steelblue', alpha=0.8, edgecolor='white')
ax.axvline(___, color='red', linestyle='--', lw=2, label=f'Średnia: {___:,.0f}')
ax.axvline(___, color='green', linestyle='-', lw=2, label=f'Mediana: {___:,.0f}')
ax.axvline(___, color='orange', linestyle=':', lw=2, label=f'Dominanta: {___:,.0f}')
# Uwaga: dominanta i mediana mogą się prawie pokryć — to też informacja

ax.set_title('Rozkład wynagrodzeń — miary tendencji centralnej')
ax.set_xlabel('Wynagrodzenie (PLN)')
ax.set_ylabel('Liczba pracowników')
ax.legend()
plt.tight_layout()
plt.show()
plt.close()
```

### Sprawdzenie 1 ✅

- [ ] Średnia: **9 940 PLN**, Mediana: **9 450 PLN**, Dominanta: **9 500 PLN**
- [ ] Mediana < Średnia → rozkład prawostronnie skośny (outlierzy wysokich pensji)
- [ ] Std: **3 980 PLN**, IQR: **2 500 PLN**, Rozstęp: **38 000 PLN**
- [ ] Dział IT: mediana **10 600 PLN** — najwyższa ze wszystkich działów
- [ ] Dział HR i Sprzedaż: mediana **8 400 PLN** — najniższe
- [ ] Histogram: czerwona linia (średnia) widocznie na prawo od zielonej (mediany)

---

## Ćwiczenie 2: Analiza korelacji (20 min)

**Kontekst biznesowy:** Dyrektor finansowy pyta: "Co decyduje o wysokości wynagrodzenia — staż pracy, wiek, a może ocena roczna? A jak wygląda zależność między wydatkami na marketing a przychodami?" Twoja analiza pomoże podjąć decyzję o polityce wynagrodzeń i budżecie marketingowym.

### 2a. Korelacja Pearsona: staż vs wynagrodzenie

```python
# Uzupełnij: oblicz korelację Pearsona
# stats.pearsonr() zwraca (r, p_value)
r, p_value = stats.pearsonr(___, ___)

print(f"Korelacja Pearsona (staż–wynagrodzenie):")
print(f"  r = {r:.4f}")
print(f"  p = {p_value:.4f}")
print(f"  Interpretacja: {'istotna' if p_value < 0.05 else 'nieistotna'} statystycznie")
```

### 2b. Korelacja Spearmana — porównanie

```python
# Oblicz korelację Spearmana (odporniejsza na outliery)
rho, p_rho = stats.spearmanr(df['staz_lat'], df['wynagrodzenie'])

print(f"Korelacja Spearmana (staż–wynagrodzenie):")
print(f"  rho = {rho:.4f}")
print(f"  p   = {p_rho:.4f}")
print(f"\nPorównanie: Pearson r={r:.3f} vs Spearman rho={rho:.3f}")
print(f"Różnica: {abs(rho - r):.3f} — {'duże' if abs(rho-r) > 0.1 else 'małe'} rozbieżności")

# Odpowiedz w komentarzu: dlaczego Spearman jest wyższy niż Pearson?
```

### 2c. Macierz korelacji — wszystkie zmienne

```python
# Oblicz pełną macierz korelacji Pearsona
corr = df[['staz_lat', 'wynagrodzenie', 'wiek', 'ocena_roczna']].corr()
print("Macierz korelacji Pearsona:")
print(corr.round(3))

# Wizualizacja — heatmapa (matplotlib już zaimportowany w Setupie)
fig, ax = plt.subplots(figsize=(7, 6))

# Rysuj heatmapę ręcznie (bez seaborn)
im = ax.imshow(corr.values, cmap='coolwarm', vmin=-1, vmax=1)
plt.colorbar(im, ax=ax)

ax.set_xticks(range(len(corr.columns)))
ax.set_yticks(range(len(corr.columns)))
ax.set_xticklabels(corr.columns, rotation=45, ha='right')
ax.set_yticklabels(corr.columns)

# Dodaj wartości w komórkach
for i in range(len(corr)):
    for j in range(len(corr.columns)):
        ax.text(j, i, f'{corr.values[i, j]:.2f}',
                ha='center', va='center', fontsize=11,
                color='black' if abs(corr.values[i,j]) < 0.7 else 'white')

ax.set_title('Macierz korelacji — dataset HR')
plt.tight_layout()
plt.show()
plt.close()
```

### 2d. Korelacja: marketing spend vs revenue

Poniższe dane symulują miesięczne wydatki marketingowe i przychody firmy. Zbadaj zależność.

```python
np.random.seed(100)
n_mkt = 50
marketing_spend = np.random.uniform(10000, 100000, n_mkt)
revenue = marketing_spend * 5.2 + np.random.normal(0, 30000, n_mkt)
revenue = revenue.clip(0)

# Oblicz korelację Pearsona
r_mkt, p_mkt = stats.pearsonr(marketing_spend, revenue)

# Scatter plot z linią trendu
fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(marketing_spend, revenue, alpha=0.6, color='coral', s=50)

# Dodaj linię trendu (polyfit stopień 1)
z = np.polyfit(marketing_spend, revenue, 1)
p_fit = np.poly1d(z)
x_line = np.linspace(marketing_spend.min(), marketing_spend.max(), 100)
ax.plot(x_line, p_fit(x_line), 'b--', lw=2, label=f'Trend (r={r_mkt:.2f})')

ax.set_title('Wydatki na marketing vs Przychody')
ax.set_xlabel('Wydatki na marketing (PLN)')
ax.set_ylabel('Przychody (PLN)')
ax.legend()
plt.tight_layout()
plt.show()
plt.close()

print(f"Marketing spend vs Revenue: r = {r_mkt:.4f}, p = {p_mkt:.2e}")
```

### Sprawdzenie 2 ✅

- [ ] Pearson staż–wynagrodzenie: **r = 0.3198**, p < 0.001 (statystycznie istotna)
- [ ] Spearman staż–wynagrodzenie: **rho = 0.5219** — wyższy niż Pearson (bo Spearman jest odporny na outlierów, które zaburzają liniowość)
- [ ] Macierz korelacji: staż–wiek = **0.756** (najsilniejsza korelacja w matrycy)
- [ ] ocena_roczna: korelacja z wynagrodzeniem **r = −0.054** — praktycznie brak zależności
- [ ] Marketing spend vs Revenue: **r ≈ 0.9806** — bardzo silna korelacja liniowa
- [ ] Heatmapa: komórka staż–wiek wyróżniona kolorem (najciemniejsza czerwień)

---

## Ćwiczenie 3: Pełna analiza statystyczna datasetu HR (30 min) — z mniejszym wsparciem

**Kontekst biznesowy:** Przygotowujesz kompleksowy raport HR dla zarządu. Raport musi zawierać: opis rozkładu wynagrodzeń (skośność, kurtoza), analizę percentylową, porównanie działów i wnioski biznesowe. Całość w jednym notebooku, czytelnie sformatowana.

**Zadania do wykonania samodzielnie:**

### 3a. scipy.stats.describe — szybki przegląd rozkładu

Użyj `stats.describe()` na kolumnie `wynagrodzenie`. Wyświetl wszystkie 6 miar i zinterpretuj skośność i kurtozę słownie.

```python
# Użyj: stats.describe(df['wynagrodzenie'])
# Wyświetl: nobs, min, max, mean, variance, skewness, kurtosis
# Dodaj interpretację w komentarzu lub print()
```

**Wskazówka:** Skośność > 1.0 = silnie prawoskośny. Kurtoza > 0 = spiczasty rozkład z grubymi ogonami (więcej ekstremalnych wartości niż rozkład normalny).

### 3b. Analiza percentylowa

Oblicz i wyświetl percentyle P10, P25, P50, P75, P90, P95, P99 dla wynagrodzeń.

```python
# Użyj: np.percentile(df['wynagrodzenie'], [10, 25, 50, 75, 90, 95, 99])
# Albo: pd.Series(df['wynagrodzenie']).quantile([0.10, 0.25, ...])
# Wyświetl jako tabelę: "P10: 7 190 PLN", "P50: 9 450 PLN" itd.
```

**Pytanie biznesowe:** Firma chce płacić pracownikom powyżej P75 rynkowego benchmarku. Ile wynosi P75 w naszym datasecie? Ilu % pracowników zarabia powyżej 12 000 PLN?

### 3c. Analiza per dział — pełna tabela

Stwórz tabelę statystyk per dział z kolumnami: Średnia, Mediana, Std, Min, Max, IQR. Posortuj malejąco po medianie.

```python
# df.groupby('dzial', observed=True)['wynagrodzenie'].agg([...])
# agg: 'mean', 'median', 'std', 'min', 'max'
# IQR: lambda x: x.quantile(0.75) - x.quantile(0.25)
```

### 3d. Wizualizacja — boxplot per dział

Narysuj boxplot wynagrodzeń per dział (`df.boxplot(column='wynagrodzenie', by='dzial')` — Pandas wbudowane, bez seaborn). Dodaj linię poziomą pokazującą medianę globalną.

```python
# Użyj df.boxplot(column='wynagrodzenie', by='dzial') — wbudowany Pandas, bez seaborn
# Dodaj: ax.axhline(df['wynagrodzenie'].median(), color='red', linestyle='--', label='Mediana globalna')
# Tytuł, etykiety osi, legenda
```

### 3e. scipy.stats.describe — per dział IT i HR

Sprawdź skośność i kurtozę oddzielnie dla działu IT i HR. Jak się różnią i dlaczego?

```python
for d in ['IT', 'HR']:
    podzb = df[df['dzial'] == d]['wynagrodzenie']
    opis = stats.describe(podzb)
    print(f"\n{d} (n={opis.nobs}):")
    print(f"  Skośność: {opis.skewness:.3f}")
    print(f"  Kurtoza:  {opis.kurtosis:.3f}")
    # Zinterpretuj wynik w komentarzu
```

### Sprawdzenie 3 ✅

- [ ] `stats.describe()` skośność wynagrodzenia: **≈ 5.10** (silnie prawoskośny)
- [ ] `stats.describe()` kurtoza: **≈ 34.16** (bardzo spiczasty — grube ogony przez outlierów)
- [ ] Percentyle: P10 = **7 190 PLN**, P50 = **9 450 PLN**, P75 = **10 700 PLN**, P90 = **12 310 PLN**, P99 ≈ **35 030 PLN**
- [ ] Odsetek pracowników powyżej 12 000 PLN: `(df['wynagrodzenie'] > 12000).mean()` ≈ **10–13%**
- [ ] Tabela działów: IT mediana 10 600 PLN (najwyższa), HR i Sprzedaż 8 400 PLN (najniższe)
- [ ] IT skośność: **≈ 5.07** (outlierzy!), HR skośność: **≈ −0.46** (prawie symetryczny)
- [ ] Boxplot: IT ma punkty outlierów wyraźnie powyżej górnego wąsa

---

## Ćwiczenie 4: Wykrywanie outlierów + commit (15 min)

**Kontekst biznesowy:** Przed finalnym raportem musisz zidentyfikować pracowników z anomalnymi wynagrodzeniami. Mogą to być błędy w danych lub specjalne kontrakty — każdy przypadek wymaga wyjaśnienia.

### 4a. Wykrywanie outlierów metodą IQR

```python
# Oblicz granice IQR
q1 = df['wynagrodzenie'].quantile(0.25)
q3 = df['wynagrodzenie'].quantile(0.75)
iqr = q3 - q1
dolna = q1 - 1.5 * iqr
gorna = q3 + 1.5 * iqr

print(f"IQR granice: [{dolna:,.0f} PLN, {gorna:,.0f} PLN]")

# Wykryj outlierów
maska_iqr = (df['wynagrodzenie'] < dolna) | (df['wynagrodzenie'] > gorna)
outliery = df[maska_iqr]

print(f"Liczba outlierów: {maska_iqr.sum()} z {len(df)}")
print("\nSzczegóły outlierów:")
print(outliery[['dzial', 'staz_lat', 'wynagrodzenie']].to_string())
```

### 4b. Wykrywanie outlierów metodą z-score

```python
# Oblicz z-score: stats.zscore()
z_scores = np.abs(stats.zscore(df['wynagrodzenie']))
maska_z = z_scores > 3.0

outliery_z = df[maska_z]
print(f"Outlierzy z-score (|z| > 3.0): {maska_z.sum()} obserwacji")
print(outliery_z[['dzial', 'staz_lat', 'wynagrodzenie']].to_string())
```

### 4c. Wpływ outlierów na statystyki

Oblicz średnią, medianę i std dla danych z outlierami i bez. Wyświetl jako tabelę porównawczą.

```python
bez_outlierow = df[~maska_iqr]['wynagrodzenie']
z_outlierami  = df['wynagrodzenie']

print(f"{'Miara':<20} {'Z outlierami':>15} {'Bez outlierów':>15} {'Zmiana':>10}")
print("-" * 62)

for nazwa, f_z, f_bez in [
    ('Średnia', z_outlierami.mean(), bez_outlierow.mean()),
    ('Mediana', z_outlierami.median(), bez_outlierow.median()),
    ('Std',    z_outlierami.std(), bez_outlierow.std()),
]:
    zmiana = f_z - f_bez
    print(f"{nazwa:<20} {f_z:>15,.0f} {f_bez:>15,.0f} {zmiana:>+10,.0f}")

# Odpowiedz w komentarzu: która miara jest bardziej stabilna? Dlaczego?
```

### 4d. Commit

Zapisz notebook i wykonaj commit:

```bash
git add lab11_statystyka.ipynb
git commit -m "L11: analiza statystyczna HR — miary, korelacja, outliery"
```

### Sprawdzenie 4 ✅

- [ ] IQR dolna granica: **4 450 PLN**, górna granica: **14 450 PLN**
- [ ] Outlierzy IQR: **7 obserwacji** (5 wstawionych + 2 naturalne wartości skrajne)
- [ ] Outlierzy z-score (|z| > 3): **3 obserwacje** (tylko najekstremalniejsi: 35 000, 38 000, 40 000 PLN)
- [ ] Porównanie z/bez outlierów:
  - Średnia: z = **9 940 PLN**, bez = **9 532 PLN** — różnica **408 PLN**
  - Mediana: z = **9 450 PLN**, bez = **9 400 PLN** — różnica tylko **50 PLN**
  - Std: z = **3 980 PLN**, bez = **1 798 PLN** — różnica **2 182 PLN** (ponad 2×!)
- [ ] Wniosek: mediana prawie nie reaguje na outlierów, std jest bardzo wrażliwe
- [ ] `git log` — widoczny commit z plikiem `lab11_statystyka.ipynb`

---

## Podsumowanie

Po ukończeniu wszystkich ćwiczeń osoba studiująca potrafi:
- Obliczać i interpretować miary centralne i rozproszenia w kontekście biznesowym
- Analizować korelację między zmiennymi i odróżniać korelację od przyczynowości
- Używać `scipy.stats.describe()` do szybkiego opisu rozkładu
- Wykrywać wartości odstające metodą IQR i z-score oraz oceniać ich wpływ na analizę
- Łączyć statystyki z wizualizacją w spójnym raporcie

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `ModuleNotFoundError: scipy` | Zainstaluj: `uv pip install scipy` w aktywowanym venv |
| `stats.pearsonr()` zwraca obiekt, nie tuple (scipy ≥ 1.9) | Użyj atrybutów: `wynik = pearsonr(x, y); r = wynik.statistic; p = wynik.pvalue`. Dla wstecznej kompatybilności `r, p = pearsonr(x, y)` też działa. |
| `df['kol'].mode()` zwraca Series | Dla jednej kolumny: `df['kol'].mode().iloc[0]` — `.iloc[0]` bierze pierwszą dominantę |
| Z-score: `TypeError: can't convert str` | Z-score działa tylko na liczbach: `stats.zscore(df['wynagrodzenie'])`, nie na kolumnie tekstowej |
| Histogram nie pokazuje się | Dodaj `%matplotlib inline` na początku notebooka |
| Korelacja wychodzi NaN | Sprawdź czy w danych nie ma NaN: `df[['kol1','kol2']].dropna()` przed obliczeniem |
| `groupby` — FutureWarning | Dodaj `observed=True`: `df.groupby('dzial', observed=True)` |
| `np.std(arr)` daje inny wynik niż `df['kol'].std()` | NumPy domyślnie `ddof=0` (populacja), Pandas `ddof=1` (próba). Dla danych biznesowych preferuj Pandas lub `np.std(arr, ddof=1)` |
| `pearsonr` rzuca błąd przy NaN | scipy nie radzi sobie z NaN; użyj `df.dropna(subset=['x', 'y'])` przed obliczeniem |
| `scipy.stats.zscore` zwraca ndarray (a nie Series) | Opakuj: `pd.Series(stats.zscore(df['kol']), index=df.index)` zachowuje indeks DataFrame |
| Mediana wychodzi taka sama jak średnia, choć są outliery | Sprawdź czy outliery faktycznie są — `df.describe()`. Mediana z 200 obserwacji jest stabilna, średnia może być przesunięta o niewielką wartość |
| Macierz korelacji `df.corr()` ma `NaN` w wierszu/kolumnie | Kolumna ma stałą wartość (zerowa wariancja) lub same NaN — sprawdź `df.var()` |
| Wykres słupkowy działów ma niespójną kolejność | Dodaj `.sort_values('mediana_pln', ascending=False)` przed plotem |
| `quantile(0.95)` daje wartość niższą niż `mean()` | To normalne dla rozkładów prawostronnie skośnych — średnia ucieka za ogonem, P95 nadal jest poniżej |
| Outlier IQR vs z-score — różna liczba | IQR jest bardziej czuły (niskie progi), z-score wymaga \|z\| > 3 = bardzo dużych odchyleń. Spodziewaj się że IQR znajdzie więcej |
| `describe()` od scipy zwraca named tuple | Atrybuty: `.nobs, .minmax, .mean, .variance, .skewness, .kurtosis` |
| Pearson + p-value: co znaczy `p < 0.05`? | Im mniejsze `p`, tym mocniejszy sygnał że korelacja nie jest przypadkowa. Próg 0.05 — konwencja; szczegóły na W12 |
| `Sprzedaz` vs `Sprzedaz` w wynikach | Po polsku w datasecie używamy `Sprzedaz` (z ż) — sprawdź czy filtr używa identycznej wartości |

---

## Dla zaawansowanych

Po wykonaniu 4 ćwiczeń podstawowych — pięć ścieżek dla osób, które chcą iść dalej:

### Ścieżka 1: Median Absolute Deviation (MAD) — alternatywa dla std
Std jest wrażliwe na outliery (bo używa kwadratu różnicy od średniej — duże odchylenia mocno powiększają wynik). MAD = mediana(|x − mediana(x)|) — odporna miara rozproszenia, używana w *robust statistics* (statystyce odpornej).

```python
from scipy.stats import median_abs_deviation
mad = median_abs_deviation(df['wynagrodzenie'])
print(f"MAD wynagrodzeń: {mad:.0f} PLN  (vs std: {df['wynagrodzenie'].std():.0f})")
```

### Ścieżka 2: Bootstrap — przedział ufności średniej
Bootstrap (przepróbkowanie ze zwracaniem) szacuje niepewność estymatora bez zakładania rozkładu. Zaimplementuj:
- 1000 razy losuj próbę z DataFrame (`df.sample(n=len(df), replace=True)`)
- W każdej próbie policz średnią
- Przedział ufności 95%: `np.percentile(srednie, [2.5, 97.5])`

### Ścieżka 3: Korelacja częściowa (partial correlation)
Korelacja Pearson(staż, pensja) = +0.5. Ale może to staż wpływa na ocenę roczną, a ocena na pensję? Korelacja częściowa **kontroluje** trzecią zmienną:
```python
# Pakiet pingouin: uv pip install pingouin
import pingouin as pg
pg.partial_corr(data=df, x='staz_lat', y='wynagrodzenie', covar='ocena_roczna')
```
Jak zmienia się r po kontroli oceny? O czym to mówi?

### Ścieżka 4: Test normalności (Shapiro-Wilk)
Czy wynagrodzenia w dziale IT są rozkładem normalnym? Sprawdź:
```python
from scipy.stats import shapiro
it_pensje = df[df['dzial'] == 'IT']['wynagrodzenie']
stat, p = shapiro(it_pensje)
print(f"Shapiro-Wilk: stat={stat:.3f}, p={p:.4f}")
print("Rozkład normalny?" + (" TAK" if p > 0.05 else " NIE — odrzucamy H0 (hipoteza zerowa: rozkład jest normalny; szczegóły testów hipotez na W12)"))
```

### Ścieżka 5: Własny dataset
Pobierz publiczny dataset (np. [Polish Open Data](https://dane.gov.pl/), [GUS](https://stat.gov.pl/), Kaggle) — przeprowadź pełną analizę statystyczną wg schematu z dzisiejszego labu. Zarejestruj wnioski biznesowe.
