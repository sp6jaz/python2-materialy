# Quiz W13 — Zaawansowane biblioteki: scikit-learn, Plotly, Polars

**Temat:** Powtórka W12 (testy hipotez, rozkład normalny) + nowy materiał W13 (scikit-learn, Plotly, Polars)
**Czas:** 5 minut | **Forma:** kartka lub Mentimeter

> **Dla prowadzącego:** pytania 1-2 to spaced repetition z W12 (odpowiedzi omawiamy od razu), pytania 3-5 dotyczą dzisiejszego materiału — wracamy do nich na końcu zajęć.

---

## Pytania (do wyświetlenia na projektorze — po jednym)

---

### Pytanie 1 (powtórka W12 — testy hipotez)

Wykonujesz test t-Studenta i otrzymujesz **p-wartość = 0.12** przy poziomie istotności α = 0.05. Co robisz?

**A)** Odrzucasz hipotezę zerową H₀ — wynik jest istotny statystycznie

**B)** Odrzucasz hipotezę alternatywną H₁ — udowodniłeś, że efektu nie ma

**C)** Nie ma podstaw do odrzucenia H₀ — różnica może być przypadkowa (p > α)

**D)** Powtarzasz test z większym α = 0.15, aż p < α

**Odpowiedź: C** — Gdy p > α, nie odrzucamy H₀. Nie udowadniamy tym samym, że efektu nie ma (błąd B) — może po prostu być za mała próba. Manipulowanie α po fakcie (D) to p-hacking — poważny błąd metodologiczny. Właściwa interpretacja: brak wystarczających dowodów do odrzucenia H₀.

---

### Pytanie 2 (powtórka W12 — rozkład normalny)

Wzrost dorosłych Polaków ma rozkład normalny N(175, 7²). Jaki procent populacji ma wzrost **powyżej 182 cm**?

**A)** Około 15.9% — powyżej 1 odchylenia standardowego od średniej

**B)** Około 2.3% — powyżej 2 odchyleń standardowych od średniej

**C)** Około 50% — połowa populacji

**D)** Około 68% — zasada empiryczna

**Odpowiedź: A** — 182 = 175 + 1×7, czyli dokładnie 1 odchylenie standardowe (SD) powyżej średniej. Według zasady 68-95-99.7, 68% leży w przedziale ±1σ, więc 32% poza nim, a 16% powyżej. Dokładnie: `stats.norm.sf(182, 175, 7)` ≈ 0.159. Odpowiedź B (2.3%) byłaby dla 2σ = 189 cm.

---

### Pytanie 3 (nowy — scikit-learn, train/test split)

Dlaczego przed trenowaniem modelu uczenia maszynowego dzielimy dane na zbiór treningowy i testowy?

**A)** Żeby mieć mniej danych do trenowania — szybszy trening

**B)** Scikit-learn wymaga tego technicznie — bez podziału biblioteka zgłasza błąd

**C)** Zbiór testowy poprawia dokładność modelu podczas treningu

**D)** Żeby ocenić, jak model radzi sobie z **nowymi, niewidzianymi danymi** — testujemy generalizację (radzenie sobie na nowych danych)

**Odpowiedź: D** — Model „uczący się” na wszystkich danych może zapamiętać przykłady (przeuczenie, overfitting) i świetnie radzić sobie na danych treningowych, ale fatalnie na nowych. Zbiór testowy symuluje „produkcję” — dane, których model nigdy nie widział. To kluczowa zasada ML: mierzymy generalizację, nie zapamiętywanie.

---

### Pytanie 4 (nowy — Plotly vs Matplotlib)

Jaka jest kluczowa zaleta wykresów Plotly Express w porównaniu z Matplotlib?

**A)** Plotly rysuje wykresy szybciej — mniejsze zużycie CPU

**B)** Wykresy Plotly są **interaktywne** — hover (podpowiedź po najechaniu), zoom (przybliżanie), pan (przesuwanie), eksport do HTML — bez dodatkowego kodu

**C)** Plotly obsługuje wyłącznie wykresy słupkowe i liniowe

**D)** Plotly wymaga mniej importów — jedna linia zamiast trzech

**Odpowiedź: B** — Kluczowa różnica: Matplotlib generuje statyczne obrazy (PNG/SVG), Plotly generuje interaktywny HTML z JavaScript. W Jupyter Notebook możesz najechać myszą i zobaczyć dokładne wartości (hover), odfiltrować serie, przybliżyć zakres (zoom), a gotowy wykres zapisać jako stronę WWW (`fig.write_html`). Dla dashboardów biznesowych Plotly jest znacznie efektywniejszy. Uwaga: to nie znaczy, że Plotly *zastępuje* Matplotlib — do druku i publikacji statyczny obraz bywa lepszy.

---

### Pytanie 5 (nowy — Polars)

Twój skrypt w Pandas przetwarza 10 mln wierszy przez 4 minuty. Kolega radzi przepisać go na Polars. Dlaczego Polars bywa kilkukrotnie szybszy od Pandas?

**A)** Polars automatycznie próbkuje dane — liczy tylko na losowym podzbiorze

**B)** Polars kompresuje dane, więc jest ich fizycznie mniej do policzenia

**C)** Polars (napisany w Rust) liczy **wielowątkowo**, używa **formatu kolumnowego** i potrafi **leniwie** optymalizować całe zapytanie

**D)** Polars przenosi obliczenia na kartę graficzną (GPU) zamiast procesora

**Odpowiedź: C** — Polars zawdzięcza szybkość trzem rzeczom: wielowątkowości (używa wszystkich rdzeni CPU naraz), kolumnowemu układowi danych w pamięci oraz leniwej ewaluacji (`.lazy()` buduje plan, który optymalizator przekształca przed wykonaniem). Nie próbkuje (A — to dałoby błędne wyniki), nie zmniejsza liczby wierszy przez kompresję (B), nie wymaga GPU (D).

---

## Klucz odpowiedzi (dla prowadzącego)

| Pytanie | Odpowiedź | Temat |
|---------|-----------|-------|
| 1 | C | W12 — interpretacja p-wartości, brak odrzucenia H₀ |
| 2 | A | W12 — rozkład normalny, zasada 68-95-99.7 |
| 3 | D | W13 — train/test split, generalizacja modelu |
| 4 | B | W13 — Plotly interaktywność vs Matplotlib |
| 5 | C | W13 — Polars: Rust, wielowątkowość, format kolumnowy, lazy |

**Rozkład pozycji odpowiedzi:** C, A, D, B, C (A:1, B:1, C:2, D:1 — bez dominującej pozycji).
