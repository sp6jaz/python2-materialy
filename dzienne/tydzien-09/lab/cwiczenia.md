# L09 — Ćwiczenia laboratoryjne

## Temat: Matplotlib — podstawy wizualizacji danych

**Programowanie w Pythonie II** | Laboratorium 9
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne, dozwolony pair programming
**Dataset:** `tips` (wbudowany w seaborn) + dane biznesowe TechShop (z W08)

---

## Po tym laboratorium potrafisz:

1. **Tworzyć** podstawowe typy wykresów — liniowy, słupkowy (`bar`/`barh`), scatter, histogram — w stylu obiektowym `fig, ax = plt.subplots()` (Bloom 3)
2. **Dostosowywać** wygląd wykresu — tytuły, etykiety osi, legendy, kolory, siatkę i style (Bloom 3)
3. **Konstruować** dashboard 2×2 za pomocą `plt.subplots(2, 2)` z indeksowaniem `axes[i, j]` (Bloom 3)
4. **Stosować** Pandas `.plot()` w połączeniu z `groupby` jako szybki pipeline od danych do wizualizacji (Bloom 3)
5. **Analizować** dane wizualnie i formułować wnioski biznesowe na ich podstawie (Bloom 4)

Na wykładzie poznałeś architekturę Figure/Axes, 4 podstawowe typy wykresów, formatowanie i Pandas `.plot()`. Dziś **utrwalasz to praktycznie** na danych restauracyjnych (`tips`) i biznesowych (TechShop).

---

## Start

```powershell
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
uv pip install seaborn        # jeśli jeszcze nie masz — to ostatni nowy pakiet w semestrze
code .
```

W VS Code utwórz folder `W09/` w katalogu projektu, wewnątrz utwórz notebook `lab09_matplotlib.ipynb`.

**Commit na końcu zajęć:** `git commit -m "L09: matplotlib — wykresy, subplots, dashboard"` + `git push`. Wszystkie zapisane PNG-i + notebook trafiają do `W09/` i jadą razem do GitHuba.

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Matplotlib — Pyplot tutorial | https://matplotlib.org/stable/tutorials/pyplot.html |
| Matplotlib — `plot()` | https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html |
| Matplotlib — `bar()` / `barh()` | https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.bar.html |
| Matplotlib — `scatter()` | https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.scatter.html |
| Matplotlib — `hist()` | https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.hist.html |
| Matplotlib — `subplots()` | https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html |
| Matplotlib — Galeria przykładów | https://matplotlib.org/stable/gallery/index.html |
| Matplotlib — Lista kolorów | https://matplotlib.org/stable/gallery/color/named_colors.html |
| Matplotlib — Style sheets | https://matplotlib.org/stable/gallery/style_sheets/style_sheets_reference.html |

### Kluczowe pojęcia

- **Figure** — cały "obraz" (okno wykresu). Tworzy się przez `plt.figure()` lub `plt.subplots()`.
- **Axes** — pojedynczy wykres na figurze. Figure może mieć wiele Axes (subplots).
- **`plt.plot()` vs `ax.plot()`** — `plt.plot()` rysuje na aktualnym Axes. `ax.plot()` rysuje na konkretnym Axes. **Preferuj `ax.plot()`** (styl obiektowy) — daje większą kontrolę i działa z subplots.
- **`tight_layout()`** — automatycznie dopasowuje marginesy żeby etykiety się nie nakładały.

### Ściąga matplotlib API — miej pod ręką

