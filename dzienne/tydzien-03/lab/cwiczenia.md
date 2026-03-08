# L03 — Ćwiczenia laboratoryjne

## Temat: NumPy — tablice, operacje, analiza danych

**Programowanie w Pythonie II** | Laboratorium 3
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| NumPy — oficjalna dokumentacja | https://numpy.org/doc/stable/ |
| NumPy — szybki start | https://numpy.org/doc/stable/user/quickstart.html |
| NumPy — tworzenie tablic | https://numpy.org/doc/stable/reference/routines.array-creation.html |
| NumPy — indeksowanie i slicing | https://numpy.org/doc/stable/user/basics.indexing.html |
| NumPy — operacje matematyczne | https://numpy.org/doc/stable/reference/routines.math.html |
| NumPy — statystyki (mean, std, min, max) | https://numpy.org/doc/stable/reference/routines.statistics.html |

---

## Ćwiczenie 1: Tworzenie tablic (20 min)

### Cel
Naucz się tworzyć tablice NumPy różnymi sposobami i poznaj ich atrybuty.

### Krok 1 — Utwórz notebook

1. Otwórz terminal w VS Code
2. Przejdź do katalogu projektu i aktywuj środowisko:
```
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```
3. Utwórz notebook `lab03_numpy.ipynb`
4. Pierwsza komórka Markdown:

```markdown
# Laboratorium 3 — NumPy
**Autor:** [Twoje imię]
```

### Krok 2 — Import

```python
import numpy as np
```

### Krok 3 — Tworzenie tablic

Utwórz każdą tablicę w osobnej komórce i wyświetl wynik:

```python
# 1. Z listy
oceny = np.array([4.0, 3.5, 5.0, 4.5, 3.0, 4.0, 5.0])
print(f"Oceny: {oceny}")
print(f"Typ: {oceny.dtype}")
```

```python
# 2. Zera — 10 elementów
zera = np.zeros(10)
print(f"Zera: {zera}")
```

```python
# 3. Jedynki — macierz 3×5
jedynki = np.ones((3, 5))
print(f"Jedynki:\n{jedynki}")
```

```python
# 4. Sekwencja od 0 do 100, co 10
dziesiatki = np.arange(0, 101, 10)
print(f"Dziesiątki: {dziesiatki}")
```

```python
# 5. 7 równomiernych punktów od 0 do 1
procenty = np.linspace(0, 1, 7)
print(f"Procenty: {procenty}")
```

```python
# 6. 20 losowych ocen od 2 do 5
np.random.seed(42)
losowe_oceny = np.random.randint(2, 6, size=20)
print(f"Losowe oceny: {losowe_oceny}")
```

### Krok 4 — Atrybuty

```python
# Zbadaj tablicę losowych ocen
print(f"shape: {losowe_oceny.shape}")
print(f"ndim: {losowe_oceny.ndim}")
print(f"size: {losowe_oceny.size}")
print(f"dtype: {losowe_oceny.dtype}")
```

### Sprawdzenie ✅

- Umiesz tworzyć tablice: array, zeros, ones, arange, linspace, random
- Znasz atrybuty: shape, ndim, size, dtype

---

## Ćwiczenie 2: Indeksowanie i slicing (20 min)

### Cel
Wyciągaj dane z tablic 1D i 2D. To fundament, którego będziesz potrzebować w Pandas.

### Część A — Tablica 1D

```python
miesiace_sprzedaz = np.array([120, 135, 98, 142, 167, 189, 201, 178, 156, 143, 198, 221])
# Indeksy:                     0     1    2    3    4    5    6    7    8    9   10   11
# Miesiące:                  Sty  Lut  Mar  Kwi  Maj  Cze  Lip  Sie  Wrz  Paź  Lis  Gru
```

**Zadania** (napisz kod i wyświetl wynik za pomocą `print()`):

1. Sprzedaż w styczniu (indeks 0):
```python
# Podpowiedź: tablica[indeks]
```

2. Sprzedaż w grudniu (ostatni element):
```python
# Podpowiedź: tablica[-1]
```

3. Sprzedaż w Q1 (styczeń-marzec, indeksy 0-2):
```python
# Podpowiedź: tablica[start:stop] — stop NIE jest włączony
```

4. Sprzedaż w Q4 (październik-grudzień, ostatnie 3):
```python
# Podpowiedź: tablica[-3:]
```

5. Sprzedaż co drugi miesiąc (styczeń, marzec, maj...):
```python
# Podpowiedź: tablica[::krok]
```

6. Sprzedaż od tyłu (grudzień → styczeń):
```python
# Podpowiedź: tablica[::-1]
```

### Część B — Macierz 2D

