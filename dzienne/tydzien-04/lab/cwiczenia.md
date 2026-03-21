# L04 — Ćwiczenia laboratoryjne

## Temat: NumPy zaawansowane — broadcasting, reshape, analiza finansowa

**Programowanie w Pythonie II** | Laboratorium 4
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Po tym laboratorium potrafisz:

1. **Stosować** broadcasting do obliczeń na danych różnych kształtów (Bloom 3)
2. **Zmieniać** kształt tablic z reshape i łączyć dane ze stacking (Bloom 3)
3. **Analizować** dane finansowe stosując `np.where`, `argsort`, korelację (Bloom 4)
4. **Generować** realistyczne dane syntetyczne do symulacji biznesowych (Bloom 3)

Na wykładzie poznaliście broadcasting, reshape i zaawansowane operacje NumPy. Teraz przećwiczycie to na danych biznesowych — ceny produktów, wynagrodzenia, sprzedaż.

---

## Start — 3 komendy

Otwórz terminal w VS Code i wpisz:

```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Utwórz nowy notebook: `lab04_numpy_advanced.ipynb`

Pierwsza komórka — Markdown:
```markdown
# Laboratorium 4 — NumPy zaawansowane
**Autor:** [Twoje imię i nazwisko]
```

Druga komórka — kod:
```python
import numpy as np
```

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| NumPy — broadcasting | https://numpy.org/doc/stable/user/basics.broadcasting.html |
| NumPy — `reshape()` | https://numpy.org/doc/stable/reference/generated/numpy.reshape.html |
| NumPy — `np.where()` | https://numpy.org/doc/stable/reference/generated/numpy.where.html |
| NumPy — `np.random` | https://numpy.org/doc/stable/reference/random/index.html |
| NumPy — operacje na tablicach 2D | https://numpy.org/doc/stable/user/absolute_beginners.html#more-useful-array-operations |
| NumPy — `np.select()` | https://numpy.org/doc/stable/reference/generated/numpy.select.html |
| NumPy — `np.digitize()` | https://numpy.org/doc/stable/reference/generated/numpy.digitize.html |
| NumPy — `np.nan` (obsługa brakujących danych) | https://numpy.org/doc/stable/user/misc.html |
| NumPy — `np.diff()` | https://numpy.org/doc/stable/reference/generated/numpy.diff.html |

### Kluczowe pojęcia tego laboratorium

- **Broadcasting** — mechanizm NumPy pozwalający wykonywać operacje na tablicach o różnych kształtach. Np. tablica (4x3) x wektor (3,) -> każdy wiersz pomnożony przez wektor.
- **Reshape** — zmiana kształtu tablicy bez zmiany danych. Np. tablica 12-elementowa -> macierz 3x4.
- **`np.where(warunek, wartość_tak, wartość_nie)`** — wektorowy odpowiednik `if/else` — działa na całych tablicach naraz.
- **`np.clip(tablica, min, max)`** — przycina wartości do zakresu (przydatne do czyszczenia danych).
- **`np.argsort()`** — zwraca indeksy sortowania, nie wartości (klucz do rankingów).
- **`np.unique(a, return_counts=True)`** — unikalne wartości + ile razy każda wystąpiła.
- **`np.select(warunki, wartości, default)`** — wielowarunkowe przypisanie (jak zagnieżdżone IF w Excelu).
- **`np.digitize(dane, bins)`** — przypisywanie do przedziałów (grupy wiekowe, klasy cenowe).
- **`np.nan`**, **`np.nanmean()`**, **`np.nanstd()`** — obsługa brakujących danych.
- **`np.diff(a)`** — różnice między kolejnymi elementami (dynamika zmian).

---

## Ćwiczenie 1: Broadcasting — zastosowania biznesowe (20 min)

### Cel
Użyj broadcastingu do obliczeń na danych o różnych kształtach. Każde zadanie w osobnej komórce z komentarzem.

### Krok 1 — Dane

```python
# Ceny 4 produktów w 3 sklepach
ceny = np.array([[29.99, 31.99, 28.99],    # Produkt A
                  [49.99, 52.99, 47.99],    # Produkt B
                  [14.99, 15.99, 13.99],    # Produkt C
                  [99.99, 104.99, 94.99]])  # Produkt D