| Chcę | Kod |
|------|-----|
| Pierwszy wykres | `fig, ax = plt.subplots(figsize=(W, H))` |
| Trend w czasie | `ax.plot(x, y, color='steelblue', marker='o')` |
| Porównanie kategorii (krótkie nazwy) | `ax.bar(kategorie, wartosci)` |
| Porównanie kategorii (długie nazwy) | `ax.barh(kategorie, wartosci)` |
| Korelacja dwóch zmiennych | `ax.scatter(x, y, alpha=0.6, s=50)` |
| Rozkład jednej zmiennej | `ax.hist(dane, bins=20)` |
| Tytuł i etykiety | `ax.set_title(...)`, `ax.set_xlabel(...)`, `ax.set_ylabel(...)` |
| Legenda | `ax.plot(..., label='X')` + `ax.legend()` |
| Siatka i zakres osi | `ax.grid(axis='y', alpha=0.4)`, `ax.set_ylim(0, 100)` |
| Linia pionowa (np. średnia) | `ax.axvline(srednia, color='red', linestyle='--')` |
| Dashboard 2×2 | `fig, axes = plt.subplots(2, 2, figsize=(13, 9))` → `axes[i, j]` |
| Tytuł całej Figure | `plt.suptitle('...', y=1.02)` |
| Marginesy + zapis + zamknięcie | `plt.tight_layout()` → `plt.savefig('plik.png', dpi=100)` → `plt.show()` → `plt.close()` |
| Z DataFrame (szybko) | `df.plot(kind='line')` lub `df.plot(kind='bar')` |
| Globalny styl | `plt.style.use('seaborn-v0_8-whitegrid')` |

---

## Dane startowe — wklej jako pierwszą komórkę notebooka

```python
%matplotlib inline
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns

# Dataset tips — restauracja, 244 rachunki
tips = sns.load_dataset('tips')

# Dane sprzedaży TechShop (z W08)
miesiace = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze']
sprzedaz_2024 = [45230, 38920, 52100, 48700, 55200, 62300]
sprzedaz_2023 = [41000, 35000, 48000, 44000, 50000, 58000]

kategorie = ['Komputery', 'Akcesoria', 'Audio', 'Storage']
sprzedaz_kat = [15899.94, 2939.83, 1199.97, 349.93]

print(f"Tips dataset: {tips.shape}")
print(tips.head(3))
```

### Opis datasetu `tips`

| Kolumna | Typ | Opis |
|---------|-----|------|
| `total_bill` | float | Wartość rachunku w \$ (od 3.07 do 50.81) |
| `tip` | float | Napiwek w \$ (od 1.00 do 10.00) |
| `sex` | category | Płeć płacącego (`'Male'` / `'Female'`) |
| `smoker` | category | Czy palacz (`'Yes'` / `'No'`) |
| `day` | category | Dzień tygodnia (`'Thur'`, `'Fri'`, `'Sat'`, `'Sun'`) |
| `time` | category | Pora dnia (`'Lunch'` / `'Dinner'`) |
| `size` | int | Liczba gości przy stole |

**244 wiersze, 7 kolumn.** Klasyczny dataset wprowadzony przez Bryanta i Smitha w *Practical Data Analysis* (1995). Mieszanka zmiennych numerycznych i kategorycznych — idealna do nauki wszystkich typów wykresów.

---

## Ćwiczenie 1: Podstawowe typy wykresów — linia, słupki, scatter (20 min)

**Cel:** Stworzyć trzy podstawowe typy wykresów i zapisać jako PNG.

### Zadanie 1.1 — Wykres liniowy: trend sprzedaży

Narysuj wykres liniowy trendu sprzedaży miesięcznej za 2024 rok.

```python
fig, ax = plt.subplots(figsize=(10, 5))

ax.plot(miesiace, sprzedaz_2024,
        color=???,           # 'steelblue'
        linewidth=???,       # 2
        marker=???,          # 'o'
        markersize=8)

ax.set_title(???)            # 'Trend sprzedaży Q1-Q2 2024'
ax.set_xlabel(???)           # 'Miesiąc'
ax.set_ylabel(???)           # 'Sprzedaż [PLN]'
ax.set_ylim(0, 70000)
ax.grid(axis='y', alpha=0.4)

plt.tight_layout()
plt.savefig('trend_2024.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: trend_2024.png")
```

**Sprawdzenie 1.1** ✅
Wykres liniowy z 6 punktami (kółkami) połączonymi niebieską linią. Oś Y od 0 do 70 000. Tytuł i etykiety osi widoczne. Wzrost widoczny szczególnie od kwietnia do czerwca.

---

### Zadanie 1.2 — Wykres słupkowy: sprzedaż per kategoria

Narysuj wykres słupkowy (pionowy) sprzedaży per kategoria produktów.

