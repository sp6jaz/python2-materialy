# Quiz W07 — Pandas: czyszczenie danych

## Instrukcja
- 5 pytań, jednokrotny wybór
- Czas: 5 minut (do wykorzystania na początku W08)
- 2 pytania powtórkowe (z W06), 3 nowe (o czyszczeniu)

---

### Pytanie 1 (powtórka W06)
Jak poprawnie przefiltrować DataFrame żeby znaleźć wiersze, gdzie `dzial == 'IT'` **lub** `dzial == 'HR'`?

A) `df[df['dzial'] == 'IT' or df['dzial'] == 'HR']`

B) `df[(df['dzial'] == 'IT') | (df['dzial'] == 'HR')]`

C) `df[df['dzial'].isequal(['IT', 'HR'])]`

D) `df[(df['dzial'] == 'IT') and (df['dzial'] == 'HR')]`

---

### Pytanie 2 (powtórka W06)
Jakie są dwie metody pozwalające wybrać TOP-5 najwyższych wartości kolumny `'wynagrodzenie'`?

A) `df.head(5)` oraz `df.largest(5)`

B) `df.sort_values('wynagrodzenie', ascending=False).head(5)` oraz `df.nlargest(5, 'wynagrodzenie')`

C) `df.max(5, 'wynagrodzenie')` oraz `df.sort_desc(5)`

D) `df.iloc[:5]` oraz `df.top(5)`

---

### Pytanie 3
Co robi `df.isna().sum()`?

A) Zwraca liczbę wierszy w DataFrame

B) Zwraca liczbę brakujących wartości (NaN) w każdej kolumnie

C) Usuwa wiersze z brakującymi wartościami

D) Zastępuje NaN wartością 0

---

### Pytanie 4
Kolumna `'cena'` zawiera wartości: `['100', '250', 'brak', '180', None]`. Które wywołanie bezpiecznie skonwertuje ją na liczby, zamieniając niemożliwe do konwersji wartości na NaN?

A) `df['cena'].astype(float)`

B) `df['cena'].astype(float, errors='ignore')`

C) `pd.to_numeric(df['cena'], errors='coerce')`

D) `float(df['cena'])`

---

### Pytanie 5
Co zwraca `df['kategoria'].str.title()`?

A) Zamienia wszystkie litery na wielkie

B) Zamienia pierwszą literę każdego słowa na wielką, pozostałe na małe

C) Usuwa spacje z tekstu

D) Zamienia wszystkie litery na małe

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | B | Operator `\|` (OR), każdy warunek w nawiasach. `or` nie działa z Series. `isin(['IT','HR'])` byłoby poprawne, ale tego nie ma w opcjach. |
| 2 | B | `sort_values(ascending=False).head(5)` i `nlargest(5, 'kol')` dają ten sam wynik. `nlargest` jest krótsze i szybsze. |
| 3 | B | `isna()` zwraca DataFrame True/False, `.sum()` sumuje True (=NaN) per kolumna. Wynik: ile NaN w każdej kolumnie. |
| 4 | C | `pd.to_numeric(errors='coerce')` — 'coerce' oznacza "zamień błędy na NaN" zamiast rzucać wyjątek. `astype(float)` wywali błąd przy 'brak'. |
| 5 | B | `str.title()` = Title Case — każde słowo z wielką literą. `str.upper()` = WSZYSTKIE WIELKIE. `str.lower()` = wszystkie małe. `str.strip()` usuwa spacje. |
