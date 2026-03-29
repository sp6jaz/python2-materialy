# Quiz W06 — Pandas: selekcja i filtrowanie

## Instrukcja
- 5 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W07)
- 2 pytania powtórkowe, 3 nowe

---

### Pytanie 1 (powtórka W05)
Co zwraca `df.describe()`?

A) Nazwy kolumn i typy danych
B) Statystyki opisowe (mean, std, min, max, kwartyle) kolumn liczbowych
C) Pierwszych 5 wierszy DataFrame
D) Liczbę brakujących wartości

---

### Pytanie 2 (powtórka W05)
Masz DataFrame z kolumną `'day'` zawierającą dni tygodnia. Jak sprawdzisz, ile rachunków przypada na każdy dzień?

A) `df['day'].describe()`
B) `df['day'].count()`
C) `df['day'].value_counts()`
D) `df['day'].unique()`

---

### Pytanie 3
Czym różni się `loc` od `iloc`?

A) `loc` działa szybciej, `iloc` wolniej
B) `loc` wybiera po etykiecie/nazwie, `iloc` po pozycji liczbowej
C) `loc` działa na Series, `iloc` na DataFrame
D) `loc` sortuje dane, `iloc` filtruje

---

### Pytanie 4
Jak poprawnie przefiltrować DataFrame żeby znaleźć wiersze, gdzie `cena > 100` **i** `kategoria == 'A'`?

A) `df[df['cena'] > 100 and df['kategoria'] == 'A']`
B) `df[(df['cena'] > 100) & (df['kategoria'] == 'A')]`
C) `df[df['cena'] > 100, df['kategoria'] == 'A']`
D) `df.filter(cena > 100, kategoria == 'A')`

---

### Pytanie 5
Jak uzyskać 5 wierszy z najwyższą wartością kolumny `'sprzedaz'`?

A) `df.sort_values('sprzedaz').head(5)`
B) `df.nlargest(5, 'sprzedaz')`
C) `df.top(5, 'sprzedaz')`
D) `df['sprzedaz'].max(5)`

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | B | describe() daje statystyki liczbowe. info() daje typy i braki. head() daje wiersze. |
| 2 | C | value_counts() zlicza wystąpienia każdej wartości. describe() daje statystyki liczbowe, count() daje łączną liczbę, unique() zwraca unikalne wartości (bez zliczania). |
| 3 | B | loc = Label (etykieta), iloc = Integer Location (pozycja). |
| 4 | B | Operator & (nie and!), każdy warunek w nawiasach. |
| 5 | B | nlargest(5, 'kolumna') — najkrótszy i najszybszy sposób. sort_values z ascending=False + head też działa, ale A ma ascending=True (domyślne). |