```python
fig, ax = plt.subplots(figsize=(9, 5))

slupki = ax.bar(???,          # kategorie
                ???,          # sprzedaz_kat
                color='steelblue',
                edgecolor='navy',
                linewidth=0.8)

# Dodaj wartości nad słupkami
for slupek, wartosc in zip(slupki, sprzedaz_kat):
    ax.text(
        slupek.get_x() + slupek.get_width() / 2,    # środek słupka w osi X
        slupek.get_height() + ???,                  # ile JEDNOSTEK osi Y nad słupkiem? (~0.7% zakresu)
        f'{wartosc:,.0f} zł',                       # format: 11,899 zł
        ha=???, va='bottom', fontsize=9             # wyrównanie poziome — środek
    )

ax.set_title(???)             # 'Sprzedaż per kategoria — TechShop 2024'
ax.set_xlabel('Kategoria')
ax.set_ylabel('Sprzedaż [PLN]')
ax.set_ylim(0, 18000)

plt.tight_layout()
plt.savefig('sprzedaz_kategorie.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: sprzedaz_kategorie.png")
```

**Sprawdzenie 1.2** ✅
Cztery słupki (Komputery dominuje: ~15 900 zł). Nad każdym słupkiem wartość PLN. Komputery wyraźnie wyróżniają się wysokością — zdecydowany lider.

---

### Zadanie 1.3 — Scatter: rachunek vs napiwek (tips dataset)

Narysuj wykres punktowy zależności napiwku od wartości rachunku.

```python
fig, ax = plt.subplots(figsize=(8, 6))

ax.scatter(
    ???,              # tips['total_bill'] — oś X
    ???,              # tips['tip'] — oś Y
    alpha=???,        # 0.6 — przezroczystość
    color='steelblue',
    s=50,             # rozmiar punktu
    edgecolors='gray',
    linewidth=0.5
)

ax.set_title('Korelacja: wartość rachunku vs napiwek')
ax.set_xlabel('Wartość rachunku [$]')
ax.set_ylabel(???)    # 'Napiwek [$]'

plt.tight_layout()
plt.savefig('scatter_tips.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: scatter_tips.png")
```

**Sprawdzenie 1.3** ✅
244 punkty rozmieszczone na wykresie. Widoczna dodatnia korelacja — wyższy rachunek → wyższy napiwek. Zagęszczenie punktów w rejonie 10-20 $ rachunku i 2-4 $ napiwku.

---

### Wyzwanie dodatkowe (jeśli skończyłeś wcześniej)
Dodaj do scatter z 1.3 kolorowanie według liczby gości (`tips['size']`) używając parametru `c=tips['size'], cmap='Blues'`. **Uwaga:** żeby `colorbar` działał, musisz **przypisać** `ax.scatter(...)` do zmiennej:
```python
scatter = ax.scatter(...)              # zapisujemy referencję
plt.colorbar(scatter, ax=ax).set_label('Liczba gości')
```

---

## Ćwiczenie 2: Dostosowywanie — etykiety, kolory, legendy (20 min)

**Cel:** Opanować formatowanie wykresów: wiele serii, legenda, styl, kolory.

### Zadanie 2.1 — Porównanie dwóch lat (legenda)

Narysuj wykres liniowy porównujący sprzedaż 2023 i 2024 na jednym wykresie z legendą.

```python
fig, ax = plt.subplots(figsize=(10, 5))

# Seria 2023 — linia przerywana
ax.plot(miesiace, sprzedaz_2023,
        label=???,            # '2023'
        color='lightsteelblue',
        linewidth=2,
        marker='s',           # kwadraty
        linestyle='--')       # przerywana

# Seria 2024 — linia ciągła
ax.plot(miesiace, sprzedaz_2024,
        label=???,            # '2024'
        color='steelblue',
        linewidth=2,
        marker='o')

ax.set_title('Sprzedaż Q1-Q2: porównanie rok do roku')
ax.set_xlabel('Miesiąc')
ax.set_ylabel('Sprzedaż [PLN]')
ax.legend(title=???, loc='upper left')  # title='Rok'
ax.grid(axis='y', alpha=???)            # 0.4

plt.tight_layout()
plt.savefig('porownanie_lat.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: porownanie_lat.png")
```

