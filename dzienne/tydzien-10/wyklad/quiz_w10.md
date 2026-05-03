# Quiz W10 — Matplotlib + Seaborn zaawansowane

**Temat:** Powtórka W09 (podstawy Matplotlib) + nowy materiał W10 (Seaborn, dashboardy)
**Czas:** 5 minut | **Forma:** kartka lub Mentimeter

---

## Pytania (do wyświetlenia na projektorze — po jednym)

---

### Pytanie 1 (powtórka W09 — Matplotlib podstawy)

Który kod poprawnie tworzy wykres słupkowy z etykietami osi i tytułem?

**A)**
```python
plt.bar(x, y)
```

**B)**
```python
fig, ax = plt.subplots()
ax.bar(x, y)
ax.set_title('Sprzedaż')
ax.set_xlabel('Miesiąc')
ax.set_ylabel('Wartość (PLN)')
plt.show()
```

**C)**
```python
plt.bar(x, y, title='Sprzedaż', xlabel='Miesiąc')
plt.show()
```

**D)**
```python
ax.plot(x, y, kind='bar')
```

**Odpowiedź: B** — Pełny wykres z etykietami i tytułem wymaga `ax.set_title()`, `ax.set_xlabel()`, `ax.set_ylabel()`. Opcja A działa, ale brak etykiet. C: `plt.bar()` nie przyjmuje `title=` ani `xlabel=` jako argumentów. D: `ax.plot()` nie ma parametru `kind=`.

---

### Pytanie 2 (powtórka W09 — Matplotlib podstawy)

Co robi wywołanie `plt.savefig('wykres.png', dpi=300, bbox_inches='tight')`?

**A)** Wyświetla wykres na ekranie w rozdzielczości 300 DPI

**B)** Zapisuje wykres do pliku PNG w rozdzielczości 300 DPI, nie obcinając żadnych elementów (tytułów, etykiet)

**C)** Zapisuje wykres, ale tylko jeśli jest na nim tytuł

**D)** Tworzy kopię figury w pamięci — nie tworzy pliku na dysku

**Odpowiedź: B** — `savefig()` zapisuje do pliku. `dpi=300` — jakość (72=web, 150=ekran, 300=druk). `bbox_inches='tight'` — automatycznie dobiera marginesy żeby żaden element (tytuł, legenda, etykieta) nie był obcięty. Nie wyświetla na ekranie.

---

### Pytanie 3 (nowy — Seaborn)

Które wywołanie Seaborn automatycznie wyliczy i pokaże **95% przedziały ufności** na słupkach?

**A)**
```python
plt.bar(tips['day'], tips['total_bill'].mean())
```

**B)**
```python
sns.barplot(data=tips, x='day', y='total_bill')
```

**C)**
```python
sns.histplot(data=tips, x='day')
```

**D)**
```python
ax.bar(tips.groupby('day', observed=True)['total_bill'].mean())
```

**Odpowiedź: B** — `sns.barplot()` domyślnie wyświetla średnią i rysuje wąsy z 95% przedziałem ufności (CI) wyliczonym przez bootstrapping. Nie musicie nic dodawać — to jest wbudowane. Matplotlib (`plt.bar`, `ax.bar`) tego nie robi — musielibyście liczyć ręcznie.

---

### Pytanie 4 (nowy — subplots i GridSpec)

Chcesz zbudować dashboard, gdzie górny panel zajmuje pełną szerokość, a poniżej są 3 równe wykresy obok siebie. Które podejście jest prawidłowe?

**A)**
```python
fig, axes = plt.subplots(2, 1, figsize=(12, 8))
```

**B)**
```python
import matplotlib.gridspec as gridspec
fig = plt.figure(figsize=(12, 8))
gs = gridspec.GridSpec(2, 3, figure=fig)
ax_top = fig.add_subplot(gs[0, :])    # górny — pełna szerokość
ax1 = fig.add_subplot(gs[1, 0])       # dolny lewy
ax2 = fig.add_subplot(gs[1, 1])       # dolny środek
ax3 = fig.add_subplot(gs[1, 2])       # dolny prawy
```