```python
# Sprzedaż 4 produktów w 3 kwartałach
dane = np.array([
    [120, 145, 167],   # Produkt A
    [89,  102, 95],    # Produkt B
    [234, 267, 289],   # Produkt C
    [56,  78,  91],    # Produkt D
])
produkty = ['Produkt A', 'Produkt B', 'Produkt C', 'Produkt D']
kwartaly = ['Q1', 'Q2', 'Q3']
```

**Zadania:**

1. Sprzedaż Produktu A w Q2 (wiersz 0, kolumna 1):
```python
# Podpowiedź: macierz[wiersz, kolumna]
```

2. Cała sprzedaż Produktu C (wiersz 2, wszystkie kolumny):
```python
# Podpowiedź: macierz[wiersz] lub macierz[wiersz, :]
```

3. Sprzedaż wszystkich produktów w Q1 (wszystkie wiersze, kolumna 0):
```python
# Podpowiedź: macierz[:, kolumna]
```

4. Sprzedaż Produktów B i C w Q2 i Q3 (wiersze 1-2, kolumny 1-2):
```python
# Podpowiedź: macierz[w1:w2, k1:k2] — stop NIE jest włączony
```

### Sprawdzenie ✅

Odpowiedzi:
- A1: `120`, A2: `221`, A3: `[120, 135, 98]`, A4: `[143, 198, 221]`
- A5: `[120, 98, 167, 201, 156, 198]`, A6: `[221, 198, 143, ...]`
- B1: `145`, B2: `[234, 267, 289]`, B3: `[120, 89, 234, 56]`
- B4: `[[102, 95], [267, 289]]`

---

## Ćwiczenie 3: Operacje wektorowe — analiza biznesowa (25 min)

### Cel
Użyj operacji NumPy do rozwiązania problemów biznesowych. Samodzielna praca.

### Dane

```python
# Produkty w sklepie internetowym
nazwy = ['Laptop', 'Tablet', 'Smartfon', 'Słuchawki', 'Ładowarka',
         'Klawiatura', 'Mysz', 'Monitor', 'Kamera', 'Drukarka']

ceny = np.array([3499, 1899, 2499, 349, 89, 249, 129, 1499, 599, 899])
ilosci_magazyn = np.array([15, 42, 78, 156, 312, 89, 201, 23, 45, 34])
oceny_klientow = np.array([4.7, 4.2, 4.5, 4.8, 3.9, 4.1, 4.3, 4.6, 3.8, 3.5])
```

### Zadania

Każde zadanie w osobnej komórce z komentarzem Markdown.

**Zadanie 1:** Podstawowe statystyki cenowe
```python
# Średnia cena, najdroższy produkt, najtańszy produkt
# Podpowiedzi: .mean(), .max(), .min(), .argmax(), .argmin()
```

**Zadanie 2:** Wartość magazynu
```python
# Oblicz wartość każdego produktu (cena × ilość) i łączną wartość magazynu
# Podpowiedź: mnożenie tablic element-wise
```

**Zadanie 3:** Analiza cenowa
```python
# Ceny po rabacie 15% (promocja świąteczna)
# Ceny z VAT 23%
# Ile produktów kosztuje powyżej 1000 zł?
# Podpowiedź: rabat = ceny * 0.85, VAT = ceny * 1.23, zliczanie: (warunek).sum()
```

**Zadanie 4:** Filtrowanie
```python
# Produkty z oceną >= 4.5 — nazwy i ceny
# Produkty poniżej 200 zł — nazwy i ilości w magazynie
# Podpowiedź: maska = oceny_klientow >= 4.5, potem ceny[maska]
# Uwaga: nazwy to zwykła lista — zamień ją na np.array(nazwy), żeby użyć maski
```

**Zadanie 5:** Analiza zapasów
```python
# Produkty z niskim stanem magazynowym (< 30 szt.) — nazwy
# Łączna wartość tych produktów
# Ile % całego magazynu stanowią?
# Podpowiedź: wartosci = ceny * ilosci_magazyn, potem filtruj maską
```

**Zadanie 6 (bonus):** Analiza korelacji cena–ocena
```python
# Które produkty są "okazją" — ocena >= 4.5 i cena < 1000 zł? Wypisz nazwy i ceny.
# Jaka jest średnia cena produktów z oceną >= 4.0 vs < 4.0?
# Podpowiedź: łączenie warunków: (warunek1) & (warunek2)
```

### Sprawdzenie ✅