**Sprawdzenie 2.1** ✅
Dwie linie: ciągła (2024) i przerywana (2023). Legenda z tytułem "Rok" w lewym górnym rogu. Linie 2024 wyraźnie wyżej niż 2023 — wzrost rok do roku widoczny w każdym miesiącu.

---

### Zadanie 2.2 — Słupki poziome z kolorami (barh)

Narysuj słupki poziome sprzedaży per kategoria. Każdy słupek innym kolorem.

```python
kolory_kat = ['#2196F3', '#66BB6A', '#FFA726', '#AB47BC']

fig, ax = plt.subplots(figsize=(9, 5))

# barh = horizontal bar
ax.barh(???,              # kategorie
        ???,              # sprzedaz_kat
        color=kolory_kat)

# Etykiety wartości przy słupkach
for i, (kat, wartosc) in enumerate(zip(kategorie, sprzedaz_kat)):
    ax.text(wartosc + 100, i,
            f'{wartosc:,.0f} zł',
            va='center', fontsize=9)

ax.set_title('Sprzedaż per kategoria — układ poziomy')
ax.set_xlabel('Sprzedaż [PLN]')
ax.set_xlim(0, 18000)

plt.tight_layout()
plt.savefig('kategorie_poziome.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: kategorie_poziome.png")
```

**Sprawdzenie 2.2** ✅
Cztery poziome słupki z różnymi kolorami. Każdy słupek ma wartość PLN po prawej stronie. Komputery zdecydowanie najdłuższy — niebieski słupek dominuje. Format poziomy — etykiety kategorii czytelne bez obrotu.

---

### Zadanie 2.3 — Styl wykresów

Zastosuj styl `seaborn-v0_8-whitegrid` i narysuj wykres liniowy trendu.

```python
# Zastosuj styl
plt.style.use('seaborn-v0_8-whitegrid')

fig, ax = plt.subplots(figsize=(10, 5))

ax.plot(miesiace, sprzedaz_2024,
        color='#1565C0',
        linewidth=2.5,
        marker='o',
        markersize=10,
        label='Sprzedaż 2024')

ax.fill_between(miesiace, sprzedaz_2024,
                alpha=???,                # przezroczystość 0-1; subtelny efekt = 0.1-0.2
                color=???)                # ten sam kolor co linia powyżej dla spójności

ax.set_title('Trend sprzedaży 2024 — styl seaborn', fontsize=13)
ax.set_xlabel('Miesiąc')
ax.set_ylabel('Sprzedaż [PLN]')
ax.legend()

plt.tight_layout()
plt.savefig('trend_styl.png', dpi=100)
plt.show()
plt.close()

# Przywróć domyślny styl
plt.style.use('default')
print("Zapisano: trend_styl.png")
```

**Sprawdzenie 2.3** ✅
Wykres z białym tłem i szarą siatką (styl seaborn). Pod linią trendu widoczne jasne niebieskie wypełnienie (`fill_between`). Wygląda profesjonalnie — gotowy do prezentacji.

---

### Wyzwanie dodatkowe
Pobaw się parametrami `plt.style.use()`. Dostępne style: `'ggplot'`, `'bmh'`, `'dark_background'`, `'fivethirtyeight'`. Narysuj ten sam wykres w każdym stylu i porównaj.

---

## Ćwiczenie 3: Pełna wizualizacja z datasetu tips (30 min) — samodzielne

**Cel:** Przeprowadzić samodzielnie analizę wizualną datasetu tips i odpowiedzieć na pytania biznesowe.

To jest ćwiczenie **samodzielne** — spróbuj przez 10 minut sam zanim poprosisz o pomoc.

Restauracja "Pod Widelcem" chce wiedzieć:

---

### Zadanie 3.1 — Kiedy klienci zostawiają najwyższe napiwki?

Oblicz **średni napiwek per dzień tygodnia** i narysuj wykres słupkowy.