**C)**
```python
fig, axes = plt.subplots(1, 3, figsize=(12, 8))
```

**D)**
```python
fig = plt.figure(figsize=(12, 8))
ax1 = fig.add_subplot(2, 1, 1)
ax2 = fig.add_subplot(2, 1, 2)
```

**Odpowiedź: B** — `GridSpec(2, 3)` tworzy siatkę 2 wiersze × 3 kolumny. `gs[0, :]` — slice: cały pierwszy wiersz = pełna szerokość. `gs[1, 0]`, `gs[1, 1]`, `gs[1, 2]` — trzy równe komórki w drugim wierszu. A: tworzy 2 wykresy jeden pod drugim (nie 1+3). C: tylko jeden rząd z 3 wykresami. D: to samo co A innym API.

---

### Pytanie 5 (nowy — heatmap i pairplot)

Co jest **prawdą** o `sns.pairplot()` w porównaniu do `sns.heatmap()`?

**A)** `pairplot` pokazuje tylko korelację jako liczby, `heatmap` rysuje wykresy rozrzutu

**B)** Obie funkcje przyjmują parametr `ax=` do umieszczenia wykresu w siatce subplotów

**C)** `pairplot` tworzy macierz wykresów (scatter + rozkłady), zwraca `PairGrid`, nie przyjmuje `ax=`. `heatmap` przyjmuje `ax=` i można go umieścić w siatce subplotów.

**D)** `pairplot` i `heatmap` to różne nazwy tej samej funkcji

**Odpowiedź: C** — `sns.pairplot()` tworzy własną figurę z macierzą wykresów: scatter między każdą parą zmiennych i rozkłady na przekątnej. Zwraca `PairGrid` — nie można go umieścić jako jednego wykresu w siatce `subplots()`. `sns.heatmap()` standardowo przyjmuje `ax=` i działa w każdej siatce. To ważna różnica przy budowaniu dashboardów.

---

### Pytanie 6 (nowy — narracja dashboardu, Bloom 4)

Otrzymujesz dashboard z 6 paneli, w którym każdy panel ma **inną paletę kolorów** i **inne style** (whitegrid, darkgrid, ticks pomieszane). Co jest **najpoważniejszym problemem** z punktu widzenia odbiorcy?

**A)** Plik PNG będzie większy niż konieczne (nieefektywna kompresja kolorów).

**B)** Dashboard nie wyrenderuje się w starszych wersjach matplotlib.

**C)** Brak narracji — odbiorca nie wie, czy panele są ze sobą powiązane; różne palety = różne znaczenia tych samych kolorów (zmęczenie poznawcze, *cognitive load*).

**D)** Trzeba więcej linii kodu, żeby ustawić wszystkie style.

**Odpowiedź: C** — Dashboard to **narracja, nie kolaż**. Wybór paletty i stylu jest częścią opowieści: jeśli kolor *czerwony* w panelu 1 oznacza palaczy, a w panelu 4 ten sam czerwony oznacza coś innego — odbiorca traci 30 sekund na rozkminkę. Profesjonalny dashboard ma JEDEN motyw i JEDNĄ paletę dla powtarzających się kategorii. To jest **realizacja celu uczenia się #4** (Bloom 4 — projektowanie spójnej narracji).

---

## Klucz odpowiedzi (dla prowadzącego)

| Pytanie | Odpowiedź | Temat | Cel uczenia |
|---------|-----------|-------|-------------|
| 1 | B | W09 — Matplotlib podstawy, etykiety | (powtórka) |
| 2 | B | W09 — savefig, DPI, bbox_inches | (powtórka) |
| 3 | B | W10 — sns.barplot, CI automatyczne | C2, C5 |
| 4 | B | W10 — GridSpec, nieregularne panele | C3 |
| 5 | C | W10 — pairplot vs heatmap, ax= | C6 |
| 6 | C | W10 — narracja dashboardu, jednolitość | **C4 (Bloom 4)** |
