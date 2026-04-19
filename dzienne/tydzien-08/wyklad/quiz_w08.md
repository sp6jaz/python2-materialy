# Quiz W08 — Pandas: łączenie i agregacja

## Instrukcja
- 6 pytań, jednokrotny wybór
- Czas: 6 minut (do wykorzystania na początku W09)
- 2 pytania powtórkowe z W07, 4 nowe z W08

---

### Pytanie 1 (powtórka W07 — czyszczenie danych)
Jak usunąć wiersze z brakującymi wartościami w DataFrame `df`?

A) `df.remove_nan()`
B) `df.dropna()`
C) `df.fillna()`
D) `df.clean()`

---

### Pytanie 2 (powtórka W07 — typy danych)
Jak sprawdzić, ile brakujących wartości (`NaN`) jest w każdej kolumnie DataFrame `df`?

A) `df.count_na()`
B) `df.missing()`
C) `df.isnull().sum()`
D) `df.describe()`

---

### Pytanie 3
Jaki rodzaj złączenia (`merge`) zwraca **tylko wiersze istniejące w obu** tabelach?

A) `how='left'`
B) `how='outer'`
C) `how='inner'`
D) `how='right'`

---

### Pytanie 4
Co robi `df.groupby('miasto')['sprzedaz'].sum()`?

A) Filtruje wiersze, gdzie miasto nie jest puste
B) Sumuje kolumnę `sprzedaz` dla każdej unikalnej wartości `miasto`
C) Tworzy nową kolumnę z sumą sprzedaży
D) Sortuje DataFrame po mieście, potem sumuje

---

### Pytanie 5
Jak połączyć dwa DataFrame o tej samej strukturze (te same kolumny) jeden pod drugim?

A) `df1.merge(df2)`
B) `pd.join(df1, df2)`
C) `pd.concat([df1, df2], ignore_index=True)`
D) `df1.join(df2, how='outer')`

---

### Pytanie 6
Które stwierdzenie o `pd.pivot_table()` jest **poprawne**?

A) Zgłasza błąd, gdy w danych są duplikaty kluczy
B) Jest aliasem dla `df.pivot()` — działa identycznie
C) Domyślnie agreguje duplikaty funkcją `mean` (można zmienić parametrem `aggfunc`)
D) Nie obsługuje parametru `margins` (sumy brzegowe)

---

## Odpowiedzi

| Pytanie | Odpowiedź | Wyjaśnienie |
|---------|-----------|-------------|
| 1 | B | `dropna()` usuwa wiersze z NaN. `fillna()` uzupełnia braki wartością. |
| 2 | C | `isnull()` tworzy maskę boolowską, `sum()` liczy True (czyli NaN) per kolumna. |
| 3 | C | `inner` = część wspólna — tylko klucze obecne w obu tabelach. `left` zachowuje wszystkie z lewej, `right` z prawej, `outer` = unia. |
| 4 | B | `groupby` dzieli DataFrame na grupy po `miasto`, `.sum()` agreguje każdą grupę. |
| 5 | C | `pd.concat([df1, df2])` skleja wiersze. `ignore_index=True` resetuje indeks. `merge` łączy po kluczu, nie skleja jeden pod drugim. |
| 6 | C | `pivot_table` **agreguje duplikaty** (domyślnie `mean`), wspiera `aggfunc` i `margins`. Funkcja `pivot()` zgłasza błąd przy duplikatach — to główna różnica. |