```python
# Twój kod:
sredni_napiwek = ???  # groupby('day')['tip'].mean().round(2)

# Wykres:
ax = sredni_napiwek.plot(
    kind=???,          # 'bar'
    figsize=(8, 5),
    color='steelblue',
    title=???,         # 'Średni napiwek per dzień tygodnia'
    ylabel='Napiwek [$]',
    rot=0
)
ax.grid(axis='y', alpha=0.4)
plt.tight_layout()
plt.savefig(???)       # 'napiwek_dzien.png'
plt.show()
plt.close()
```

**Sprawdzenie 3.1** ✅
Wyniki (przybliżone):
- Sun: ~3.26 $ (najwyższy)
- Sat: ~2.99 $
- Thur: ~2.77 $
- Fri: ~2.73 $

Obserwacja: **Niedziela** przynosi najwyższe napiwki — klienci są hojniejsi w weekend.

---

### Zadanie 3.2 — Czy palacze dają wyższe napiwki?

Narysuj scatter: `total_bill` vs `tip`, z kolorowaniem według kolumny `smoker` (Tak/Nie).

```python
fig, ax = plt.subplots(figsize=(9, 6))

# Podziel na dwie grupy i narysuj osobno
palacze = tips[tips['smoker'] == 'Yes']
niepalacze = tips[tips['smoker'] == 'No']

ax.scatter(???,   # palacze['total_bill']
           ???,   # palacze['tip']
           alpha=0.6, color='tomato', label='Palacz', s=50)

ax.scatter(???,   # niepalacze['total_bill']
           ???,   # niepalacze['tip']
           alpha=0.6, color='steelblue', label='Niepalacz', s=50)

ax.set_title('Rachunek vs napiwek: palacze vs niepalacze')
ax.set_xlabel('Wartość rachunku [$]')
ax.set_ylabel('Napiwek [$]')
ax.legend(title='Palacz')

plt.tight_layout()
plt.savefig('scatter_palacze.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: scatter_palacze.png")
```

**Sprawdzenie 3.2** ✅
Dwa kolory punktów: czerwony = palacze, niebieski = niepalacze. Punkty mieszają się — nie widać wyraźnej różnicy. Obserwacja: palenie nie ma prostego związku z wysokością napiwku.

---

### Zadanie 3.3 — Rozkład napiwków (histogram + obserwacja)

Narysuj histogram kolumny `tip`. Dobierz liczbę binów tak, żeby wykres był informatywny (spróbuj bins=10, 20, 30 i wybierz najlepszy).

```python
fig, ax = plt.subplots(figsize=(8, 5))

ax.hist(???,           # tips['tip']
        bins=???,      # spróbuj 10, 20, 30 — który najczytelniej?
        color='salmon',
        edgecolor='white',
        linewidth=0.8)

ax.set_title(???)
ax.set_xlabel('Napiwek [$]')
ax.set_ylabel('Liczba obserwacji')

# Dodaj pionową linię — średnia
ax.axvline(tips['tip'].mean(),
           color='darkred',
           linewidth=2,
           linestyle='--',
           label=f"Średnia: {tips['tip'].mean():.2f} $")
ax.legend()

plt.tight_layout()
plt.savefig('histogram_napiwki.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: histogram_napiwki.png")
```

**Sprawdzenie 3.3** ✅
Histogram z wyraźną skośnością prawostronną — większość napiwków 1.5-3 $, ale są outlierzy do 10 $. Czerwona przerywana linia = średnia (~3.00 $). `axvline` — linia pionowa na konkretnej wartości X — przydatne do zaznaczenia średniej/mediany/progu.

---

### Zadanie 3.4 — Słupkowy: liczba zamówień per pora dnia

Oblicz liczbę zamówień per `time` (Lunch/Dinner) i per `sex`. Narysuj wykres słupkowy grupowany.

> 💡 **Przypomnienie z W08:** `groupby(['kol1', 'kol2'])` zwraca Series z **wielopoziomowym indeksem** — wartości pogrupowane wg dwóch kolumn naraz. Metoda `.unstack()` „rozłoży" drugi poziom indeksu na **kolumny** — w wyniku dostajesz prostokątną tabelę. Dla `groupby(['time', 'sex'])` po `unstack()` otrzymasz: wiersze = pora dnia, kolumny = płeć. Idealne dla `kind='bar'` — Pandas rysuje **grupowany słupkowy** (każda kolumna = osobny kolor obok siebie).

