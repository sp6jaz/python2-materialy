# L10 — Ćwiczenia laboratoryjne

## Temat: Seaborn + GridSpec — dashboard analityczny restauracji

**Programowanie w Pythonie II** | Laboratorium 10
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne, dozwolony pair programming
**Dataset:** `tips` (244 rachunki z restauracji, wbudowany w seaborn)

---

## Efekty uczenia się

Po wykonaniu laboratorium osoba studiująca:

1. **Tworzy** statystyczne wykresy seaborn (`barplot`, `boxplot`, `violinplot`, `heatmap`, `scatterplot`) z parametrem `hue` do podziału na grupy
2. **Konstruuje** wielopanelowy dashboard używając `GridSpec` z nieregularnymi panelami
3. **Wybiera** typ wykresu odpowiedni do pytania biznesowego (porównanie → barplot, rozkład → boxplot/violinplot, korelacja → heatmap)
4. **Projektuje** spójną narrację dashboardu (jednolita paleta, hierarchia ważności paneli)
5. **Eksportuje** wizualizację do PNG z parametrami publikacyjnymi (`dpi=150`, `bbox_inches='tight'`, `facecolor='white'`)

Materiał laboratorium kontynuuje treści wykładu W10 (gramatyka grafiki seaborn, model obiektowy `Figure ↔ Axes`, dwa style API, format danych long vs wide) na praktycznym przykładzie dashboardu analitycznego restauracji.

---

## Start (3 komendy w terminalu Windows — PowerShell, jak w L09)

```powershell
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

W VS Code utwórz folder `W10/` w katalogu projektu. Wewnątrz utwórz notebook `lab10_seaborn_dashboard.ipynb`.

> **Powtórka z W09:** seaborn jest zainstalowany w `.venv` (z L09). Weryfikacja: `python -c "import seaborn; print(seaborn.__version__)"` — wymagana wersja 0.13+. W razie braku: `uv pip install seaborn` w aktywowanym `.venv`.

**Commit na końcu zajęć:** `git commit -m "L10: Dashboard seaborn — barplot, boxplot, heatmap, GridSpec"` + `git push`. Wszystkie zapisane PNG-i + notebook trafiają do `W10/` i jadą razem do GitHuba.

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Seaborn — oficjalna dokumentacja | https://seaborn.pydata.org/ |
| Seaborn — Tutorial | https://seaborn.pydata.org/tutorial.html |
| Seaborn — `barplot()` | https://seaborn.pydata.org/generated/seaborn.barplot.html |
| Seaborn — `boxplot()` | https://seaborn.pydata.org/generated/seaborn.boxplot.html |
| Seaborn — `violinplot()` | https://seaborn.pydata.org/generated/seaborn.violinplot.html |
| Seaborn — `heatmap()` | https://seaborn.pydata.org/generated/seaborn.heatmap.html |
| Seaborn — Lista palet | https://seaborn.pydata.org/tutorial/color_palettes.html |
| Matplotlib — `GridSpec` | https://matplotlib.org/stable/api/_as_gen/matplotlib.gridspec.GridSpec.html |
| Matplotlib — Cheatsheets | https://matplotlib.org/cheatsheets/ |

### Kluczowe pojęcia (powtórka z wykładu)

- **`hue=`** — *aesthetics mapping* (mapowanie estetyczne); kolumna kategoryczna → kolor. Np. `hue='sex'` → mężczyźni inny kolor niż kobiety.
- **`palette=`** — zestaw kolorów. Jakościowe: `'muted'`, `'Set2'`, `'colorblind'`. Sekwencyjne: `'Blues'`, `'YlOrRd'`. Dywergencyjne: `'coolwarm'`, `'RdBu_r'`.
- **`errorbar=('ci', 95)`** — *95% CI* (przedział ufności średniej); domyślne w `barplot`. Wąsy pokazują niepewność, NIE rozrzut.
- **`figure-level` vs `axes-level`** — `pairplot`/`jointplot`/`catplot` tworzą własną figurę (NIE przyjmują `ax=`); reszta przyjmuje `ax=` i działa w `subplots`/`GridSpec`.
- **`GridSpec`** — siatka z nieregularnymi panelami. `gs[0, :]` cały wiersz, `gs[1:, 0]` dwie komórki w kolumnie 0.
- **`constrained_layout=True`** — automatyczne marginesy, lepsze niż `tight_layout()` od matplotlib 3.6+.

### Tabela referencyjna — seaborn + GridSpec

| Chcę | Kod |
|------|-----|
| Setup raz na początku | `sns.set_theme(style='whitegrid', palette='muted')` |
| Średnia + 95% CI per kategoria | `sns.barplot(data=df, x='kat', y='num', hue='grupa', ax=ax, errorbar=('ci', 95))` |
| Rozkład per kategoria (Q1, Q2, Q3, IQR) | `sns.boxplot(data=df, x='kat', y='num', hue='kat', legend=False, ax=ax)` |
| Rozkład jako KDE (gęstość) | `sns.violinplot(data=df, x='kat', y='num', hue='grupa', split=True, inner='box', ax=ax)` |
| Macierz korelacji | `sns.heatmap(df.corr(), annot=True, fmt='.2f', cmap='coolwarm', center=0, ax=ax)` |
| Pivot table jako kolory | `sns.heatmap(df.pivot_table(...), annot=True, cmap='YlOrRd', ax=ax)` |
| Korelacja dwóch zmiennych | `sns.scatterplot(data=df, x='n1', y='n2', hue='kat', style='kat2', alpha=0.7, ax=ax)` |
| Liczba obserwacji per kategoria | `sns.countplot(data=df, x='kat', hue='kat2', ax=ax)` |
| Macierz par (poza dashboardem) | `g = sns.pairplot(df[cols], hue='kat')` *(NIE w subplots!)* |
| Regularna siatka 2×2 | `fig, axes = plt.subplots(2, 2, figsize=(13, 9), constrained_layout=True)` |
| Nieregularna siatka 3×3 | `gs = gridspec.GridSpec(3, 3, figure=fig); ax = fig.add_subplot(gs[0, :])` |
| Tytuł całej figury | `fig.suptitle('Tytuł', fontsize=14, fontweight='bold')` |
| Eksport publikacyjny | `plt.savefig('plik.png', dpi=150, bbox_inches='tight', facecolor='white')` |
| Adnotacja strzałką | `ax.annotate('tekst', xy=(x, y), xytext=(x+1, y+1), arrowprops=dict(arrowstyle='->'))` |

> ⚠️ **Pułapki seaborn 0.13+:**
> - `palette=` BEZ `hue=` rzuca FutureWarning. Workaround: `hue=x_kolumna, legend=False` gdy nie potrzebujesz legendy.
> - `groupby()` na kolumnach kategorycznych: dodaj `observed=True` aby uniknąć FutureWarning.
> - `pairplot` NIE przyjmuje `ax=` — to *figure-level* function, ma własną figurę.

---

## Dane startowe — pierwsza komórka notebooka

```python
%matplotlib inline
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import pandas as pd
import numpy as np

