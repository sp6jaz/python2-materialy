# L12 — Ćwiczenia: A/B testing kampanii marketingowej

**Programowanie w Pythonie II** | Laboratorium 12
**Notebook studencki:** `lab12_ab_test.ipynb`
**Dataset:** generowany w kodzie (kampania e-mail marketingowa, 5000 klientów)
**Cel:** kompletny raport A/B test dla CMO — zastosowanie testów z W12 (t-test, chi², CI, power analysis)

---

## Start (Windows, laboratorium uczelniane)

```powershell
cd C:\Users\student\python2
.venv\Scripts\Activate.ps1
code .
```

Następnie w VS Code: **File → New File → `dzienne\lab12\lab12_ab_test.ipynb`**. Wybierz kernel `.venv`.

---

## Setup — uruchom jako pierwszą komórkę

```python
%matplotlib inline
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from statsmodels.stats.proportion import proportion_confint, confint_proportions_2indep
from statsmodels.stats.power import TTestIndPower

np.random.seed(42)
sns.set_theme(style='whitegrid', palette='colorblind')
```

---

## Generowanie datasetu (komórka 2)

Symulujemy realny A/B test kampanii e-mail marketingowej. Dwie grupy klientów: **kontrol** (stara wersja maila) i **wariant** (nowy temat + CTA).

```python
n_per_group = 2500
np.random.seed(42)

# KONTROL: niższa konwersja, mniejsza wartość zamówień
ctrl_kupil = np.random.binomial(1, 0.082, n_per_group)
ctrl_zamowienie = np.where(ctrl_kupil == 1,
                            np.random.gamma(4, 35, n_per_group),
                            0)
ctrl_wiek = np.random.gamma(8, 4, n_per_group).clip(18, 75).astype(int)
ctrl_seg = np.random.choice(['nowy', 'powracajacy'], n_per_group, p=[0.60, 0.40])

# WARIANT: wyższa konwersja, większa wartość
var_kupil = np.random.binomial(1, 0.105, n_per_group)
var_zamowienie = np.where(var_kupil == 1,
                           np.random.gamma(4, 40, n_per_group),
                           0)
var_wiek = np.random.gamma(8, 4, n_per_group).clip(18, 75).astype(int)
var_seg = np.random.choice(['nowy', 'powracajacy'], n_per_group, p=[0.60, 0.40])

df = pd.DataFrame({
    'grupa': ['kontrol'] * n_per_group + ['wariant'] * n_per_group,
    'kupil': np.concatenate([ctrl_kupil, var_kupil]),
    'wartosc_zamowienia': np.concatenate([ctrl_zamowienie, var_zamowienie]).round(2),
    'wiek': np.concatenate([ctrl_wiek, var_wiek]),
    'segment': np.concatenate([ctrl_seg, var_seg])
})

print(f'Dataset: {df.shape[0]} klientów')
print(df.head())
```

---

## Ćwiczenie 1 — Sanity check randomizacji A/B

**Cel:** sprawdzić, czy randomizacja kontrol/wariant nie zaburzyła rozkładu zmiennych demograficznych (wiek, segment). Klasyczna procedura **przed** głównymi testami.

### 1a. Test chi² niezależności: grupa × segment

```python
kontyngencja = pd.crosstab(df['grupa'], df['segment'])
print('Kontyngencja grupa × segment:')
print(kontyngencja)

chi2, p, dof, expected = stats.chi2_contingency(kontyngencja)
print(f'\nchi² = {chi2:.3f}, p = {p:.4f}, df = {dof}')
print(f'{"⚠️ RANDOMIZACJA ZABURZONA" if p < 0.05 else "✅ Randomizacja OK"}')
```

### 1b. Test t niezależny: średni wiek kontrol vs wariant

```python
wiek_ctrl = df[df['grupa'] == 'kontrol']['wiek']
wiek_var = df[df['grupa'] == 'wariant']['wiek']

result = stats.ttest_ind(wiek_ctrl, wiek_var, equal_var=False)
print(f'Średni wiek: kontrol = {wiek_ctrl.mean():.1f}, wariant = {wiek_var.mean():.1f}')
print(f'Welch t = {result.statistic:.3f}, p = {result.pvalue:.4f}')
print(f'{"⚠️ Wieki różne — selection bias" if result.pvalue < 0.05 else "✅ Wieki porównywalne"}')
```

### Sprawdzenie (Ćw 1)