```python
# Zlicz zamówienia per pora dnia i płeć
count_df = tips.groupby([???, ???], observed=True)['total_bill'].count().unstack()
print(count_df)

# Wykres słupkowy grupowany — pora dnia w wierszach, płeć w kolumnach
ax = count_df.plot(
    kind=???,                              # 'bar'
    figsize=(8, 5),
    color=['steelblue', 'salmon'],
    title='Liczba zamówień: pora dnia × płeć',
    ylabel='Liczba zamówień',
    rot=0
)
ax.legend(title='Płeć')
ax.grid(axis='y', alpha=0.4)

plt.tight_layout()
plt.savefig('zamowienia_pora.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: zamowienia_pora.png")
```

**Sprawdzenie 3.4** ✅
Dwa grupy słupków (Lunch/Dinner), każda podzielona na Male/Female. **Dinner zdecydowanie dominuje** pod względem liczby zamówień (~176 vs ~68 — niemal 3× więcej). W **Lunch** liczby są zbliżone (33 mężczyzn vs 35 kobiet — różnica w granicach przypadku przy n=68), w **Dinner** mężczyźni dominują ponad 2:1 (124 vs 52). Pytanie biznesowe do dalszej analizy: czy Dinner to bardziej „męski" segment (np. spotkania służbowe wieczorne, kiedy płaci jeden mężczyzna za stół)?

---

### Własna obserwacja (obowiązkowe)
Dodaj komórkę Markdown w notebooku i napisz (2-3 zdania): co wynika z Twoich 4 wykresów? Jaką radę dałbyś menedżerowi restauracji?

---

## Ćwiczenie 4: Wiele wykresów (subplots) + zapis + commit (15 min)

**Cel:** Zbudować dashboard analityczny 2×2, zapisać PNG i wykonać commit.

### Zadanie 4.1 — Dashboard tips 2×2

Stwórz Figure z 4 wykresami w układzie 2×2:

```python
fig, axes = plt.subplots(2, 2, figsize=(13, 9))

# [0, 0] — Średni napiwek per dzień (słupkowy)
sredni_napiwek_dzien = tips.groupby('day', observed=True)['tip'].mean()
axes[0, 0].bar(sredni_napiwek_dzien.index,
               sredni_napiwek_dzien.values,
               color='steelblue')
axes[0, 0].set_title('Średni napiwek per dzień')
axes[0, 0].set_ylabel('Napiwek [$]')
axes[0, 0].grid(axis='y', alpha=0.4)

# [0, 1] — Scatter: rachunek vs napiwek
axes[0, 1].scatter(tips['total_bill'], tips['tip'],
                   alpha=???,          # 0.5
                   color='steelblue',
                   s=30)
axes[0, 1].set_title(???)              # 'Rachunek vs Napiwek'
axes[0, 1].set_xlabel('Rachunek [$]')
axes[0, 1].set_ylabel('Napiwek [$]')

# [1, 0] — Histogram napiwków
axes[1, 0].hist(tips['tip'],
                bins=???,              # 20
                color='salmon',
                edgecolor='white')
axes[1, 0].set_title('Rozkład napiwków')
axes[1, 0].set_xlabel('Napiwek [$]')
axes[1, 0].set_ylabel('Liczba obserwacji')

# [1, 1] — Liczba zamówień per dzień (bar)
zamowienia_dzien = tips.groupby('day', observed=True)['total_bill'].count()
axes[1, 1].bar(zamowienia_dzien.index,
               zamowienia_dzien.values,
               color='lightsteelblue',
               edgecolor='steelblue')
axes[1, 1].set_title('Liczba zamówień per dzień')
axes[1, 1].set_ylabel('Liczba zamówień')
axes[1, 1].grid(axis='y', alpha=0.4)

plt.suptitle('Dashboard Restauracji "Pod Widelcem"',
             fontsize=15, fontweight='bold')
plt.tight_layout()
plt.savefig('dashboard_tips.png', dpi=100)
plt.show()
plt.close()
print("Zapisano: dashboard_tips.png")
```