# Globalny motyw — raz, na początku notebooka
sns.set_theme(style='whitegrid', palette='muted')

# Dataset tips — restauracja, 244 rachunki (znany z W09)
tips = sns.load_dataset('tips')

print(f"Tips dataset: {tips.shape[0]} wierszy × {tips.shape[1]} kolumn")
print(f"Kolumny: {list(tips.columns)}")
tips.head(3)
```

### Opis datasetu `tips` (przypomnienie z W09)

| Kolumna | Typ | Opis |
|---------|-----|------|
| `total_bill` | float | Wartość rachunku w \$ (3.07 — 50.81) |
| `tip` | float | Napiwek w \$ (1.00 — 10.00) |
| `sex` | category | Płeć płacącego (`'Male'` / `'Female'`) |
| `smoker` | category | Sekcja palaczy (`'Yes'` / `'No'`) |
| `day` | category | Dzień tygodnia (`'Thur'`, `'Fri'`, `'Sat'`, `'Sun'`) |
| `time` | category | Pora dnia (`'Lunch'` / `'Dinner'`) |
| `size` | int | Liczba osób przy stoliku |

**Czym L10 różni się od L09:** L09 użyło tych samych danych do podstawowych wykresów matplotlib. L10 — **te same dane, ale przez seaborn + GridSpec**. Skupiasz się na *nowych narzędziach*, nie na poznawaniu nowej domeny.

---

## Ćwiczenie 1: Statystyczne wykresy seaborn (20 min)

**Cel:** Stworzyć cztery statystyczne wykresy seaborn (`barplot`, `boxplot`, `heatmap`, `scatterplot`) z parametrem `hue` i zapisać każdy jako PNG.

**Kontekst biznesowy:** Jesteś analitykiem restauracji „Pod Widelcem". Właściciel chce zobaczyć podstawowe statystyki — średnie rachunki, rozkłady napiwków, korelacje między zmiennymi.

### Zadanie 1.1 — Barplot z hue (wzór do skopiowania)

Średni rachunek per dzień tygodnia, z podziałem wg płci.

```python
fig, ax = plt.subplots(figsize=(9, 5))

sns.barplot(
    data=tips,
    x='day',
    y='total_bill',
    hue='sex',
    ax=ax,
    palette='muted',
    errorbar=('ci', 95),       # 95% CI = przedział ufności średniej
)
ax.set_title('Średni rachunek wg dnia tygodnia i płci')
ax.set_xlabel('Dzień tygodnia')
ax.set_ylabel('Średni rachunek (USD)')