Spodziewane wyniki: `p > 0.05` dla obu testów (randomizacja zadziałała). Jeśli `p < 0.05` — w realnym scenariuszu byłby to **sygnał problemu metodologicznego** (nielosowa rekrutacja, błąd implementacji).

---

## Ćwiczenie 2 — Główny test: konwersja A vs B

**Cel:** porównać wskaźniki konwersji w grupach. Raport **trójką**: p-value (chi²) + effect size (różnica + ryzyko względne) + 95% CI dla różnicy.

### 2a. Statystyki opisowe

```python
print('--- Konwersje per grupa ---')
print(df.groupby('grupa')['kupil'].agg(['count', 'sum', 'mean']).round(4))
```

### 2b. Chi² + CI Wilson per grupa

```python
n_ctrl = (df['grupa'] == 'kontrol').sum()
k_ctrl = df[df['grupa'] == 'kontrol']['kupil'].sum()
n_var = (df['grupa'] == 'wariant').sum()
k_var = df[df['grupa'] == 'wariant']['kupil'].sum()

ci_ctrl = proportion_confint(k_ctrl, n_ctrl, alpha=0.05, method='wilson')
ci_var = proportion_confint(k_var, n_var, alpha=0.05, method='wilson')

print(f'KONTROL: {k_ctrl/n_ctrl:.3%}, 95% CI = [{ci_ctrl[0]:.3%}, {ci_ctrl[1]:.3%}]')
print(f'WARIANT: {k_var/n_var:.3%}, 95% CI = [{ci_var[0]:.3%}, {ci_var[1]:.3%}]')

table = [[k_ctrl, n_ctrl - k_ctrl], [k_var, n_var - k_var]]
chi2, p, _, _ = stats.chi2_contingency(table)
print(f'\nchi² = {chi2:.3f}, p = {p:.5f}')
```

### 2c. Effect size: różnica + ryzyko względne + CI dla różnicy

```python
diff_abs = k_var/n_var - k_ctrl/n_ctrl
diff_rel = diff_abs / (k_ctrl/n_ctrl)

ci_diff = confint_proportions_2indep(k_var, n_var, k_ctrl, n_ctrl, method='wald')

print(f'Effect size:')
print(f'  Różnica bezwzględna: {diff_abs*100:+.2f} pp')
print(f'  Różnica względna   : {diff_rel:+.1%}')
print(f'  95% CI dla różnicy : [{ci_diff[0]*100:+.2f} pp, {ci_diff[1]*100:+.2f} pp]')
```

### Sprawdzenie (Ćw 2)

- `p << 0.001` (silne odrzucenie H0)
- Wariant ~2.3 pp wyższa konwersja (z ~8.2% do ~10.5%), +28% względnie
- 95% CI nie obejmuje 0 → kierunek efektu pewny

---

## Ćwiczenie 3 — Wartość zamówienia (tylko kupujący)

**Cel:** porównać średnią wartość zamówienia dla osób, które kupiły. Welch's t-test + Cohen's d + CI.

### 3a. Filtracja i statystyki

```python
ord_ctrl = df[(df['grupa'] == 'kontrol') & (df['kupil'] == 1)]['wartosc_zamowienia']
ord_var = df[(df['grupa'] == 'wariant') & (df['kupil'] == 1)]['wartosc_zamowienia']

print(f'KONTROL: n={len(ord_ctrl)}, mean={ord_ctrl.mean():.2f}, std={ord_ctrl.std(ddof=1):.2f}')
print(f'WARIANT: n={len(ord_var)}, mean={ord_var.mean():.2f}, std={ord_var.std(ddof=1):.2f}')
```

### 3b. Wizualizacja rozkładów

```python
fig, ax = plt.subplots(figsize=(10, 4))
ax.hist(ord_ctrl, bins=30, alpha=0.5, label='kontrol', color='steelblue', edgecolor='black')
ax.hist(ord_var, bins=30, alpha=0.5, label='wariant', color='orange', edgecolor='black')
ax.axvline(ord_ctrl.mean(), color='steelblue', linestyle='--', label=f'mean kontrol = {ord_ctrl.mean():.0f}')
ax.axvline(ord_var.mean(), color='orange', linestyle='--', label=f'mean wariant = {ord_var.mean():.0f}')
ax.set_xlabel('Wartość zamówienia [PLN]')
ax.set_ylabel('Liczba klientów')
ax.set_title('Rozkład wartości zamówień — kontrol vs wariant')
ax.legend()
plt.tight_layout()
plt.show()
```

### 3c. Welch's t-test + Cohen's d + CI