**Sprawdzenie 4.1** ✅
4 wykresy w układzie 2×2: górny lewy = słupkowy napiwki per dzień, górny prawy = scatter, dolny lewy = histogram, dolny prawy = słupkowy liczba zamówień. Tytuł główny ponad wszystkimi. Wszystkie wykresy czytelne — bez uciętych etykiet (`tight_layout`).

---

### Zadanie 4.2 — Commit na GitHub

Zapisz notebook i wykonaj commit zawierający notebook i wszystkie PNG-i z dzisiejszego labu.

```bash
# W terminalu VS Code (Ctrl+`)
cd W09                                  # jeśli jeszcze nie jesteś w folderze tygodnia
git add lab09_matplotlib.ipynb
git add *.png                           # dodaj wszystkie PNG-i z dzisiejszego labu
git commit -m "L09: matplotlib — wykresy, subplots, dashboard"
git push
```

Sprawdź na GitHub czy commit jest widoczny. Pokaż prowadzącemu link do swojego commita.

**Sprawdzenie 4.2** ✅
Na GitHub w Twoim repozytorium widać folder `W09/` zawierający `lab09_matplotlib.ipynb` oraz wszystkie PNG-i z dzisiejszych ćwiczeń (minimum: `trend_2024.png`, `sprzedaz_kategorie.png`, `scatter_tips.png`, `dashboard_tips.png`). Komunikat commita zaczyna się od `L09:`.

---

## Podsumowanie — co dziś zrobiłeś

```
import matplotlib.pyplot as plt    → zawsze ten alias
%matplotlib inline                 → w Jupyter, jako pierwsza linia

fig, ax = plt.subplots()          → punkt startowy każdego wykresu

ax.plot()     → trend w czasie (liniowy)
ax.bar()      → porównanie kategorii (pionowy)
ax.barh()     → porównanie kategorii (poziomy, przy długich etykietach)
ax.scatter()  → korelacja dwóch zmiennych
ax.hist()     → rozkład jednej zmiennej

ax.set_title()    → tytuł wykresu
ax.set_xlabel()   → etykieta osi X
ax.set_ylabel()   → etykieta osi Y
ax.legend()       → legenda (potrzebuje label= w plot/scatter)
ax.grid()         → siatka (axis='y', alpha=0.4)
ax.axvline()      → pionowa linia na wartości X

plt.tight_layout()    → poprawia marginesy
plt.savefig('f.png')  → zapisz plik PNG
plt.show()            → pokaż wykres inline w notebook (Jupyter)
plt.close()           → zwolnij pamięć Figure (zawsze po savefig!)

plt.subplots(2, 2)    → układ 2×2, axes[wiersz, kolumna]
plt.suptitle()        → tytuł całej Figure (ponad subplots)