plt.tight_layout()
plt.savefig('barplot_dzien_plec.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: barplot_dzien_plec.png")
```

**Sprawdzenie 1.1** ✅
4 grupy słupków (Thur, Fri, Sat, Sun), każda z dwoma kolorami (Male/Female). **Każdy słupek ma wąsy** (95% CI). W sobotę (Sat) słupek Male wyraźnie wyższy niż Female. W piątek **wąsy się zachodzą** (zakresy CI się przecinają w pionie) → różnica nieistotna statystycznie.

> ⚠️ **Ważne:** wąsy w `barplot` to **NIE rozrzut danych ani odchylenie standardowe** — to *niepewność oszacowania średniej* (95% CI, liczone bootstrapem 1000 prób). Mała próbka = szeroki CI nawet przy zwartych danych. Sprawdź `tips.groupby('day').count()` przed wnioskowaniem.

**Pytanie kontrolne:** w którym dniu szerokość wąsów (CI) jest największa? Sprawdź `tips.groupby('day', observed=True).size()` — który dzień ma najmniej obserwacji, i jak wpływa to na precyzję oszacowania średniej?

---

### Zadanie 1.2 — Boxplot (uzupełnij `???`)

Rozkład napiwków per dzień, z podziałem na Lunch/Dinner.

```python
fig, ax = plt.subplots(figsize=(9, 5))

sns.boxplot(
    data=tips,
    x=???,                    # kolumna kategoryczna na oś X (Thur/Fri/Sat/Sun)
    y=???,                    # kolumna numeryczna na oś Y (napiwek)
    hue=???,                  # podział kolorystyczny (Lunch/Dinner)
    ax=ax,
    palette='pastel',
)
ax.set_title('Rozkład napiwków wg dnia i pory dnia')
ax.set_xlabel('Dzień tygodnia')
ax.set_ylabel('Napiwek (USD)')

plt.tight_layout()
plt.savefig('boxplot_napiwki.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: boxplot_napiwki.png")
```

**Sprawdzenie 1.2** ✅
Dla każdego dnia widoczne 1-2 skrzynki (Lunch i/lub Dinner). Skrzynka pokazuje Q1, mediana, Q3. Wąsy = 1.5×IQR. Kropki poza wąsami to *outliery* (wartości odstające). W weekendy (Sat, Sun) **brak Lunch** (0 obserwacji); w czwartek (Thur) **dominuje Lunch** (61 obserwacji), Dinner symboliczny (1 obserwacja — skrzynka degeneruje się do linii).

Boxplot pokazuje to, czego barplot nie pokazuje — *cały rozkład*. Dwóch klientów z napiwkiem 1 USD i 10 USD ma średnią 5.5 USD, ale ich *doświadczenia* są skrajnie różne. Mediana + IQR opisują to dokładniej niż sama średnia.

---

### Zadanie 1.3 — Heatmap korelacji (uzupełnij `???`)

Macierz korelacji wszystkich zmiennych numerycznych z `tips`.

```python
fig, ax = plt.subplots(figsize=(7, 5))

# Korelacja tylko zmiennych numerycznych
corr = tips.select_dtypes('number').corr()

sns.heatmap(
    corr,
    annot=???,                # True — pokaż liczby w komórkach
    fmt='.2f',                # 2 miejsca po przecinku
    cmap=???,                 # 'coolwarm' — paleta dywergencyjna (czerwony=+, niebieski=-)
    center=???,               # 0 — środek skali (biały = 0 korelacja)
    ax=ax,
    square=True,
    cbar_kws={'label': 'współczynnik korelacji'},
)
ax.set_title('Macierz korelacji — dataset tips')

plt.tight_layout()
plt.savefig('heatmap_korelacja.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: heatmap_korelacja.png")
```

**Sprawdzenie 1.3** ✅
Macierz 3×3 (total_bill, tip, size). Liczby w komórkach. **Najsilniejsza korelacja:** `total_bill ↔ tip` ≈ **0.68** (czerwony, dodatnia). `total_bill ↔ size` ≈ **0.60**. `tip ↔ size` ≈ **0.49**. Przekątna zawsze 1.00 (każda zmienna sama ze sobą). Skala kolorów od coolwarm: niebieski (negatywna) → biały (0) → czerwony (pozytywna).

> ⚠️ **Ważne:** użyłeś `'coolwarm'` (paleta dywergencyjna) z `center=0` — to **poprawny wybór** dla korelacji. Gdybyś użył `'rainbow'` lub `'jet'`, znak korelacji byłby ukryty (kolory percepcyjnie nieliniowe).

---

### Zadanie 1.4 — Scatter z hue + style (samodzielnie)

Stwórz `sns.scatterplot` zależności rachunek↔napiwek, w którym:
- **kolor punktu** zależy od `'smoker'` (Yes/No)
- **kształt markera** zależy od `'time'` (Lunch/Dinner)
- punkty są lekko przezroczyste (`alpha`)
- tytuł, etykiety osi z jednostkami (USD)

Zapisz jako `scatter_rachunek_napiwek.png`.

> **Wskazówka:** w seaborn `hue=` koloruje, `style=` kontroluje kształt markera. Oba przyjmują nazwę kolumny.

```python
fig, ax = plt.subplots(figsize=(9, 5))

# Twój kod
# sns.scatterplot(...)

ax.set_title(???)
ax.set_xlabel(???)
ax.set_ylabel(???)

plt.tight_layout()
plt.savefig('scatter_rachunek_napiwek.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
```

**Sprawdzenie 1.4** ✅
244 punkty, 2 kolory (palacze vs niepalacze), 2 kształty markera (Lunch/Dinner — kółko + krzyżyk lub podobne). Widoczna dodatnia zależność rachunek↔napiwek. Legenda automatycznie z 2 sekcjami (smoker + time).

---

### Zadanie dodatkowe (opcjonalne)
Stwórz `sns.violinplot` z `split=True` porównujący rozkład `total_bill` Lunch vs Dinner z podziałem wg płci. Wymóg API: `split=True` wymaga dokładnie 2 kategorii w `hue` (np. `sex`: Male/Female).

---

## Ćwiczenie 2: Subplots, GridSpec, shared axes (20 min)

**Cel:** Opanować dwa style układu wielu paneli — regularną siatkę (`subplots`) i nieregularną (`GridSpec`).

### Zadanie 2.1 — Regularna siatka 2×2

Cztery wykresy z datasetu tips na jednej figurze.

```python
fig, axes = plt.subplots(2, 2, figsize=(13, 9), constrained_layout=True)

# Panel [0, 0] — barplot (gotowy wzór)
sns.barplot(data=tips, x='day', y='total_bill', hue='day', legend=False,
            ax=axes[0, 0], palette='muted', errorbar=('ci', 95))
axes[0, 0].set_title('Średni rachunek wg dnia')
axes[0, 0].set_xlabel('Dzień')
axes[0, 0].set_ylabel('Rachunek (USD)')

# Panel [0, 1] — boxplot (uzupełnij)
sns.boxplot(
    data=tips,
    x=???,                    # 'day'
    y=???,                    # 'tip'
    hue='day', legend=False,
    ax=axes[0, 1],
    palette='pastel',
)
axes[0, 1].set_title('Rozkład napiwków wg dnia')
axes[0, 1].set_xlabel('Dzień')
axes[0, 1].set_ylabel('Napiwek (USD)')

# Panel [1, 0] — scatter (uzupełnij)
sns.scatterplot(
    data=tips,
    x=???,                    # 'total_bill'
    y=???,                    # 'tip'
    hue='smoker',
    alpha=0.7,
    ax=axes[1, 0],
)
axes[1, 0].set_title('Rachunek vs napiwek (palacze vs niepalacze)')
axes[1, 0].set_xlabel('Rachunek (USD)')
axes[1, 0].set_ylabel('Napiwek (USD)')

# Panel [1, 1] — countplot (uzupełnij)
sns.countplot(
    data=tips,
    x=???,                    # 'day'
    hue='time',
    ax=axes[1, 1],
    palette='Set3',
)
axes[1, 1].set_title('Liczba wizyt wg dnia i pory')
axes[1, 1].set_xlabel('Dzień')
axes[1, 1].set_ylabel('Liczba wizyt')

fig.suptitle('Analiza restauracji "Pod Widelcem" — siatka 2×2',
             fontsize=15, fontweight='bold')
plt.savefig('siatka_2x2.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: siatka_2x2.png")
```

**Sprawdzenie 2.1** ✅
4 panele w siatce 2×2: barplot, boxplot, scatter, countplot. Tytuł nadrzędny ponad wszystkimi. Marginesy dopasowane (`constrained_layout=True`). Każdy panel ma tytuł i etykiety osi.

> ⚠️ **Pułapka:** zauważ `hue='day', legend=False` przy boxplot/barplot — to wymóg seaborn 0.13+ przy `palette=` bez prawdziwej zmiennej grupującej. Bez `hue=` dostałbyś `FutureWarning`.

---

### Zadanie 2.2 — GridSpec — nieregularny dashboard

Stwórz Figure z `GridSpec(2, 2)` w której **górny rząd to jeden panel** (pełna szerokość), a **dolny rząd ma 2 panele**.

> **Schemat slice notation `GridSpec`** (jak w NumPy):
> ```
> gs = GridSpec(2, 2)        # 2 wiersze × 2 kolumny
>
> gs[0, :]    →    [X X]     cały pierwszy wiersz (górny panel — pełna szerokość)
>                  [. .]
>
> gs[1, 0]    →    [. .]     drugi wiersz, kolumna 0 (dolny lewy)
>                  [X .]
>
> gs[1, 1]    →    [. .]     drugi wiersz, kolumna 1 (dolny prawy)
>                  [. X]
> ```
> Każdy `fig.add_subplot(gs[...])` tworzy jeden `Axes`.

> **Powtórka z W08 — `pivot_table`:** heatmap pivot wymaga przygotowania macierzy 2-wymiarowej. Przykład:
> ```python
> pivot = tips.pivot_table(values='tip',           # wartości w komórkach
>                          index='day',            # wiersze
>                          columns='time',         # kolumny
>                          aggfunc='mean',         # jaka statystyka
>                          observed=True)          # ważne dla kategorii
> # Wynik: macierz 4×2 (dni × pora), każda komórka = średni napiwek
> ```

```python
fig = plt.figure(figsize=(13, 9))
gs = gridspec.GridSpec(2, 2, figure=fig, hspace=0.35, wspace=0.3)

# Górny — pełna szerokość: barplot suma rachunków per dzień
ax_top = fig.add_subplot(gs[0, :])

tips_sum = tips.groupby('day', observed=True)['total_bill'].sum().reset_index()
ax_top.bar(
    tips_sum['day'].astype(str),
    tips_sum['total_bill'],
    color=sns.color_palette('muted')[:4],
    edgecolor='white', linewidth=1.2,
)
# Dodaj wartości nad słupkami
for i, val in enumerate(tips_sum['total_bill']):
    ax_top.text(i, val + 20, f'${val:.0f}',
                ha='center', va='bottom', fontsize=10, fontweight='bold')

ax_top.set_title('Łączne przychody wg dnia tygodnia (panel główny — pełna szerokość)',
                 fontsize=12, fontweight='bold')
ax_top.set_xlabel('Dzień')
ax_top.set_ylabel('Suma rachunków (USD)')

# Dolny lewy — boxplot Lunch vs Dinner (uzupełnij)
ax_bl = fig.add_subplot(gs[1, 0])
sns.boxplot(
    data=tips,
    x=???,                    # 'time'
    y=???,                    # 'tip'
    hue='time', legend=False,
    ax=ax_bl,
    palette='pastel',
)
ax_bl.set_title('Napiwki: Lunch vs Kolacja')
ax_bl.set_xlabel('Pora dnia')
ax_bl.set_ylabel('Napiwek (USD)')

# Dolny prawy — heatmap pivot (samodzielnie)
# Cel: stwórz pivot_table — wiersze=day, kolumny=time, wartości=mean(tip)
# Zwizualizuj jako heatmap z annot=True, fmt='.2f', cmap='YlOrRd'
ax_br = fig.add_subplot(gs[1, 1])
# Twój kod:
# pivot = tips.pivot_table(...)
# sns.heatmap(...)
ax_br.set_title('Średni napiwek (dzień × pora)')

fig.suptitle('Dashboard GridSpec — górny pełny + 2 dolne',
             fontsize=14, fontweight='bold')
plt.savefig('gridspec_dashboard.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: gridspec_dashboard.png")
```

**Sprawdzenie 2.2** ✅
Górny panel (1×2 komórki = pełna szerokość) z 4 słupkami (Thur, Fri, Sat, Sun) z wartościami nad nimi. **Sobota dominuje** w przychodach. Dolny rząd: 2 osobne panele (boxplot + heatmap pivot). Heatmap pokazuje średni napiwek per (dzień × pora) — żółto-czerwona paleta.

> ⚠️ **Pułapka heatmap pivot:** dla `Sat/Sun × Lunch` komórki będą **puste (NaN)** — restauracja nie serwuje lunchu w weekendy. To NIE błąd kodu — to fakt biznesowy widoczny wprost na wykresie. `sns.heatmap` renderuje NaN jako białe pole bez liczby.

---

### Zadanie 2.3 — Shared axes (samodzielnie)

Stwórz `plt.subplots(2, 2, sharex='col', sharey='row')` z 4 wykresami:
- Kolumna lewa: napiwki (`y='tip'`); kolumna prawa: rachunki (`y='total_bill'`)
- Wiersz górny: stripplot (`sns.stripplot`); wiersz dolny: boxplot
- Wszystkie z `x='day'`

> **Co da `sharex='col'`?** Wszystkie wykresy w tej samej kolumnie dzielą oś X (dzień tygodnia). `sharey='row'` — wiersze dzielą oś Y. To ułatwia bezpośrednie porównanie strip vs box dla tych samych danych.

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 8),
                         sharex='col', sharey='row',
                         constrained_layout=True)

# Twój kod — 4 wykresy
# axes[0, 0] stripplot napiwki
# axes[1, 0] boxplot napiwki
# axes[0, 1] stripplot rachunki
# axes[1, 1] boxplot rachunki

fig.suptitle('Strip + Box plot — porównanie dwóch widoków',
             fontsize=14, fontweight='bold')
plt.savefig('shared_axes.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
```

**Sprawdzenie 2.3** ✅
Siatka 2×2: lewa kolumna napiwki (oś Y do ~10), prawa rachunki (oś Y do ~50). Górny rząd stripplot (każdy punkt = jeden rachunek), dolny boxplot. **Osie X synchroniczne** w kolumnach — Thur/Fri/Sat/Sun w identycznych pozycjach pionowych.

---

## Ćwiczenie 3: Pełny dashboard analityczny (30 min) — praca samodzielna

**Cel:** Zaprojektować i zbudować kompletny dashboard 6-panelowy odpowiadający na pytania właściciela restauracji.

**Scenariusz biznesowy:** Właściciel restauracji „Pod Widelcem" formułuje pytania analityczne:
> *„Jak idzie biznes? Kiedy zarabiamy najwięcej? Kto zostawia największe napiwki? Czy istnieją zależności między zmiennymi?"*

Wymagane: **spójna narracja dashboardu** — sześć paneli ma odpowiadać na powyższe pytania, nie być przypadkowym zestawieniem wykresów. Reguła: dashboard = jedna figura, wiele wykresów, jedna historia.

---

### Zadanie 3.1 — Projekt dashboardu (5 min)

Przed napisaniem kodu określ:

1. **Pytanie główne** (KPI): w którym dniu restauracja zarabia najwięcej? → 1 panel duży (górny, pełna szerokość lub 2/3)
2. **3-4 panele pomocnicze**: rozkład napiwków, korelacja zmiennych, scatter rachunek↔napiwek, proporcja dni (pie/countplot)
3. **1 panel sumaryczny** (dolny, pełna szerokość): rozkład rachunków per dzień (violinplot)

Określenie układu paneli przed implementacją skraca czas iteracji nad rozmieszczeniem.

---

### Zadanie 3.2 — Implementacja dashboardu (20 min)

```python
# Restaurant Analytics Dashboard "Pod Widelcem"
fig = plt.figure(figsize=(16, 11))
fig.patch.set_facecolor('#f8f9fa')   # tło figury — jasnoszare

gs = gridspec.GridSpec(3, 3, figure=fig, hspace=0.45, wspace=0.35)

# === PANEL 1 (KPI główny): łączne przychody per dzień (gs[0, :2]) ===
ax1 = fig.add_subplot(gs[0, :2])
# Twój kod — barplot z etykietami wartości nad słupkami

# === PANEL 2: udział wizyt per dzień (gs[0, 2]) ===
ax2 = fig.add_subplot(gs[0, 2])
# Twój kod — pie chart lub countplot

# === PANEL 3: rozkład napiwków (gs[1, 0]) ===
ax3 = fig.add_subplot(gs[1, 0])
# Twój kod — boxplot napiwki per dzień

# === PANEL 4: heatmap korelacji (gs[1, 1]) ===
ax4 = fig.add_subplot(gs[1, 1])
# Twój kod — sns.heatmap(corr, annot=True, fmt='.2f', cmap='coolwarm', center=0)

# === PANEL 5: scatter (gs[1, 2]) ===
ax5 = fig.add_subplot(gs[1, 2])
# Twój kod — sns.scatterplot rachunek vs napiwek z hue='smoker'

# === PANEL 6 (sumaryczny): rozkład rachunków (gs[2, :]) ===
ax6 = fig.add_subplot(gs[2, :])
# Twój kod — sns.violinplot rachunki per dzień z hue='time', split=True

fig.suptitle('Restaurant Analytics Dashboard — "Pod Widelcem" (244 rachunki)',
             fontsize=15, fontweight='bold', y=1.01)

plt.savefig('dashboard_pod_widelcem.png',
            dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: dashboard_pod_widelcem.png")
```

**Wymagania (must-have):**
- [ ] **Panel 1 dominuje** wizualnie (większy niż reszta)
- [ ] **Każdy panel ma tytuł** (`ax.set_title`)
- [ ] **Każdy panel ma etykiety osi** (X i Y)
- [ ] **Spójna paleta** w ramach całego dashboardu (np. `'muted'` we wszystkich barplotach)
- [ ] **Tytuł nadrzędny** (`fig.suptitle`)
- [ ] **Eksport do PNG** z `dpi=150` i `bbox_inches='tight'`

**Bonus (jeśli zdążysz):**
- [ ] Etykiety wartości nad słupkami w panelu 1 (`ax.text(..., f'${val:.0f}')`)
- [ ] W panelu 4 maska górnego trójkąta korelacji (macierz symetryczna): `mask = np.triu(np.ones_like(corr, dtype=bool))`

---

### Zadanie 3.3 — Wnioski biznesowe (5 min, w komórce Markdown)

W notebooku dodaj komórkę Markdown i odpowiedz na pytania właściciela (3-5 zdań):

> 1. Który dzień jest najbardziej dochodowy dla restauracji?
> 2. Czy istnieje korelacja między rachunkiem a napiwkiem? (jeśli tak — jak silna?)
> 3. Czy palacze i niepalacze zostawiają różne napiwki?
> 4. Jakie ZALECENIE dasz właścicielowi na podstawie dashboardu?

**Sprawdzenie 3** ✅
Dashboard z **6 panelami** w nieregularnej siatce 3×3. Tytuł nadrzędny widoczny. Każdy panel ma tytuł. Komórka markdown z wnioskami biznesowymi. Plik PNG istnieje, > 100 KB.

---

## Ćwiczenie 4: Style, eksport, adnotacja, commit (15 min)

**Cel:** Profesjonalne wykończenie wykresu (style, palety, adnotacja) + commit do GitHub.

### Zadanie 4.1 — Porównanie stylów seaborn (5 min)

```python
styles = ['whitegrid', 'darkgrid', 'white', 'ticks']
fig, axes = plt.subplots(1, 4, figsize=(16, 3), constrained_layout=True)

for ax, style in zip(axes, styles):
    with sns.axes_style(style):     # context manager — tymczasowo zmień styl
        sns.barplot(data=tips, x='day', y='total_bill', hue='day', legend=False,
                    ax=ax, palette='muted')
        ax.set_title(f"style='{style}'", fontsize=10)
        ax.set_xlabel('')
        ax.set_ylabel('Rachunek' if ax is axes[0] else '')

fig.suptitle('Porównanie stylów seaborn', fontsize=13)
plt.savefig('porownanie_stylow.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
```

**Pytanie kontrolne:** który styl jest odpowiedni do prezentacji zarządczej (slajdy), a który do publikacji naukowej (papier biały)? Odpowiedź w komentarzu w komórce.

---

### Zadanie 4.2 — Adnotacja na wykresie (5 min)

Dodaj strzałkę wskazującą na **dzień z najwyższymi przychodami** (powtórka `ax.annotate` z W09).

```python
fig, ax = plt.subplots(figsize=(9, 5))

tips_sum = tips.groupby('day', observed=True)['total_bill'].sum().reset_index()
sns.barplot(data=tips_sum, x='day', y='total_bill', hue='day', legend=False,
            ax=ax, palette='muted')

# Znajdź szczyt
max_idx = tips_sum['total_bill'].idxmax()
max_day = tips_sum.loc[max_idx, 'day']
max_val = tips_sum.loc[max_idx, 'total_bill']

# Adnotacja ze strzałką
ax.annotate(
    f'Szczyt: ${max_val:.0f} ({max_day})',
    xy=(???, ???),                # punkt na który wskazuje strzałka — (max_idx, max_val)
    xytext=(???, ???),            # gdzie tekst — (max_idx + 0.5, max_val + 200)
    arrowprops=dict(arrowstyle='->', color='red', lw=1.8),
    fontsize=11, color='red', fontweight='bold',
)

ax.set_title('Łączne przychody wg dnia — adnotacja szczytu')
ax.set_xlabel('Dzień tygodnia')
ax.set_ylabel('Suma rachunków (USD)')
sns.despine()                     # usuwa górną i prawą krawędź osi (minimalistyczny styl)

plt.tight_layout()
plt.savefig('szczyt_przychodow.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()
print("Zapisano: szczyt_przychodow.png")
```

**Sprawdzenie 4.2** ✅
Czerwona strzałka wskazuje na najwyższy słupek (sobota), z tekstem `Szczyt: $1778 (Sat)` (lub podobne). `sns.despine()` usunął górną i prawą krawędź — minimalistyczny styl.

---

### Zadanie 4.3 — Commit do repozytorium (5 min)

```bash
# W terminalu VS Code (Ctrl+`)
cd W10                            # jeśli jeszcze nie jesteś w folderze tygodnia
git status                        # sprawdź co masz do dodania
git add lab10_seaborn_dashboard.ipynb
git add *.png                     # dodaj wszystkie PNG-i z dzisiejszego labu
git status                        # sprawdź co jest zaplanowane do commita
git commit -m "L10: Dashboard seaborn — barplot, boxplot, heatmap, GridSpec"
git push
```

Sprawdź na GitHub czy commit jest widoczny. Pokaż prowadzącemu link do swojego commita.

**Sprawdzenie 4.3** ✅
Folder `W10/` na GitHub zawiera `lab10_seaborn_dashboard.ipynb` + minimum 4 PNG-i (`barplot_dzien_plec.png`, `boxplot_napiwki.png`, `heatmap_korelacja.png`, `dashboard_pod_widelcem.png`). Komunikat commita zaczyna się od `L10:`.

---

## Podsumowanie — referencja składni

```python
import seaborn as sns                                       # alias konwencyjny
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

sns.set_theme(style='whitegrid', palette='muted')           # raz, na początku

# === SEABORN — typy wykresów (axes-level: przyjmują ax=) ===
sns.barplot(data=df, x='kat', y='num', hue='grupa', ax=ax, errorbar=('ci', 95))
sns.boxplot(data=df, x='kat', y='num', hue='kat', legend=False, ax=ax)
sns.violinplot(data=df, x='kat', y='num', hue='kat2', split=True, ax=ax)
sns.heatmap(corr, annot=True, fmt='.2f', cmap='coolwarm', center=0, ax=ax)
sns.scatterplot(data=df, x='n1', y='n2', hue='kat', style='kat2', ax=ax)
sns.countplot(data=df, x='kat', hue='kat2', ax=ax)
sns.stripplot(data=df, x='kat', y='num', jitter=True, ax=ax)

# === SEABORN — figure-level (NIE przyjmują ax=, własna figura) ===
g = sns.pairplot(df[cols], hue='kat', diag_kind='kde')

# === SUBPLOTS i GRIDSPEC ===
fig, axes = plt.subplots(2, 2, figsize=(13, 9), constrained_layout=True)
gs = gridspec.GridSpec(3, 3, figure=fig, hspace=0.4, wspace=0.3)
ax = fig.add_subplot(gs[0, :])           # cały wiersz 0

# === EKSPORT ===
plt.savefig('plik.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
plt.close()                              # ZAWSZE na końcu — zwalnia pamięć

# === ADNOTACJE ===
ax.annotate('tekst', xy=(x, y), xytext=(x+1, y+1),
            arrowprops=dict(arrowstyle='->', color='red'))
sns.despine()                            # minimalistyczny styl (usuwa krawędzie)
```

### Wymagania do zaliczenia laboratorium W10
- [ ] Folder `W10/` w repozytorium z notebookiem `lab10_seaborn_dashboard.ipynb`
- [ ] Ćwiczenie 1: 4 PNG-i (`barplot_dzien_plec.png`, `boxplot_napiwki.png`, `heatmap_korelacja.png`, `scatter_rachunek_napiwek.png`)
- [ ] Ćwiczenie 2: `siatka_2x2.png` + `gridspec_dashboard.png` + `shared_axes.png`
- [ ] Ćwiczenie 3: **`dashboard_pod_widelcem.png`** — **minimum 4 panele** wystarcza do zaliczenia, 6 paneli na max ocenę. Plus komórka Markdown z wnioskami biznesowymi (3-5 zdań, odpowiedź na 4 pytania właściciela)
- [ ] Ćwiczenie 4: `porownanie_stylow.png` + `szczyt_przychodow.png`
- [ ] Commit na GitHub z komunikatem zaczynającym się od `L10:`

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `FutureWarning: Passing palette without assigning hue` | Seaborn 0.13+ wymaga `hue=` przy `palette=`. Workaround: `hue=x_kolumna, legend=False` jeśli nie potrzebujesz legendy |
| `FutureWarning: groupby... observed=False` | Pandas: dodaj `observed=True` do `groupby()` na kategoriach: `tips.groupby('day', observed=True)` |
| `TypeError: pairplot() got unexpected keyword 'ax'` | `pairplot` to *figure-level* — NIE przyjmuje `ax=`. Tworzy własną figurę. Wstaw poza dashboardem |
| `TypeError: violinplot... split=True` | `split=True` wymaga **dokładnie 2 kategorii** w `hue`. Sprawdź `tips['hue_kolumna'].nunique()` — musi być 2 |
| Wykres się nie wyświetla w VS Code | Dodaj `%matplotlib inline` jako pierwszą komórkę. Sprawdź czy masz Jupyter extension |
| Etykiety osi się nakładają / tytuł obcięty | Użyj `constrained_layout=True` w `subplots()` lub dodaj `bbox_inches='tight'` w `savefig` |
| Heatmap — za dużo miejsc po przecinku | `fmt='.2f'` lub `fmt='.1f'` w `sns.heatmap(..., fmt='.2f')` |
| Kolory zbyt jaskrawe / nieprofesjonalne | Zmień paletę: `palette='muted'` (stonowana) lub `'colorblind'` (dostępność) zamiast `'bright'` |
| `ModuleNotFoundError: No module named 'seaborn'` | `uv pip install seaborn` w aktywowanym `.venv` |
| `tips = sns.load_dataset('tips')` — timeout | Brak internetu. Pobierz `tips.csv` z https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv ręcznie i `tips = pd.read_csv('tips.csv')` |
| GridSpec — panele na siebie zachodzą | Zwiększ `hspace=` (odstęp pionowy) i `wspace=` (poziomy) w `GridSpec`: `gridspec.GridSpec(3, 3, hspace=0.5, wspace=0.4)` |
| Dashboard wychodzi za mały — wykresy nieczytelne | Zwiększ `figsize`: dla 6 paneli minimum `(16, 11)` |
| `np.triu(np.ones_like(corr))` — nie wiem co to | Zwraca macierz boolean górnego trójkąta. Użyte jako `mask=` w `sns.heatmap` ukrywa górny trójkąt (macierz korelacji jest symetryczna) |
| PNG za duży (>5 MB) | Zmniejsz `dpi=100` (zamiast 150) lub `figsize=(12, 7)` (zamiast 16, 11) |
| Legenda zasłania dane | `ax.legend(bbox_to_anchor=(1.05, 1), loc='upper left')` + `bbox_inches='tight'` w savefig |
| `_, axes = plt.subplots(2, 2)` — co to `_`? | Konwencja: `_` ignoruje zmienną. Tu: nie potrzebujemy referencji do `fig`, używamy tylko `axes` |

---

## Materiał rozszerzający

Tematy poza zakresem podstawowym laboratorium — do realizacji po wykonaniu ćwiczeń 1-4 lub jako praca własna:

1. **`PairGrid` — pełna kontrola macierzy par.** `sns.pairplot` jest gotową funkcją, `sns.PairGrid` pozwala mapować różne funkcje na różne pozycje (przekątna, górny trójkąt, dolny trójkąt):
   ```python
   g = sns.PairGrid(tips, hue='sex', vars=['total_bill', 'tip', 'size'])
   g.map_diag(sns.histplot, kde=True)
   g.map_upper(sns.scatterplot, alpha=0.6)
   g.map_lower(sns.kdeplot, fill=True)
   ```
2. **`JointGrid` / `jointplot`** — scatter wraz z marginalnymi rozkładami na jednej figurze:
   ```python
   g = sns.jointplot(data=tips, x='total_bill', y='tip', hue='smoker',
                     kind='scatter', height=7)
   ```
   Stosowane do prezentacji jednej pary zmiennych z pełnym kontekstem rozkładu.

3. **`FacetGrid` — wiele paneli wg kategorii:**
   ```python
   g = sns.FacetGrid(tips, col='time', row='smoker', height=4)
   g.map(sns.scatterplot, 'total_bill', 'tip')
   g.add_legend()
   ```
   Tworzy siatkę 2×2 (lunch/dinner × yes/no) z wykresem rozrzutu rachunek↔napiwek w każdym panelu.

4. **Eksport interaktywny do HTML** — `plotly.express` jako alternatywa dla seaborn:
   ```python
   import plotly.express as px
   fig = px.scatter(tips, x='total_bill', y='tip', color='smoker',
                    size='size', hover_data=['day', 'time'])
   fig.write_html('scatter_interaktywny.html')
   ```
   Wynikiem jest plik HTML z interaktywnym wykresem (hover, zoom, pan). Pełniejsze omówienie w W13.

5. **Dashboard z własnymi danymi** (praca własna, opcjonalna):
   Wybrać publiczny dataset CSV (Kaggle, dane.gov.pl, GUS), wczytać pandasem, sformułować jedno pytanie biznesowe (postaci: *„czy X zależy od Y w segmencie Z?"*) i zbudować dashboard 4-panelowy odpowiadający na to pytanie. Zadanie wykracza poza zakres czasowy laboratorium (90 min).

