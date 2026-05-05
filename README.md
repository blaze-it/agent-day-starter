# Starter agent

Minimální funkční Claude Code projekt — kostra, kterou na **AI Agent Day** přizpůsobíme vašemu procesu.

## Co je uvnitř

```
starter-agent/
├── .claude/
│   ├── settings.json         povolení (allowlist) + Stop hook
│   └── commands/
│       └── denni-report.md   ukázkový slash command
├── data/
│   └── transakce-vzor.csv    vzorová data pro demo
├── reports/                  sem agent zapisuje výstupy
├── tools/
│   ├── notify.sh             notifikace přes osascript (macOS)
│   └── odeslat-zpravu.sh     univerzální „pošli někam zprávu"
├── CLAUDE.md                 paměť projektu pro Claude
└── README.md                 tento soubor
```

## Jak to spustit

1. Mít nainstalovaný Claude Code (viz `playbook/02-installation.md`).
2. V této složce: `claude`
3. V Claude Code napiš: `/denni-report`
4. Po dokončení uvidíš:
   - Soubor v `reports/<YYYY-MM-DD>.md`
   - Notifikaci (macOS) z hooku

## Co každá část dělá

### `.claude/commands/denni-report.md`
**Slash command.** Když napíšeš `/denni-report`, Claude vykoná instrukce z tohoto souboru. Jednoduchá ukázka: „přečti CSV, shrnuj, zapiš report".

### `.claude/settings.json`
**Povolení a hooks.** Říká Claude, jaké příkazy smí spouštět bez ptaní (`Bash(cat:*)`, `Bash(./tools/*:*)`, …) a co se má stát, když dokončí (Stop hook → `tools/notify.sh`).

### `tools/notify.sh`
**Bash skript volaný hookem.** Spustí `osascript` (macOS) a zobrazí systémovou notifikaci. Na Windows/Linux nahraď za vlastní notifikační příkaz.

### `tools/odeslat-zpravu.sh`
**Univerzální „pošli někam zprávu" skript.** Aktuálně jen appenduje do logu. Při Agent Day přepíšeme na Slack webhook, mail, SMS — co potřebujete.

### `data/transakce-vzor.csv`
**Vzorová data** pro demo `/denni-report`. Při Agent Day vyměníme za vaše reálná data.

## Modifikace pro váš proces

Na Agent Day projdeme:
1. Upravit `CLAUDE.md` na váš byznys kontext.
2. Přejmenovat / upravit `denni-report.md` na váš proces (`/zpracuj-fakturu`, `/odpovedet-mail`).
3. Vyměnit data v `data/` za vaše.
4. Přesměrovat `tools/odeslat-zpravu.sh` na váš Slack/mail.
5. Otestovat end-to-end.

Po Agent Day stáhnete vlastní privátní repo, kde tato kostra bude přizpůsobená vám.

## Bezpečnost

- Žádný API klíč v repu. Pokud potřebuješ klíč, dej ho do `.env` (je v `.gitignore`).
- Žádné `--dangerously-skip-permissions`.
- Hooks logují akce do `tools/audit.log` (zapni v `.claude/settings.json` až je potřeba).

## Pomoc

- 14 dní mailové podpory: **team@blaze.codes**
- Plný playbook: https://github.com/blaze-it/agent-day
