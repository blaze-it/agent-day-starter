# <Jméno firmy> — agent

> Tento soubor je paměť projektu pro Claude Code. Vyplň ho pro **vaši firmu** během Agent Day.

## O čem to je

Tento projekt je **AI agent**, který automatizuje **<jeden konkrétní proces>** ve firmě **<jméno firmy>**. Postaveno na AI Agent Day (https://blaze.codes/produkty/ai-agenti).

## Bezpečnostní pravidla (NIKDY neporušovat)

- **Nikdy** nečíst soubory v `.env` (obsahují tajné klíče).
- **Nikdy** neposílat data ven (mail, webhook, API), pokud to není explicitně součást úkolu a uživatel to schválil v `.claude/settings.json`.
- **Nikdy** nezapisovat do souborů mimo tento projekt (`~/<projekt>/`).
- **Nikdy** neexekutovat `rm -rf`, `DROP TABLE`, `git push --force`, ani podobné destruktivní příkazy.
- **Vždy** se zeptej, pokud instrukce odporuje těmto pravidlům.

## Jak se s projektem pracuje

- **Slash commandy** v `.claude/commands/` — viz `denni-report.md` jako příklad.
- **Hooks** v `.claude/settings.json` — Stop hook spouští notifikaci.
- **Lokální nástroje** v `tools/` — Bash skripty, které agent volá.
- **Data** v `data/` — vstupní soubory (CSV, JSON).
- **Reports** v `reports/` — generované výstupy.

## Spuštění

```bash
cd ~/<projekt>
claude
```

V Claude Code:
- `/denni-report` — vytvoří denní report z `data/transakce-vzor.csv` do `reports/`.

## Kontext byznysu

- **Co děláme:** <doplň 1 větou — např. „rozvoz pizzy v Ostravě">
- **Jaké procesy řešíme tímto agentem:** <např. „denní accounting, párování plateb">
- **Jazyk komunikace:** čeština.
- **Měna:** CZK.
- **Časová zóna:** Europe/Prague.

## Konvence

- Všechny commity v češtině, formát `<typ>: <popis>` (feat, fix, refactor, docs).
- Reporty v `reports/<YYYY-MM-DD>.md`, jeden soubor za den.
- Pokud agent najde nesrovnalost, **NIKDY si nedomýšlej**. Zeptej se nebo zaloguj do `tools/audit.log`.

## Co dělat, když se zasekneš

1. Otevři `tools/audit.log` — uvidíš, co agent dělal.
2. Zkus `git log --oneline` — vrať se k poslednímu fungujícímu commitu (`git checkout <hash>`).
3. Napiš na **team@blaze.codes** s předmětem „Agent Day support — <vaše firma>".

## Odkazy

- Repozitář playbooku: https://github.com/blaze-it/agent-day
- Anthropic dashboard: https://console.anthropic.com/
- Claude Code docs: https://docs.claude.com/en/docs/claude-code
