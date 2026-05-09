# Quiz W11 — Statystyka opisowa w Pythonie

**Temat:** Powtórka W10 (Seaborn, dashboardy) + nowy materiał W11 (statystyka opisowa, scipy.stats)
**Czas:** 5 minut | **Forma:** kartka lub Mentimeter

---

## Pytania (do wyświetlenia na projektorze — po jednym)

---

### Pytanie 1 (powtórka W10 — Seaborn)

Które zdanie poprawnie opisuje różnicę między `sns.boxplot()` a `sns.violinplot()`?

**A)** `boxplot` pokazuje rozkład prawdopodobieństwa jako krzywą gęstości, `violinplot` rysuje tylko medianę i kwartyle

**B)** `boxplot` pokazuje medianę, kwartyle i outliery jako punkty. `violinplot` dodaje do tego kształt rozkładu (krzywą KDE) — widać gdzie skupiają się dane

**C)** `violinplot` i `boxplot` dają identyczne informacje, różnią się tylko stylem

**D)** `boxplot` wymaga parametru `hue=`, `violinplot` nie obsługuje podziału na grupy

**Odpowiedź: B** — `boxplot` kompaktowo pokazuje pięć liczb: minimum, Q1, mediana, Q3, maksimum — plus outliery jako punkty. `violinplot` rozszerza to o krzywą KDE (jąderkowe szacowanie gęstości), dzięki czemu widać czy rozkład jest jednomodalny, bimodalny, skośny. Oba obsługują `hue=`. Oba niosą różne informacje — dlatego czasem łączymy je razem (`inner='box'` w violinplot).

---

### Pytanie 2 (powtórka W10 — GridSpec)

Chcesz zbudować dashboard: 1 duży wykres na górze (pełna szerokość), 2 mniejsze na dole obok siebie. Ile wierszy i kolumn ma GridSpec?

**A)** `GridSpec(1, 2)` — 1 wiersz, 2 kolumny

**B)** `GridSpec(2, 1)` — 2 wiersze, 1 kolumna

**C)** `GridSpec(2, 2)` — 2 wiersze, 2 kolumny; górny panel: `gs[0, :]`, dolne: `gs[1, 0]` i `gs[1, 1]`

**D)** `GridSpec(3, 2)` — 3 wiersze, 2 kolumny

**Odpowiedź: C** — Potrzebujemy 2 wiersze i 2 kolumny: `GridSpec(2, 2)`. Górny panel obejmuje cały pierwszy wiersz: `gs[0, :]` (dwukropek = wszystkie kolumny). Dolny lewy: `gs[1, 0]`, dolny prawy: `gs[1, 1]`. GridSpec(2, 1) dałby tylko dwa wiersze bez możliwości umieszczenia dwóch paneli obok siebie na dole.

---

### Pytanie 3 (nowy — miary centralne)

Dział HR firmy raportuje wynagrodzenia 100 pracowników. Wiadomo, że prezes zarabia 200 000 PLN/miesiąc, reszta pracowników 4 000–8 000 PLN. Która miara najlepiej opisuje "typowe wynagrodzenie" w tej firmie?

**A)** Średnia arytmetyczna — bo uwzględnia wszystkich pracowników

**B)** Dominanta — bo najczęściej powtarzające się wynagrodzenie jest najbardziej typowe

**C)** Mediana — bo jest odporna na ekstremalną wartość wynagrodzenia prezesa

**D)** Rozstęp — bo pokazuje pełen zakres wynagrodzeń

**Odpowiedź: C** — Mediana (wartość środkowa po posortowaniu) jest odporna na wartości ekstremalne. Jedna pensja 200 000 PLN przy 99 pensjach w zakresie 4 000–8 000 mocno zawyża średnią, ale nie zmienia mediany — pozostaje ona w okolicach 5 000–6 000 PLN. GUS dlatego zawsze podaje mediany, nie średnie wynagrodzeń. Dominanta może być użyteczna dla danych dyskretnych, ale nie daje informacji o typowym poziomie dla ciągłych danych o wynagrodzeniach.

---

### Pytanie 4 (nowy — korelacja)

Wyniki z analizy danych sprzedażowych: korelacja Pearsona między wydatkami na marketing a przychodami wynosi r = 0.82, p = 0.0003. Co z tego wynika?

**A)** Większe wydatki na marketing **powodują** wyższe przychody — należy natychmiast zwiększyć budżet marketingowy