sklepy = ['Centrum', 'Galeria', 'Online']
produkty = ['A', 'B', 'C', 'D']
print(f"Kształt macierzy: {ceny.shape}")  # (4, 3)
```

### Krok 2 — Zadania

**Zadanie 1a:** Stwórz nowy array z cenami podniesionymi o 5% (inflacja). Wyświetl wynik.
```python
# Broadcasting: macierz (4×3) * skalar
# Podpowiedź: ceny * 1.05
```

**Zadanie 1b:** Stwórz array z cenami po rabacie. Każdy sklep daje inny rabat: Centrum 10%, Galeria 5%, Online 15%.
```python
rabaty = np.array([0.10, 0.05, 0.15])
# Broadcasting: macierz (4×3) * wektor (3,)
# Podpowiedź: ceny * (1 - rabaty)
# Wektor 3-elementowy pasuje do 3 kolumn — broadcasting wierszowy
```

**Zadanie 1c:** Oblicz koszt zakupu każdego produktu. Każdy produkt ma inną marżę: A=30%, B=40%, C=25%, D=50%.
```python
marza = np.array([[0.30], [0.40], [0.25], [0.50]])
# Broadcasting: macierz (4×3) * wektor kolumnowy (4×1)
# Oblicz koszt zakupu: cena / (1 + marża)
# Podpowiedź: marża jest kolumną (4×1) — broadcasting kolumnowy
```

**Zadanie 1d:** Wyświetl najtańszy sklep dla każdego produktu.
```python
# Podpowiedź: użyj .argmin(axis=1) i listy sklepów
```

### Sprawdzenie ✅

- 1a: Cena A w Centrum po inflacji = 31.49
- 1b: Cena B Online po rabacie = 40.79
- 1c: Koszt zakupu D w Centrum = 66.66
- 1d: Najtańszy sklep dla każdego produktu — Online (kolumna 2)

---

## Ćwiczenie 2: Reshape i łączenie danych (20 min)

### Cel
Zmień kształt danych i połącz tablice z różnych źródeł.

### Zadanie 2a — Reshape

```python
# Dane miesięczne z jednego roku (flat)
dane_flat = np.array([120, 135, 98, 142, 167, 189, 201, 178, 156, 143, 198, 221])

# Przekształć na kwartały (4 kwartały × 3 miesiące)
kwartaly = dane_flat.reshape(4, 3)
print(f"Kwartały:\n{kwartaly}")
print(f"Suma per kwartał: {kwartaly.sum(axis=1)}")
print(f"Najlepszy kwartał: Q{kwartaly.sum(axis=1).argmax() + 1}")
```

### Zadanie 2b — Stacking

```python
# Dane z 3 oddziałów (osobne tablice)
warszawa = np.array([150, 160, 170, 180])
krakow = np.array([120, 130, 140, 150])
wroclaw = np.array([90, 100, 110, 120])

# Połącz w macierz (3 oddziały × 4 kwartały)
wszystkie = np.vstack([warszawa, krakow, wroclaw])
print(f"Wszystkie:\n{wszystkie}")
print(f"Suma per oddział: {wszystkie.sum(axis=1)}")
print(f"Suma per kwartał: {wszystkie.sum(axis=0)}")
```

### Zadanie 2c — Praktyczne (samodzielnie)

```python
# Masz dane o sprzedaży 6 produktów jako wektor
sprzedaz_flat = np.array([100, 200, 150, 300, 250, 180, 120, 220, 170, 310, 260, 190])
# Wiesz, że to 6 produktów × 2 miesiące

# 1. Reshape na macierz 6×2
# Podpowiedź: sprzedaz_flat.reshape(6, 2) albo .reshape(-1, 2)

# 2. Oblicz średnią sprzedaż per produkt (axis=1)

# 3. Oblicz zmianę między miesiącem 1 a 2 (kolumna 1 - kolumna 0)
# Podpowiedź: macierz[:, 1] - macierz[:, 0]
```

### Zadanie 2d — Flatten i concatenate

```python
# Masz macierz kwartałów z zadania 2a
# 1. Spłaszcz ją z powrotem do wektora (.flatten())
# 2. Dodaj dane z 13. miesiąca (wartość: 235) — np.concatenate()
# Podpowiedź: np.concatenate([wektor, np.array([235])])
```

### Sprawdzenie ✅

- 2a: Najlepszy kwartał: Q4 (suma 562)
- 2b: Suma per oddział: Warszawa=660, Kraków=540, Wrocław=420
- 2c: Średnia per produkt: [150, 225, 215, 170, 240, 225]
- 2d: Po concatenate — tablica 13-elementowa

---

## Ćwiczenie 3: Analiza danych finansowych (30 min)

### Cel
Samodzielna analiza danych finansowych firmy z użyciem zaawansowanych operacji NumPy.

### Dane

```python
np.random.seed(2026)

