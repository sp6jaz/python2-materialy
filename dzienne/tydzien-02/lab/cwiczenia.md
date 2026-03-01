# L02 — Ćwiczenia laboratoryjne

## Temat: Jupyter Notebook i pierwsza eksploracja danych

**Programowanie w Pythonie II** | Laboratorium 2
**Czas:** 90 min | **Forma:** ćwiczenia praktyczne

---

## Przydatne materiały

| Temat | Link |
|-------|------|
| Jupyter Notebook — dokumentacja | https://jupyter-notebook.readthedocs.io/en/stable/ |
| Pandas — szybki start | https://pandas.pydata.org/docs/getting_started/intro_tutorials/ |
| Pandas — `read_csv()` | https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html |
| Pandas — `DataFrame.describe()` | https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html |
| Matplotlib — `pyplot` tutorial | https://matplotlib.org/stable/tutorials/pyplot.html |
| Dataset tips — opis | https://www.kaggle.com/datasets/jsphyg/tipping |

### Kolumny datasetu `tips`

| Kolumna | Opis | Typ |
|---------|------|-----|
| `total_bill` | Całkowita kwota rachunku (USD) | float |
| `tip` | Napiwek (USD) | float |
| `sex` | Płeć osoby płacącej | kategoria: Male/Female |
| `smoker` | Czy osoba pali | kategoria: Yes/No |
| `day` | Dzień tygodnia | kategoria: Thur/Fri/Sat/Sun |
| `time` | Pora posiłku | kategoria: Lunch/Dinner |
| `size` | Liczba osób przy stoliku | int |

---

## Ćwiczenie 1: Jupyter Notebook — opanuj narzędzie (20 min)

### Cel
Nauczysz się tworzyć notebook, używać komórek Code i Markdown, oraz poznasz najważniejsze skróty klawiszowe.

### Krok 1 — Utwórz notebook

1. Otwórz VS Code w katalogu projektu
2. `Ctrl+Shift+P` → wpisz "Create New Jupyter Notebook" → Enter
3. Wybierz kernel: kliknij "Select Kernel" → Python Environments → `.venv`
4. Zapisz jako `lab02_eksploracja.ipynb` (`Ctrl+S`)

### Krok 2 — Komórka kodu

Wpisz w pierwszą komórkę i uruchom (`Shift+Enter`):

```python
# Moja pierwsza komórka
print("Witaj w Jupyter Notebook!")
2 + 2
```

Zauważ: `print()` wypisuje tekst, ale notebook automatycznie wyświetla też wynik ostatniego wyrażenia (4).

### Krok 3 — Komórka Markdown

1. Kliknij na pustą komórkę pod wynikiem
2. Zmień typ na Markdown: kliknij "Code" w menu i wybierz "Markdown" (albo naciśnij `Esc` → `M`)
3. Wpisz:

```markdown
# Laboratorium 2 — Eksploracja danych

**Autor:** [Twoje imię]
**Data:** [dzisiejsza data]

## Cel
Wczytanie i eksploracja datasetu z danymi z restauracji.
```

4. Uruchom (`Shift+Enter`) — komórka się sformatuje

### Krok 4 — Przećwicz skróty

Wykonaj po kolei:

| Co zrobić | Jak |
|-----------|-----|
| Dodaj komórkę poniżej | `Esc` → `B` |
| Dodaj komórkę powyżej | `Esc` → `A` |
| Zmień na Markdown | `Esc` → `M` |
| Zmień na Code | `Esc` → `Y` |
| Usuń komórkę | `Esc` → `D D` (dwa razy D) |
| Cofnij usunięcie | `Esc` → `Z` |
| Uruchom i przejdź dalej | `Shift+Enter` |
| Uruchom i zostań | `Ctrl+Enter` |

### Sprawdzenie ✅

Twój notebook ma przynajmniej:
- 1 komórkę Markdown z nagłówkiem i opisem
- 2 komórki Code z uruchomionym kodem
- Wiesz jak dodawać i usuwać komórki

---

## Ćwiczenie 2: Wczytanie i poznanie danych (25 min)

### Cel
Wczytaj prawdziwy dataset i poznaj go używając metod Pandas.

### Krok 1 — Import bibliotek

Dodaj komórkę Markdown:
```markdown
## Krok 1: Import bibliotek
```

Dodaj komórkę Code:
```python
import pandas as pd
import matplotlib.pyplot as plt
```

### Krok 2 — Wczytaj dane

Komórka Markdown:
```markdown
## Krok 2: Wczytanie danych
Dataset: rachunki z restauracji (244 obserwacje, 7 zmiennych).
```

Komórka Code:
```python
df = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/tips.csv')
print(f"Dane wczytane: {df.shape[0]} wierszy, {df.shape[1]} kolumn")
```

### Krok 3 — Poznaj dane

Dodaj komórkę Markdown: `## Krok 3: Poznanie danych`

Każdą z poniższych metod uruchom w **osobnej komórce** (żeby widzieć wynik):

```python
# Pierwsze 5 wierszy
df.head()
```

```python
# Ostatnie 5 wierszy
df.tail()
```

```python
# Informacje o typach i brakujących danych
df.info()
```

```python
# Statystyki opisowe
df.describe()
```

```python
# Typy danych
df.dtypes
```

```python
# Nazwy kolumn
df.columns.tolist()
```

