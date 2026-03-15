# Quiz W03 — NumPy podstawy

## Instrukcja
- 5 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W04 jako spaced repetition)
- 2 pytania powtórkowe, 3 nowe

---

### Pytanie 1 (powtórka W02)
Co zwraca `df.head()`?

A) Pierwsze 5 wierszy DataFrame
B) Statystyki opisowe
C) Typy danych w kolumnach
D) Liczbę wierszy i kolumn

---

### Pytanie 2 (powtórka W02)
Jaki jest pierwszy krok w pipeline analitycznym?

A) Wczytanie danych
B) Sformułowanie pytania biznesowego
C) Stworzenie wykresu
D) Czyszczenie danych

---

### Pytanie 3
Co zwraca `np.arange(0, 10, 2)`?

A) `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`
B) `[0, 2, 4, 6, 8]`
C) `[0, 2, 4, 6, 8, 10]`
D) `[2, 4, 6, 8, 10]`

---

### Pytanie 4
Mamy `ceny = np.array([100, 200, 300])`. Co zwróci `ceny[ceny > 150]`?

A) `[True, True, True]`
B) `[False, True, True]`
C) `[200, 300]`
D) `2`

---

### Pytanie 5
Co oznacza `axis=0` w `sprzedaz.sum(axis=0)`?

A) Suma w prawo (po wierszach)
B) Suma w dół (po kolumnach)
C) Suma wszystkich elementów
D) Suma tylko pierwszego wiersza

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | A | head() domyślnie zwraca 5 pierwszych wierszy. head(10) zwróci 10. |
| 2 | B | Pipeline zaczyna się od pytania — bez pytania nie wiadomo czego szukać. |
| 3 | B | arange(start, stop, step): od 0 do 10 (bez 10), co 2. |
| 4 | C | ceny > 150 daje [False, True, True], a ceny[...] filtruje → [200, 300]. |
| 5 | B | axis=0 = "w dół" (suma per kolumna), axis=1 = "w prawo" (suma per wiersz). |