# 8 pracowników, dane roczne
pracownicy = ['Anna', 'Jan', 'Ewa', 'Marek', 'Kasia', 'Piotr', 'Zofia', 'Tomek']
pensje = np.array([5500, 7200, 4800, 9100, 6300, 4200, 8500, 5800])
staz = np.array([3, 8, 2, 15, 5, 1, 12, 4])
oceny = np.array([4.2, 3.8, 4.5, 4.0, 4.7, 3.5, 4.3, 3.9])

# Sprzedaż miesięczna 4 produktów przez 6 miesięcy
produkty_nazwy = ['Laptop', 'Tablet', 'Smartfon', 'Akcesorium']
sprzedaz = np.random.randint(20, 200, size=(4, 6))
ceny_produktow = np.array([3500, 1800, 2500, 150])
```

### Zadania

**Zadanie 3a: Analiza wynagrodzeń**
```python
# 1. Oblicz średnią, medianę i odchylenie standardowe pensji
# Podpowiedź: pensje.mean(), np.median(pensje), pensje.std()

# 2. Wyświetl imiona osób zarabiających powyżej średniej
# Uwaga: pracownicy to lista — zamień na np.array(pracownicy), żeby użyć maski
# Podpowiedź: nazwy = np.array(pracownicy), potem nazwy[pensje > pensje.mean()]

# 3. Wyświetl imiona osób zarabiających poniżej mediany

# 4. Oblicz rozstęp (max - min) i rozstęp międzykwartylowy (IQR)
# Podpowiedź: IQR = np.percentile(pensje, 75) - np.percentile(pensje, 25)
```

**Zadanie 3b: System premii (np.where)**
```python
# Zasady premii:
# - ocena >= 4.5 → premia 2000 zł
# - ocena >= 4.0 → premia 1000 zł
# - ocena < 4.0 → premia 0 zł
# Podpowiedź: zagnieżdżony where:
#   np.where(oceny >= 4.5, 2000, np.where(oceny >= 4.0, 1000, 0))

# Oblicz nowe wynagrodzenie (pensja + premia)
# Kto dostał najwyższą premię? Użyj argmax()
```

**Zadanie 3c: Ranking (argsort)**
```python
# Posortuj pracowników wg pensji (od najwyższej)
# Podpowiedź: kolejnosc = np.argsort(pensje)[::-1]
# Wyświetl ranking: pozycja, imię, pensja, staż
# Podpowiedź: for i, idx in enumerate(kolejnosc, 1): ...
```

**Zadanie 3d: Korelacja**
```python
# Oblicz korelację: staż vs pensja
# Podpowiedź: np.corrcoef(staz, pensje)[0, 1]

# Oblicz korelację: staż vs ocena
# Który związek jest silniejszy? (wyższa wartość bezwzględna r)
```

**Zadanie 3e: Analiza sprzedaży (broadcasting)**
```python
# Oblicz przychód: sprzedaz (4×6) * ceny_produktow (4,) — UWAGA na broadcasting!
# Problem: (4,6) * (4,) — nie pasuje! 6 != 4
# Rozwiązanie: ceny muszą być kolumną (4×1)
# Podpowiedź: ceny_kol = ceny_produktow.reshape(4, 1)
#             przychod = sprzedaz * ceny_kol

# Który produkt przyniósł największy łączny przychód? (axis=1, argmax)
# Który miesiąc był najlepszy łącznie? (axis=0, argmax)
# Trend: porównaj pierwsze 3 miesiące vs ostatnie 3
# Podpowiedź: przychod[:, :3].sum() vs przychod[:, 3:].sum()
```

### Sprawdzenie ✅

- 3a: Średnia pensji = 6425.0 zł, IQR = 2200.0 zł
- 3b: Ewa i Kasia dostają premię 2000 zł (oceny 4.5 i 4.7)
- 3c: Pierwszy w rankingu — Marek (9100 zł, staż 15 lat)
- 3d: Korelacja staż-pensja powinna być dodatnia (wyższy staż = wyższa pensja)
- 3e: Klucz to `ceny_produktow.reshape(4, 1)` — bez tego `ValueError`

---

## Ćwiczenie 4: Generowanie danych (15 min)

### Cel
Wygeneruj realistyczne dane biznesowe i przeanalizuj je.

### Krok 1 — Generowanie

```python
np.random.seed(42)

# Wygeneruj dane o 100 klientach sklepu:
# - wiek: rozkład normalny, średnia 35, std 10, zaokrąglony do int, min 18
# - wydatki_miesiecznie: rozkład normalny, średnia 500, std 200, min 0
# - liczba_wizyt: rozkład Poissona, lambda=5