```python
tt = stats.ttest_ind(ord_var, ord_ctrl, equal_var=False, alternative='two-sided')

pooled_var = (ord_ctrl.var(ddof=1) + ord_var.var(ddof=1)) / 2
d = (ord_var.mean() - ord_ctrl.mean()) / np.sqrt(pooled_var)

diff_mean = ord_var.mean() - ord_ctrl.mean()
se_diff = np.sqrt(ord_var.var(ddof=1)/len(ord_var) + ord_ctrl.var(ddof=1)/len(ord_ctrl))
t_crit = stats.t.ppf(0.975, df=tt.df)
ci = (diff_mean - t_crit * se_diff, diff_mean + t_crit * se_diff)

print(f't = {tt.statistic:.3f}, p = {tt.pvalue:.4f}')
print(f'Różnica średnich: {diff_mean:+.2f} PLN')
print(f"Cohen's d        : {d:.3f}")
print(f'95% CI dla różnicy: [{ci[0]:+.2f}, {ci[1]:+.2f}] PLN')
```

### Sprawdzenie (Ćw 3)

- `p < 0.001` (silne odrzucenie H0)
- Średnia wartość zamówienia ~20 PLN wyższa w wariancie
- Cohen's d zwykle 0.2-0.4 (mały-średni efekt)
- 95% CI nie obejmuje 0 → kierunek efektu pewny

---

## Ćwiczenie 4 — Power analysis dla replikacji

**Cel:** zaplanować n potrzebne na **replikację** wyniku (kolejna kampania). Pytanie: ile klientów musimy zaprosić do testu, żeby z 80% szansą wykryć efekt d=0.2 (mały-średni)?

```python
power_analysis = TTestIndPower()

# Replikacja przy mniejszym efekcie (konserwatywnie d=0.2)
n_required = power_analysis.solve_power(effect_size=0.2, alpha=0.05, power=0.80)
print(f'Replikacja: efekt d=0.2, α=0.05, power=0.80')
print(f'Potrzebne n: {n_required:.0f} per grupa  →  łącznie {2*n_required:.0f} klientów')

# Tabela: dla różnych d
print('\nWymagane n per grupa dla różnych scenariuszy replikacji:')
for d in [0.1, 0.15, 0.2, 0.3, 0.5]:
    n = power_analysis.solve_power(effect_size=d, alpha=0.05, power=0.80)
    print(f"  Cohen's d = {d}  →  n = {n:>6.0f} per grupa")
```

### Sprawdzenie (Ćw 4)

- d=0.2 → ~394 per grupa (łącznie ~788)
- d=0.5 → ~64 per grupa (łącznie ~128)
- Im mniejszy efekt — tym większa próba potrzebna

---

## Ćwiczenie 5 — Sparowany test (paired)

**Cel:** porównać czas spędzony w aplikacji przed i po reaktywacji kampanii dla **tych samych** 40 klientów.

```python
np.random.seed(11)
n_users = 40
czas_przed = np.random.gamma(5, 2, n_users).round(1)  # min
poprawa = np.where(np.random.rand(n_users) < 0.6,
                   np.random.gamma(2, 0.5, n_users),
                   np.random.normal(0, 0.3, n_users))
czas_po = (czas_przed + poprawa).clip(1, 30).round(1)

print(f'Przed reaktywacją: mean = {czas_przed.mean():.2f} min, std = {czas_przed.std(ddof=1):.2f}')
print(f'Po reaktywacji   : mean = {czas_po.mean():.2f} min, std = {czas_po.std(ddof=1):.2f}')
print(f'Średnia różnica  : {(czas_po - czas_przed).mean():+.2f} min')

# Paired t-test
result = stats.ttest_rel(czas_po, czas_przed, alternative='greater')
print(f'\nPaired t-test (H1: czas_po > czas_przed):')
print(f'  t = {result.statistic:.3f}, p = {result.pvalue:.4f}')
print(f'  {"ODRZUĆ H0 — kampania zwiększyła zaangażowanie" if result.pvalue < 0.05 else "Brak podstaw do odrzucenia"}')
```

### Sprawdzenie (Ćw 5)

- p < 0.05 — reaktywacja zwiększyła czas w aplikacji
- Paired t-test jest mocniejszy niż independent (eliminuje zmienność MIĘDZY klientami)

---

## Ćwiczenie 6 — Raport końcowy dla CMO

**Cel:** napisać paragraf 6-8 zdań z rekomendacją wdrożenia. Zastosuj **trójkę raportową** (p + effect size + CI) dla każdej z 3 metryk.

