---
description: Vytvoří denní report z transakcí v ./data/ a uloží do ./reports/
---

Tvůj úkol: vygenerovat **denní report** z transakcí.

## Postup

1. Načti soubor `data/transakce-vzor.csv`.
2. Pro **dnešní datum** (Europe/Prague):
   - Spočítej součet příjmů (kladné částky).
   - Spočítej součet výdajů (záporné částky).
   - Najdi top 3 transakce podle absolutní hodnoty.
3. Pokud pro dnešek nejsou žádná data, použij **poslední den**, který v souboru najdeš.
4. Výstup zapiš do `reports/<YYYY-MM-DD>.md` (datum dne, který reportuješ).

## Formát reportu

```markdown
# Denní report — <YYYY-MM-DD>

## Souhrn
- Příjmy: <X> Kč
- Výdaje: <Y> Kč
- Net: <X - Y> Kč

## Top 3 transakce
1. <popis> — <částka> Kč
2. <popis> — <částka> Kč
3. <popis> — <částka> Kč

## Poznámky
<případné anomálie nebo všimnutí>
```

## Pravidla

- Nikdy si nevymýšlej čísla — pokud něco nelze najít, napiš to.
- Reporty pojmenovávej `reports/<YYYY-MM-DD>.md`.
- Pokud report pro daný den už existuje, **přepiš** ho (předpokládáme, že nový běh je čerstvější).
- Po skončení napiš jednou větou, kolik transakcí jsi zpracoval.

## Notifikace

Po vytvoření reportu **nevolej** žádný tool — Stop hook v `.claude/settings.json` spustí notifikaci automaticky.
