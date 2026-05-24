# Quiz W12 — Statystyka: rozkłady i testy hipotez

**Temat:** Powtórka W11 (statystyka opisowa) + nowy materiał W12 (testy hipotez, p-value, CI, A/B test)
**Czas:** 5 minut | **Forma:** kartka lub Mentimeter

---

## Pytania (do wyświetlenia na projektorze — po jednym)

---

### Pytanie 1 (powtórka W11 — mediana vs średnia)

Dział HR raportuje wynagrodzenia 100 pracowników. Prezes zarabia 200 000 PLN/miesiąc, reszta 4 000–8 000 PLN. Która miara najlepiej opisuje „typowe wynagrodzenie" w tej firmie?

**A)** Średnia arytmetyczna — uwzględnia wszystkich

**B)** Dominanta — najczęstsze wynagrodzenie

**C)** Mediana — odporna na ekstremalną wartość prezesa

**D)** Rozstęp — pokazuje pełen zakres

**Odpowiedź: C** — Mediana (wartość środkowa po posortowaniu) jest odporna na wartości ekstremalne. Jedna pensja 200 000 PLN mocno zawyża średnią, ale nie zmienia mediany. GUS dlatego zawsze podaje mediany wynagrodzeń, nie średnie.

---

### Pytanie 2 (powtórka W11 — Pearson vs Spearman)

Pracownicy mają **rangi** zaszeregowania: junior (1), mid (2), senior (3), lead (4). Chcesz sprawdzić zależność rangi i wynagrodzenia. Którą korelację wybierasz?

**A)** Pearson — najpopularniejsza

**B)** Spearman — rangi to dane porządkowe, niekoniecznie liniowe; Spearman mierzy zależność monotoniczną

**C)** Obie dadzą ten sam wynik

**D)** Nie ma sensu liczyć korelacji — rangi nie są liczbami

**Odpowiedź: B** — Rangi są danymi porządkowymi: wiadomo która jest wyżej, ale **odstępy nie muszą być równe**. Pearson zakłada zależność **liniową** (równe odstępy ↔ równy przyrost). Spearman patrzy tylko czy **rośnie razem** — niezależnie od kształtu krzywej. Złota zasada: dla rang i danych porządkowych — Spearman.

---

### Pytanie 3 (nowy — interpretacja p-value)

Wynik testu: `p = 0.03`. Które ze zdań jest POPRAWNĄ interpretacją p-value?

**A)** Jest 3% szans, że H0 jest prawdziwa

**B)** Jest 97% szans, że H1 jest prawdziwa

**C)** Gdyby H0 była prawdziwa, takie albo bardziej skrajne dane zobaczylibyśmy w 3% przypadków

**D)** Efekt jest duży i wart wdrożenia

**Odpowiedź: C** — p-value to **warunkowe prawdopodobieństwo danych** pod założeniem H0: `P(dane | H0)`. NIE jest to `P(H0 | dane)` (to byłaby statystyka bayesowska, wymaga rozkładu apriori). Opcje A i B mylą kierunek warunkowania (M1). Opcja D myli p-value z effect size (M3). ASA Statement on p-values (2016) ostrzega przed dokładnie tymi błędami.

---

### Pytanie 4 (nowy — istotność statystyczna vs praktyczna)

Analiza A/B test: kontrol 5.00% konwersji, wariant 5.05%, n=50 000 per grupa, `p < 0.001`. Co rekomendujesz?

**A)** Wdrożyć — bardzo istotne statystycznie (p < 0.001)

**B)** Nie wdrażać — różnica względna +1% jest biznesowo niemal zerowa, nawet jeśli istotna statystycznie

**C)** Zwiększyć próbę do 100 000 dla pewności

**D)** Powtórzyć test — wynik wydaje się przypadkowy