df.plot(kind='bar')   → wykres wprost z DataFrame (Pandas)
```

### Wymagania do zaliczenia laboratorium W09
- [ ] Folder `W09/` w repozytorium z notebookiem `lab09_matplotlib.ipynb`
- [ ] Ćwiczenie 1: 3 PNG-i (`trend_2024.png`, `sprzedaz_kategorie.png`, `scatter_tips.png`) w folderze `W09/`
- [ ] Ćwiczenie 2: wykres z dwiema seriami i legendą + barh z kolorami + wykres ze stylem seaborn
- [ ] Ćwiczenie 3: samodzielna analiza tips — 4 wykresy (3.1–3.4) + komórka Markdown z obserwacją biznesową
- [ ] Ćwiczenie 4: `dashboard_tips.png` (układ 2×2)
- [ ] Commit na GitHub z komunikatem zaczynającym się od `L09:`

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| Wykres nie wyświetla się | Dodaj `%matplotlib inline` na początku notebooka. W VS Code: sprawdź czy masz Jupyter extension |
| Etykiety osi się nakładają | Użyj `plt.tight_layout()` lub `fig.autofmt_xdate()` dla dat. Albo: `plt.xticks(rotation=45)` |
| Legenda zasłania wykres | `plt.legend(loc='upper left')` lub `plt.legend(bbox_to_anchor=(1.05, 1))` (poza wykresem) |
| Kolory — nie wiem jakie są dostępne | Podstawowe: `'red'`, `'blue'`, `'green'`, `'orange'`. Pełna lista: matplotlib.org/stable/gallery/color/named_colors.html |
| `subplots()` — nie wiem jak adresować panele | `fig, axes = plt.subplots(2, 2)` → `axes[0, 0]` (lewy górny), `axes[1, 1]` (prawy dolny) |
| Wykres się nie zapisuje | `plt.savefig('wykres.png', dpi=150, bbox_inches='tight')` — PRZED `plt.show()`! |
| `alpha=0.6` — co to? | Przezroczystość: 0 = niewidoczny, 1 = pełny kolor. 0.6 = lekko prześwitujący |
| `ModuleNotFoundError: No module named 'seaborn'` | Wykonaj `uv pip install seaborn` w terminalu (z aktywnym venv). Patrz sekcja Start. |
| `AttributeError: 'Axes' object has no attribute 'title'` lub `'Text' object is not callable` | Używasz `ax.title('...')` zamiast `ax.set_title('...')`. Pamiętaj o prefiksie `set_` na Axes. |
| Wykres pokazuje się tylko jako napis "Zapisano: ..." (puste miejsce nad printem) | Brakuje `plt.show()` przed `plt.close()`. Kolejność: `savefig → show → close`. |
| Gdzie zapisuje się PNG? | W bieżącym katalogu notebooka — czyli w folderze `W09/` jeśli notebook jest tam utworzony. Sprawdź `os.getcwd()` w komórce kodu. |

---

## Dla zaawansowanych

Jeśli skończyłeś podstawowe ćwiczenia i chcesz pójść dalej:

1. **Bubble chart (4. wymiar w scatter).** W zadaniu 1.3 dodaj rozmiar punktu zależny od liczby gości:
   ```python
   ax.scatter(tips['total_bill'], tips['tip'],
              s=tips['size'] * 30,        # rozmiar = liczba gości × 30
              alpha=0.5, color='steelblue')
   ```
   Co się zmieniło wizualnie? Czy widać różnicę między 2-osobowymi i 6-osobowymi grupami?

2. **Mapa gęstości zamiast scatter.** Gdy mamy dużo punktów, scatter z `alpha` to tylko sugestia gęstości. Spróbuj `hexbin`:
   ```python
   fig, ax = plt.subplots(figsize=(8, 6))
   hb = ax.hexbin(tips['total_bill'], tips['tip'], gridsize=20, cmap='Blues')
   plt.colorbar(hb, ax=ax, label='Liczba obserwacji')
   ```
   Porównaj wynik ze swoim scatterem z 1.3.

3. **Adnotacja na wykresie.** Dodaj strzałkę wskazującą najwyższy napiwek w datasecie:
   ```python
   max_idx = tips['tip'].idxmax()
   max_bill = tips.loc[max_idx, 'total_bill']
   max_tip  = tips.loc[max_idx, 'tip']

   ax.annotate(f'Rekordowy napiwek: {max_tip}$',
               xy=(max_bill, max_tip),
               xytext=(max_bill - 15, max_tip - 1),
               arrowprops=dict(arrowstyle='->', color='darkred'))
   ```

4. **Eksport raportu PDF.** Zamiast PNG zapisz dashboard jako PDF (lepsze do wydruku):
   ```python
   plt.savefig('dashboard_tips.pdf', bbox_inches='tight')
   ```
   Sprawdź czy w VS Code lub przeglądarce wygląda jak chcesz.

5. **(Praca domowa — opcjonalnie)** Wróć do danych e-sklepu książek z W08 (autorzy × książki × zamówienia). Stwórz dashboard 2×2: trend miesięczny zamówień, sprzedaż per miasto (`barh`), sprzedaż per kategoria, scatter cena vs liczba stron. Zapisz jako `dashboard_ksiegarnia.png` i dorzuć do następnego commita. **To zadanie wykracza poza 90 min labu** — dla osób, które chcą pójść dalej w domu.

> **Sukces dnia:** masz portfolio-ready raport wizualny. Wkleić do CV jako screenshot z opisem „Analiza biznesowa restauracji w Pythonie — Matplotlib".