### Szablon do uzupełnienia:

```
RAPORT A/B — KAMPANIA E-MAIL MARKETINGOWA
==========================================

Cel: porównanie nowej wersji maila (wariant) ze stałą wersją (kontrol).
Próba: 2500 klientów per grupa (n=5000 łącznie).

WYNIKI:

1. KONWERSJA:
   - Kontrol: ____% (95% CI: [____, ____])
   - Wariant: ____% (95% CI: [____, ____])
   - Różnica bezwzględna: +____ pp (95% CI: [____, ____])
   - Różnica względna: +____%
   - Istotność: chi² = ____, p = ____

2. WARTOŚĆ ZAMÓWIENIA (tylko kupujący):
   - Kontrol: ____ PLN (n=____)
   - Wariant: ____ PLN (n=____)
   - Różnica średnich: +____ PLN (95% CI: [____, ____])
   - Cohen's d: ____ (___ efekt)
   - Istotność: Welch's t = ____, p = ____

3. ZAANGAŻOWANIE (czas w aplikacji, paired):
   - Średnia różnica: +____ min
   - Paired t-test: p = ____

POWER ANALYSIS (replikacja):
   Dla wykrycia efektu d=0.2 z 80% szansą: ____ klientów per grupa.

REKOMENDACJA:
[Tutaj 3-4 zdania: wdrażać czy nie, na jakiej podstawie, jakie ryzyko, kiedy replikacja.]
```

### Sprawdzenie (Ćw 6)

Sprawdź czy Twój raport zawiera:
- ✅ Wszystkie 3 metryki z trójką (p + effect + CI)
- ✅ Effect size z interpretacją (mały/średni/duży)
- ✅ Power analysis dla replikacji
- ✅ Jasną rekomendację biznesową
- ✅ Ostrzeżenia (np. dotyczące generalizacji na inne segmenty)

---

## Commit + push

Po zakończeniu wszystkich ćwiczeń:

```powershell
cd C:\Users\student\python2
git add dzienne\lab12\
git commit -m "L12: A/B test kampanii marketingowej — t-test, chi-kwadrat, CI, power analysis"
git push
```

---

## Jeśli utkniesz

| Problem | Rozwiązanie |
|---------|-------------|
| `ModuleNotFoundError: statsmodels` | `uv pip install statsmodels` lub `pip install statsmodels` w aktywnym venv |
| Wyniki różne od `Sprawdzenia` | Sprawdź `np.random.seed(42)` na początku — bez tego dataset jest losowy |
| `proportion_confint` ImportError | `from statsmodels.stats.proportion import proportion_confint` (NIE `from statsmodels.stats import proportion_confint`) |
| `chi2_contingency` zwraca dziwny obiekt | W scipy ≥1.11 zwraca `Chi2ContingencyResult` — użyj `.statistic`, `.pvalue` zamiast unpacking 4 wartości |
| `equal_var=True` daje inne wyniki niż wykład | Wykład używa Welch's t-test (`equal_var=False`) — bezpieczniejszy domyślnie. Zawsze podawaj `equal_var=False` dla 2-sample. |
| `nan_policy` ostrzeżenie | Jeśli w danych są NaN: `stats.ttest_ind(g1, g2, equal_var=False, nan_policy='omit')` |
| Cohen's d ujemny | OK — znak zależy od kolejności argumentów. Interpretuj `\|d\|` (wartość bezwzględna) dla wielkości efektu. |
| `proportion_confint` zwraca tuple (low, high) | Tak, to OK. `(low, high) = proportion_confint(...)` lub `ci_low, ci_high = ...` |
| Wykres się nie wyświetla | Dodaj `plt.show()` po `plt.tight_layout()` |
| VS Code nie widzi kernela `.venv` | Ctrl+Shift+P → "Select Kernel" → wybierz `.venv\Scripts\python.exe` |

---

## Po laboratorium

**Cele Bloom 3-4 osiągnięte:**
- Stosujesz t-test (1-sample, 2-sample Welch, paired) i chi-kwadrat w kontekście biznesowym
- Obliczasz i interpretujesz 95% CI dla średniej i proporcji
- Raportujesz wynik A/B test trójką (p + effect size + CI)
- Wykonujesz power analysis dla planowania n
- Krytycznie oceniasz istotność praktyczną vs statystyczną

**Co dalej:** W13 — Zaawansowane biblioteki (scikit-learn, plotly, polars). Statystyka z W11+W12 stanie się fundamentem rozumienia uczenia maszynowego.