# Podpowiedź: np.clip() ogranicza wartości do zakresu
wiek = np.clip(np.random.normal(35, 10, 100).astype(int), 18, None)
wydatki = np.clip(np.random.normal(500, 200, 100), 0, None)
wizyty = np.random.poisson(5, 100)
```

### Krok 2 — Analiza (samodzielnie)

```python
# 1. Statystyki opisowe każdej zmiennej (mean, median, std, min, max)
# Podpowiedź: print(f"Wiek — średnia: {wiek.mean():.1f}, mediana: {np.median(wiek):.1f}")

# 2. Korelacja wiek vs wydatki
# Podpowiedź: np.corrcoef(wiek, wydatki)[0, 1]

# 3. Korelacja wizyty vs wydatki

# 4. Segmentacja klientów za pomocą np.where:
#    - "WYSOKI" gdy wydatki > średnia + std
#    - "NISKI" gdy wydatki < średnia - std
#    - "ŚREDNI" w pozostałych przypadkach
# Podpowiedź: zagnieżdżony np.where (jak w zadaniu 3b)
#   sr = wydatki.mean()
#   sd = wydatki.std()
#   segment = np.where(wydatki > sr + sd, 'WYSOKI', np.where(wydatki < sr - sd, 'NISKI', 'ŚREDNI'))

# 5. Ile klientów w każdym segmencie? Użyj np.unique(..., return_counts=True)
```

### Sprawdzenie ✅

- Korelacja wiek-wydatki powinna być bliska 0 (brak związku — dane losowe)
- Segmenty: ~16% WYSOKI, ~16% NISKI, ~68% ŚREDNI (reguła 68-95-99 rozkładu normalnego)

> **Wskazówka:** Na wykładzie poznaliście też `np.select`, `np.digitize`, `np.nan` i `np.diff`.
> Spróbujcie je zastosować w swoich ćwiczeniach — np. użyjcie `np.select` zamiast zagnieżdżonego `np.where` w ćw. 3,
> albo `np.diff` do policzenia zmian miesiąc-do-miesiąca w ćw. 2.

---

## Ćwiczenie 5: Commit na GitHub (5 min)

```bash
cd C:\Users\student\python2
git add lab04_numpy_advanced.ipynb
git commit -m "L04: NumPy zaawansowane — broadcasting, analiza finansowa"
git push
```

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Używać broadcastingu do obliczeń na danych różnych kształtów
- ✅ Zmieniać kształt tablic (reshape, flatten, stacking)
- ✅ Stosować where, sort, argsort, korelację
- ✅ Generować realistyczne dane syntetyczne

**Na następnych zajęciach:** Pandas — DataFrame, wczytywanie CSV, selekcja danych. NumPy pod spodem, ale z etykietami i wygodą.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `ModuleNotFoundError: No module named 'numpy'` | Aktywuj środowisko: `.venv\Scripts\Activate.ps1` |
| Błąd przy aktywacji venv (security policy) | `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` |
| `ValueError: operands could not be broadcast` | Sprawdź kształty: `print(a.shape, b.shape)`. Wymiary muszą być takie same lub równe 1 |
| Broadcasting: wektor nie pasuje do macierzy | Wektor (4,) pasuje do kolumn (oś 1). Jeśli chcesz po wierszach — `reshape(4, 1)` |
| `reshape(-1, 4)` — co oznacza `-1`? | `-1` = oblicz automatycznie. 12 elementów, 4 kolumny -> `-1` = 3 wiersze |
| `ValueError: cannot reshape` | Rozmiary się nie zgadzają (np. 12 elementów nie da się w 5×3) |
| `np.where` z wieloma warunkami | Zagnieżdżaj: `np.where(w1, val1, np.where(w2, val2, val3))` |
| Wynik operacji ma zły kształt | Sprawdź: `print(wynik.shape)` — porównaj z oczekiwanym |
| Chcę użyć maski na liście Pythona | Zamień na tablicę NumPy: `np.array(lista)`, potem `tablica[maska]` |
| `IndexError: index out of bounds` | Indeksy zaczynają się od 0. Sprawdź `.shape` |
| Wynik to `nan` | Masz brakujące dane — użyj `np.nanmean()` zamiast `.mean()` |
| `np.diff` daje tablicę o 1 krótszą | To normalne — różnice między N elementami to N-1 wartości |
| `np.select` — warunki nie działają | Sprawdź czy warunki i wartości mają tę samą długość, kolejność ma znaczenie |
