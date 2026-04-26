# Quiz W09 — Matplotlib: podstawy wizualizacji

## Instrukcja
- 5 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W10)
- 2 pytania powtórkowe z W08, 3 nowe z W09

---

### Pytanie 1 (powtórka W08 — merge)
Jaki typ złączenia (`merge`) zachowuje **wszystkie wiersze z lewej** tabeli, uzupełniając brakujące wartości z prawej jako `NaN`?

A) `how='inner'`
B) `how='outer'`
C) `how='left'`
D) `how='right'`

---

### Pytanie 2 (powtórka W08 — groupby)
Co robi poniższy kod?
```python
df.groupby('kategoria').agg(
    suma=('cena', 'sum'),
    srednia=('cena', 'mean')
)
```

A) Filtruje wiersze według kategorii i oblicza sumę
B) Grupuje DataFrame po kolumnie `kategoria` i oblicza sumę oraz średnią ceny dla każdej grupy — z nazwanymi kolumnami wynikowymi
C) Tworzy dwie nowe kolumny `suma` i `srednia` w oryginalnym DataFrame
D) Łączy dwie tabele: `kategoria` i `cena`

---

### Pytanie 3
Jaką funkcją tworzy się obiektowy układ wielu wykresów w Matplotlib?

A) `plt.create_subplots(2, 2)`
B) `fig, ax = plt.subplots(2, 2)`
C) `plt.figure(rows=2, cols=2)`
D) `ax = plt.axes(layout='2x2')`

---

### Pytanie 4
Co oznacza parametr `alpha=0.5` w `ax.scatter(..., alpha=0.5)`?

A) Rozmiar punktów — połowa domyślnego
B) Grubość krawędzi punktu
C) Przezroczystość punktów — 50% przezroczystości
D) Rozstaw między punktami

---

### Pytanie 5
Jaką metodę Pandas wywołujemy żeby narysować wykres słupkowy wprost z Series lub DataFrame?

A) `df.draw(kind='bar')`
B) `plt.from_df(df, 'bar')`
C) `df.plot(kind='bar')`
D) `df.chart('bar')`

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | C | `how='left'` zachowuje wszystkie wiersze z lewej tabeli. Brakujące dopasowania z prawej → NaN. `inner` = tylko wspólne, `outer` = wszystkie z obu, `right` = wszystkie z prawej. |
| 2 | B | Named aggregation (`nazwa=('kolumna', 'funkcja')`) grupuje po kategorii i tworzy nowy DataFrame z nazwanymi kolumnami `suma` i `srednia`. Oryginalny DataFrame nie jest modyfikowany. |
| 3 | B | `fig, ax = plt.subplots(rows, cols)` zwraca krotkę (Figure, tablica Axes). Dla `(2,2)` — `ax` ma kształt 2×2, dostęp przez `ax[wiersz, kolumna]`. |
| 4 | C | `alpha` kontroluje przezroczystość: 0.0 = niewidoczny, 1.0 = pełny kolor. `alpha=0.5` = 50% przezroczystości, przydatne gdy punkty się nakładają (density visualization). |
| 5 | C | `df.plot(kind='bar')` to wbudowana metoda Pandas korzystająca z Matplotlib pod spodem. `kind` może być: `'line'`, `'bar'`, `'barh'`, `'hist'`, `'scatter'`, `'pie'`, `'box'`. |