Kluczowe odpowiedzi:
- Średnia cena: **1171.0 zł**
- Najdroższy: **Laptop (3499 zł)**, najtańszy: **Ładowarka (89 zł)**
- Wartość magazynu: **549 465 zł**
- Produkty z oceną ≥ 4.5: Laptop, Smartfon, Słuchawki, Monitor
- Produkty < 30 szt.: Laptop (15), Monitor (23)
- Bonus — „okazje" (ocena ≥ 4.5 i cena < 1000): **Słuchawki** (349 zł, ocena 4.8)
- Bonus — średnia cena przy ocenie ≥ 4.0: **1446.14 zł**, przy < 4.0: **529.00 zł**

---

## Ćwiczenie 4: Benchmark — lista vs NumPy (15 min)

### Cel
Przekonaj się na własne oczy, jak szybki jest NumPy w porównaniu z listami.

### Benchmark

```python
import time

# Przygotowanie danych
rozmiar = 1_000_000
lista = list(range(rozmiar))
tablica = np.array(lista)

# Test 1: Pomnóż przez 2
start = time.perf_counter()
wynik_lista = [x * 2 for x in lista]
czas_lista = time.perf_counter() - start

start = time.perf_counter()
wynik_numpy = tablica * 2
czas_numpy = time.perf_counter() - start

print(f"=== Mnożenie ×2 ({rozmiar:,} elementów) ===")
print(f"Lista:  {czas_lista*1000:.1f} ms")
print(f"NumPy:  {czas_numpy*1000:.1f} ms")
print(f"NumPy jest {czas_lista/czas_numpy:.0f}× szybszy!")
```

```python
# Test 2: Suma
start = time.perf_counter()
suma_lista = sum(lista)
czas_lista = time.perf_counter() - start

start = time.perf_counter()
suma_numpy = tablica.sum()
czas_numpy = time.perf_counter() - start

print(f"\n=== Suma ({rozmiar:,} elementów) ===")
print(f"Lista:  {czas_lista*1000:.1f} ms")
print(f"NumPy:  {czas_numpy*1000:.1f} ms")
print(f"NumPy jest {czas_lista/czas_numpy:.0f}× szybszy!")
```

```python
# Test 3: Filtrowanie (elementy > 500000)
start = time.perf_counter()
filtr_lista = [x for x in lista if x > 500000]
czas_lista = time.perf_counter() - start

start = time.perf_counter()
filtr_numpy = tablica[tablica > 500000]
czas_numpy = time.perf_counter() - start

print(f"\n=== Filtrowanie > 500k ({rozmiar:,} elementów) ===")
print(f"Lista:  {czas_lista*1000:.1f} ms")
print(f"NumPy:  {czas_numpy*1000:.1f} ms")
print(f"NumPy jest {czas_lista/czas_numpy:.0f}× szybszy!")
```

### Podsumowanie benchmarku

Dodaj komórkę Markdown:
```markdown
## Wnioski z benchmarku
- NumPy jest **...×** szybszy w mnożeniu
- NumPy jest **...×** szybszy w sumowaniu
- NumPy jest **...×** szybszy w filtrowaniu
- Wniosek: przy dużych danych **zawsze** używaj NumPy zamiast list
```

---

## Ćwiczenie 5: Commit na GitHub (5 min)

```bash
cd C:\Users\student\python2
git add lab03_numpy.ipynb
git commit -m "L03: ćwiczenia NumPy — tablice, operacje, benchmark"
git push
```

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Tworzyć tablice NumPy (7 sposobów)
- ✅ Indeksować i slice'ować tablice 1D i 2D
- ✅ Wykonywać operacje wektorowe i agregacje
- ✅ Filtrować dane warunkami logicznymi
- ✅ Mierzyć i porównywać wydajność

**Na następnych zajęciach:** NumPy zaawansowane — broadcasting, reshape, algebra liniowa.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `IndexError: index out of bounds` | Indeksy zaczynają się od 0. Tablica 12-elementowa ma indeksy 0-11 |
| Nie wiem jak wybrać fragment tablicy | Slicing: `tablica[start:stop]` — stop NIE jest włączony. Np. `t[2:5]` → elementy 2, 3, 4 |
| Różnica `tablica[2:5]` vs `tablica[[2,5]]` | `[2:5]` = zakres (indeksy 2,3,4). `[[2,5]]` = konkretne pozycje (indeksy 2 i 5) |
| `ValueError: shape mismatch` | Sprawdź kształty tablic: `print(a.shape, b.shape)` — muszą być kompatybilne |
| Nie wiem czym jest `axis=0` vs `axis=1` | `axis=0` = operacja wzdłuż wierszy (w dół). `axis=1` = wzdłuż kolumn (w prawo) |
| `.argmax()` vs `.max()` | `.max()` zwraca wartość, `.argmax()` zwraca pozycję (indeks) tej wartości |