**B)** Istnieje silna, statystycznie istotna **zależność liniowa** między marketingiem a przychodami, ale sama korelacja nie dowodzi przyczynowości

**C)** r = 0.82 to słaba korelacja — nic z niej nie wynika

**D)** p = 0.0003 oznacza, że korelacja jest niepewna i nie należy na niej polegać

**Odpowiedź: B** — r = 0.82 to silna korelacja (próg 0.7). p = 0.0003 << 0.05 — statystycznie istotna, bardzo mała szansa że wynikła z przypadku. Ale: **korelacja ≠ przyczynowość**. Może być trzecia zmienna (np. sezon: latem i reklamy i przychody rosną). Należy potwierdzić przyczynowość eksperymentem (test A/B). Opcja C jest błędna: r > 0.7 to silna korelacja. Opcja D: p małe oznacza, że korelacja jest istotna, nie niepewna.

---

### Pytanie 5 (nowy — wykrywanie outlierów)

**Hipotetyczna firma** (przykład rachunkowy): rozkład wynagrodzeń ma Q1 = 6 000 PLN i Q3 = 10 000 PLN. Metodą IQR (mnożnik 1.5) — która z poniższych pensji zostanie zaklasyfikowana jako outlier?

Dane: IQR = Q3 − Q1 = 4 000 PLN

**A)** 4 500 PLN — bo jest poniżej Q1

**B)** 15 000 PLN — bo przekracza średnią

**C)** 2 000 PLN — bo jest poniżej dolnej granicy Q1 − 1.5 × IQR = 6 000 − 6 000 = 0 PLN... więc 2 000 jest powyżej granicy

**D)** 16 500 PLN — bo przekracza górną granicę Q3 + 1.5 × IQR = 10 000 + 6 000 = 16 000 PLN

**Odpowiedź: D** — Obliczenia: IQR = 10 000 − 6 000 = 4 000 PLN. Dolna granica: 6 000 − 1.5 × 4 000 = 6 000 − 6 000 = 0 PLN. Górna granica: 10 000 + 1.5 × 4 000 = 10 000 + 6 000 = 16 000 PLN. Outlier: wartość < 0 PLN lub > 16 000 PLN. 16 500 PLN przekracza 16 000 PLN → outlier. 4 500 PLN jest między 0 a 16 000 → normalna. 15 000 PLN: poniżej 16 000 → normalna (choć powyżej Q3). Opcja C: 2 000 PLN jest powyżej dolnej granicy 0 PLN → nie jest outlierem.

---

### Pytanie 6 (nowy — wybór Pearson vs Spearman)

Pracownicy firmy mają **rangi** zaszeregowania: junior (1), mid (2), senior (3), lead (4). Chcesz sprawdzić zależność między rangą a wynagrodzeniem. Którą korelację wybierasz?

**A)** Pearson — bo to najpopularniejsza miara

**B)** Spearman — bo rangi to dane porządkowe, niekoniecznie liniowe; Spearman mierzy zależność monotoniczną

**C)** Obie dadzą ten sam wynik, więc dowolna

**D)** Nie ma sensu liczyć korelacji — rangi nie są liczbami

**Odpowiedź: B** — Rangi (junior/mid/senior/lead = 1, 2, 3, 4) to **dane porządkowe** — wiadomo która jest wyżej, ale **odstępy nie muszą być równe** (lead może zarabiać 2× więcej niż senior, a senior tylko 1.2× więcej niż mid). Pearson zakłada zależność **liniową** (równe odstępy ↔ równy przyrost). Spearman patrzy tylko czy **rośnie razem** — niezależnie od kształtu krzywej. Złota zasada: dla rang i danych porządkowych wybierz **Spearman**. Opcja D jest błędna: korelacja na rangach jest dokładnie tym co oblicza Spearman.

---

## Klucz odpowiedzi (dla prowadzącego)

| Pytanie | Odpowiedź | Temat |
|---------|-----------|-------|
| 1 | B | W10 — boxplot vs violinplot |
| 2 | C | W10 — GridSpec, układ paneli |
| 3 | C | W11 — mediana, odporność na outlierów |
| 4 | B | W11 — korelacja ≠ przyczynowość, p-value |
| 5 | D | W11 — metoda IQR, obliczenia granic |
| 6 | B | W11 — Pearson vs Spearman, dane porządkowe |
