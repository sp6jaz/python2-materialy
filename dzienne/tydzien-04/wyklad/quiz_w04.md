# Quiz W04 — NumPy zaawansowane

## Instrukcja
- 6 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W05)
- 2 pytania powtórkowe, 3 nowe

---

### Pytanie 1 (powtórka W03)
Mamy `dane = np.array([10, 20, 30, 40, 50])`. Co zwróci `dane[1:4]`?

A) `[10, 20, 30, 40]`
B) `[20, 30, 40]`
C) `[20, 30, 40, 50]`
D) `[10, 20, 30]`

---

### Pytanie 2 (powtórka W03)
Co robi `ceny.argmax()`?

A) Zwraca najwyższą cenę
B) Zwraca indeks najwyższej ceny
C) Sortuje ceny malejąco
D) Filtruje ceny powyżej średniej

---

### Pytanie 3
Co to jest broadcasting w NumPy?

A) Wysyłanie danych przez sieć
B) Mechanizm operacji na tablicach różnych kształtów
C) Sposób zapisywania tablic na dysk
D) Metoda kompresji danych

---

### Pytanie 4
Co zwraca `np.where(oceny >= 3.0, 'ZDAŁ', 'NIE ZDAŁ')`?

A) Liczbę osób, które zdały
B) Indeksy osób, które zdały
C) Tablicę z wartościami 'ZDAŁ' lub 'NIE ZDAŁ' dla każdego elementu
D) Średnią ocenę zdających

---

### Pytanie 5
Co robi `a.reshape(3, -1)` gdy tablica `a` ma 12 elementów?

A) Tworzy tablicę 3×(-1), co jest błędem
B) Tworzy tablicę 3×4, bo NumPy sam oblicza brakujący wymiar
C) Tworzy tablicę 3×12
D) Usuwa 1 element i tworzy tablicę 3×3

---

### Pytanie 6
Co zwróci `np.array([1, np.nan, 3]).mean()`?

A) 2.0
B) nan
C) 1.333
D) Błąd

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | B | Slicing [1:4] = elementy o indeksach 1, 2, 3 (stop NIE jest włączony). |
| 2 | B | argmax() zwraca INDEKS max, nie wartość. max() zwraca wartość. |
| 3 | B | Broadcasting pozwala np. mnożyć macierz 3×4 przez wektor 4 elementów. |
| 4 | C | where(warunek, True, False) — dla każdego elementu zwraca jedną z dwóch wartości. |
| 5 | B | -1 = "oblicz sam". 12 / 3 = 4, więc wynik to 3×4. |
| 6 | B | Jeden NaN "zaraża" cały wynik. Użyj `np.nanmean()` aby go zignorować. |