### Krok 4 — Napisz wnioski

Dodaj komórkę Markdown z wnioskami:

```markdown
## Wnioski z eksploracji
- Dataset zawiera ... wierszy i ... kolumn
- Kolumny numeryczne: ...
- Kolumny tekstowe: ...
- Brakujące wartości: ... (sprawdź wynik info())
- Średni rachunek wynosi ... $
```

### Sprawdzenie ✅

- Notebook ma minimum 8 komórek (Markdown + Code naprzemiennie)
- Wiesz ile wierszy i kolumn ma dataset
- Potrafisz powiedzieć jakie są typy danych w każdej kolumnie

---

## Ćwiczenie 3: Pytania biznesowe (25 min)

### Cel
Odpowiedz na pytania biznesowe korzystając z danych. To ćwiczenie wymaga samodzielnego myślenia.

### Kontekst
Jesteś analitykiem w restauracji. Menedżer zadaje ci pytania. Odpowiedz używając kodu.

Dodaj komórkę Markdown: `## Pytania biznesowe`

### Pytanie 1: Jaki był najwyższy rachunek?

Podpowiedź: `df['nazwa_kolumny'].max()`

```python
# Pytanie 1: Najwyższy rachunek
# Twój kod tutaj
```

### Pytanie 2: Ile rachunków obsłużono w każdym dniu tygodnia?

Podpowiedź: `df['nazwa_kolumny'].value_counts()`

```python
# Pytanie 2: Rachunki wg dnia
# Twój kod tutaj
```

### Pytanie 3: Jaki jest średni napiwek dla palaczy vs niepalących?

Podpowiedź: `df.groupby('kolumna')['inna_kolumna'].mean()`

```python
# Pytanie 3: Napiwki — palący vs niepalący
# Twój kod tutaj
```

### Pytanie 4: Jaki procent rachunku stanowi napiwek (średnio)?

Podpowiedź: Stwórz nową kolumnę! `df['nowa'] = df['a'] / df['b'] * 100`

```python
# Pytanie 4: Procent napiwku
# Twój kod tutaj
```

### Pytanie 5: Który dzień + pora (Lunch/Dinner) przynosi najwyższe rachunki?

Podpowiedź: `df.groupby(['kolumna1', 'kolumna2'])['kolumna3'].mean()`

```python
# Pytanie 5: Dzień + pora → rachunki
# Twój kod tutaj
```

### Sprawdzenie ✅

Oczekiwane odpowiedzi (sprawdź czy się zgadzają):
1. Najwyższy rachunek: **50.81 $**
2. Sobota ma najwięcej rachunków: **87**
3. Palący mają średnio wyższy napiwek (~3.01 $) niż niepalący (~2.99 $) — minimalna różnica
4. Średni procent napiwku: **~16.1%**
5. Najwyższe rachunki: niedziela, obiad (Dinner)

---

## Ćwiczenie 4: Pierwszy wykres + commit (10 min)

### Cel
Stwórz wykres i wypchnij notebook na GitHub.

### Krok 1 — Wykres

Dodaj komórkę Markdown: `## Wizualizacja`

```python
# Średni napiwek wg dnia tygodnia
df.groupby('day')['tip'].mean().plot(kind='bar', title='Średni napiwek wg dnia tygodnia')
plt.ylabel('Napiwek ($)')
plt.tight_layout()
plt.show()
```

### Krok 2 — Bonus: drugi wykres (jeśli masz czas)

```python
# Rozkład rachunków
df['total_bill'].plot(kind='hist', bins=20, title='Rozkład kwot rachunków', edgecolor='black')
plt.xlabel('Rachunek ($)')
plt.ylabel('Liczba rachunków')
plt.tight_layout()
plt.show()
```

### Krok 3 — Zapisz i commituj

```bash
git add lab02_eksploracja.ipynb
git commit -m "L02: eksploracja datasetu tips — pipeline analityczny"
git push
```

### Sprawdzenie ✅

- Na GitHubie widać notebook `lab02_eksploracja.ipynb`
- GitHub renderuje notebook z kodem, wynikami i wykresami
- Notebook zawiera komórki Markdown z opisami (nie sam kod!)

---

## Podsumowanie

Po dzisiejszych zajęciach umiesz:
- ✅ Tworzyć i nawigować po Jupyter Notebook (skróty, typy komórek)
- ✅ Wczytać dane z CSV do DataFrame
- ✅ Poznać dane: head, info, describe, dtypes, shape
- ✅ Odpowiadać na pytania biznesowe kodem
- ✅ Tworzyć proste wykresy

**Na następnych zajęciach:** NumPy — szybkie obliczenia na tablicach danych.

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| Notebook nie wyświetla wykresów | Dodaj `%matplotlib inline` jako pierwszą komórkę |
| `FileNotFoundError` przy `read_csv()` | Sprawdź URL — skopiuj cały link z instrukcji |
| `KeyError: 'kolumna'` | Sprawdź pisownię: `df.columns` pokaże nazwy kolumn |
| Nie wiem jak dodać nową komórkę | Naciśnij Esc → B (nowa komórka pod aktualną) lub Esc → A (nad) |
| Komórka nie wykonuje się | Naciśnij Shift+Enter lub Ctrl+Enter |
| `NameError: name 'df' is not defined` | Wykonaj komórkę z `df = pd.read_csv(...)` przed innymi |
