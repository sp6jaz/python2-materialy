# Quiz W05 — Pandas: Series i DataFrame

## Instrukcja
- 5 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W06)
- 2 pytania powtórkowe, 3 nowe

---

### Pytanie 1 (powtórka W04)
Co to jest broadcasting w NumPy?

A) Wysyłanie tablic przez sieć
B) Mechanizm operacji na tablicach różnych kształtów
C) Kompresja tablic do mniejszego rozmiaru
D) Sortowanie tablic wielowymiarowych

---

### Pytanie 2 (powtórka W04)
Mamy `a = np.arange(12)`. Co zwróci `a.reshape(4, -1)`?

A) Błąd — nie można użyć -1
B) Tablicę 4×3, bo NumPy oblicza brakujący wymiar
C) Tablicę 4×12
D) Tablicę 4×1

---

### Pytanie 3
Czym różni się Series od tablicy NumPy?

A) Series jest szybszy od NumPy
B) Series ma etykiety (indeks) oprócz wartości
C) Series może przechowywać tylko tekst
D) Series nie obsługuje operacji wektorowych

---

### Pytanie 4
Mamy `df = pd.read_csv('dane.csv')`. Co zwraca `df.info()`?

A) Pierwsze 5 wierszy danych
B) Statystyki opisowe (średnia, std, min, max)
C) Liczbę wierszy, kolumn, typy danych i liczbę wartości non-null
D) Nazwy kolumn jako listę

---

### Pytanie 5
Jak wybrać z DataFrame `df` kolumny `'cena'` i `'ilosc'` jednocześnie?

A) `df['cena', 'ilosc']`
B) `df[['cena', 'ilosc']]`
C) `df.select('cena', 'ilosc')`
D) `df.columns(['cena', 'ilosc'])`

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | B | Broadcasting rozciąga mniejszą tablicę, by kształty pasowały do operacji. |
| 2 | B | -1 = "oblicz sam". 12 / 4 = 3, więc wynik to 4×3. |
| 3 | B | Series = tablica NumPy + indeks (etykiety). Operacje wektorowe działają tak samo. |
| 4 | C | info() to "RTG danych" — rozmiar, typy, braki. describe() daje statystyki, head() daje wiersze. |
| 5 | B | Podwójne nawiasy [['a', 'b']] — wewnątrz jest lista nazw kolumn. |