**Odpowiedź: B** — Klasyczny przykład M3: istotność statystyczna ≠ istotność praktyczna. Przy ogromnej próbie (n=50 000) nawet mikroskopijny efekt (5.00 → 5.05) daje p < 0.001 dzięki wąskim przedziałom ufności. Trzeba sprawdzić **effect size** — w tym wypadku +0.05 pp bezwzględnie, +1% względnie. Koszt wdrożenia kampanii prawie na pewno przewyższa korzyść. Decyzja: nie wdrażać. Klucz: zawsze raportuj **trójką** (p + effect size + CI). To uzupełnienie demonstracji z Sekcji 0 wykładu, gdzie Firma A pokazała +9.5% przy podobnym mechanizmie.

---

### Pytanie 5 (nowy — przedział ufności)

95% CI dla średniego czasu obsługi klienta = [7.2, 8.4] minut. Które zdanie jest POPRAWNE?

**A)** 95% klientów jest obsługiwanych w 7.2–8.4 min

**B)** Jest 95% prawdopodobieństwa, że średnia = 7.8 min

**C)** Gdybyśmy powtórzyli badanie 100 razy, ~95 przedziałów objęłoby prawdziwą średnią

**D)** 95% to oznacza precyzję 95% — niedokładność 5%

**Odpowiedź: C** — Definicja CI 95% (frequentist): w 95% powtórzeń badania obliczony przedział obejmie prawdziwy parametr populacji. **CI dotyczy niepewności ESTYMATORA** (średniej), NIE rozrzutu danych ani prawdopodobieństwa punktu. Opcja A myli CI z kwartylem/percentylem (M4 — najczęstszy błąd). Opcja B myli CI z prawdopodobieństwem punktu. Opcja D nie ma sensu statystycznego.

---

### Pytanie 6 (nowy — wybór testu)

Masz dwie grupy klientów: 20 osób w grupie A i 25 osób w grupie B. Mierzysz czas reakcji aplikacji. Rozkład silnie prawoskośny (skewness = 2.4 w obu grupach). Chcesz porównać średnie czasy. Który test wybierasz?

**A)** Welch's t-test — bo to standard dla 2 grup niezależnych

**B)** Test chi-kwadrat — dla 2 grup

**C)** Mann-Whitney U — test nieparametryczny dla małej próby ze skośnymi danymi

**D)** Test korelacji Pearsona

**Odpowiedź: C** — Dla małej próby (n<30) i silnie skośnych danych (|skewness| > 1) Centralne Twierdzenie Graniczne (CLT) może nie wystarczyć do zapewnienia normalności rozkładu próby średniej. Wtedy używamy testu opartego na rangach: **Mann-Whitney U** dla 2 grup niezależnych (lub Wilcoxon dla sparowanych). Welch's t-test (A) byłby OK dla dużej próby lub mniejszej skośności. Chi² (B) jest dla zmiennych kategorialnych (M7). Pearson (D) mierzy korelację dwóch zmiennych ciągłych, nie różnicę między grupami.

---

## Klucz odpowiedzi (dla prowadzącego)

| Pytanie | Odpowiedź | Temat | Obala misconception |
|---------|-----------|-------|---------------------|
| 1 | C | W11 — mediana, odporność na outlierów | — |
| 2 | B | W11 — Pearson vs Spearman, dane porządkowe | — |
| 3 | C | W12 — definicja p-value | M1 |
| 4 | B | W12 — istotność statystyczna vs praktyczna | M3 |
| 5 | C | W12 — interpretacja CI 95% | M4 |
| 6 | C | W12 — wybór testu (parametryczny vs nieparametryczny) | M5 |

## Mapowanie pytań na cele Bloom

- P1, P2: Bloom 2-3 (rozumienie + zastosowanie z W11)
- P3: Bloom 3 (rozumienie definicji p-value)
- P4: Bloom 4 (krytyczna ocena: istotność statystyczna ≠ praktyczna)
- P5: Bloom 4 (rozróżnianie 4 interpretacji CI)
- P6: Bloom 4 (decyzja: jaki test wybrać)
