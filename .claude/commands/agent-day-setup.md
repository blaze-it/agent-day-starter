---
description: Dokončení Agent Day instalace — Node.js, Paperclip, Jarvis MCP, demo. Spusťte hned po prvním 'claude' v ~/agent-day-starter.
allowed-tools: Bash, Read, Write, Edit
---

# /agent-day-setup — finální setup po instalaci

Klient právě naběhl ze základní instalace (`curl …/install.sh | bash`). Má:
- ✅ Licenční klíč (verifikovaný serverem)
- ✅ Claude Code (nainstalovaný)
- ✅ Tento starter v `~/agent-day-starter/`

Tvým úkolem je doinstalovat zbytek a vysvětlit, co dál. Mluv česky, klient je netechnický.

---

## Krok 1 — Detekce OS

```bash
uname -s
```

Větve:
- `Darwin` → macOS
- `Linux` → Linux
- jinak → řekni klientovi, že potřebuje Windows install.ps1 a tento setup pro něj nebude fungovat.

Také zkontroluj architekturu (`uname -m` → `arm64` / `x86_64`).

---

## Krok 2 — Node.js LTS (≥ v20)

Paperclip potřebuje Node 20+. `corepack` (součást Node) řeší pnpm bez `npm install -g`.

```bash
node --version 2>/dev/null || echo MISSING
```

Pokud chybí nebo major < 20:

**macOS (Homebrew):**
```bash
brew install -q node
```

**macOS bez Homebrew / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
```

Po instalaci:
```bash
corepack enable 2>/dev/null || true
node --version
```

> Pokud Node 20+ už je, **přeskoč tento krok** a jdi dál.

---

## Krok 3 — git (jen pokud chybí)

git je obvykle už nainstalovaný (Apple CLT nebo apt). Zkontroluj:
```bash
git --version 2>/dev/null || echo MISSING
```

Pokud chybí:
- **macOS:** `xcode-select --install` — vyskočí dialog, řekni klientovi, ať klikne "Install" a počká pár minut.
- **Linux (Debian/Ubuntu):** `sudo apt-get update -qq && sudo apt-get install -y -qq git`
- **Linux (Fedora/RHEL):** `sudo dnf install -y -q git`

---

## Krok 4 — Paperclip (orchestrátor agentů)

Klient dostává Paperclip Pro v ceně Agent Day. Onboard ho:

```bash
ls ~/.paperclip/config.json ~/.paperclipai/config.json 2>/dev/null || echo NEEDS_ONBOARD
```

Pokud potřeba onboard:
```bash
npx -y paperclipai@latest onboard --yes
```

Onboarding trvá ~1 minutu (nastaví embedded postgres, default LLM, atd.). Pokud klient chce LAN/tailnet přístup, zmiň, že později může:
```bash
npx paperclipai configure
```

Po onboardingu řekni klientovi:
> "Paperclip je nainstalovaný. Web UI spustíš příkazem `npx paperclipai run` — otevře se na http://localhost:3100."

---

## Krok 5 — Jarvis MCP integrace

Klient má **3 měsíce Džarvis Pro zdarma**. Propoj Claude Code s Džarvis MCP serverem:

```bash
claude mcp add --transport sse jarvis https://dzarvis.com/mcp/sse 2>&1
```

> Tento příkaz musí běžet **mimo** současný Claude Code session, ale přes Bash tool to umíme. Pokud `claude` není v PATH (možné při čerstvé instalaci), použij `~/.claude/local/bin/claude`.

Řekni klientovi, že při příštím `claude` se otevře browser pro OAuth autorizaci Džarvise — jednou, potom funguje.

---

## Krok 6 — Demo `/denni-report`

V `.claude/commands/denni-report.md` je hotový slash command. Stručně ho ukaž klientovi:
```bash
cat .claude/commands/denni-report.md | head -20
```

Vysvětli česky:
> "`/denni-report` je tvůj první agent. Přečte `data/transakce-vzor.csv`, shrne ho a zapíše do `reports/<datum>.md`. Jakmile odsouhlasíš oprávnění, spustí se."

**Nespouštěj** `/denni-report` automaticky — to nechej na klientovi. On si chce ozkoušet, jak vypadá schvalování oprávnění.

---

## Krok 7 — Souhrn

Vypiš klientovi nakonec:

```
✓ Setup hotov.

  Co máš:
    • Claude Code (~/.claude/local/bin/claude)
    • Node $(node --version)
    • Paperclip — UI:  npx paperclipai run  → http://localhost:3100
    • Džarvis MCP — autorizuje se při dalším 'claude'
    • Starter v ~/agent-day-starter

  Zkus:  /denni-report     ← tvůj první agent
  Edit:  .claude/commands/denni-report.md
  Web:   https://inside.blaze.codes/agent-day
  Mail:  team@blaze.codes  (14 dní mailové podpory zdarma)
```

---

## Pravidla

- **Mluv česky.** Klient je netechnický — žádný developer-jargon bez analogie.
- **Idempotentně.** Re-spuštění setupu musí být bezpečné — zkontroluj než instaluješ.
- **Selhání neukončují setup.** Pokud Paperclip nebo Jarvis selže, napiš proč a pokračuj. Klient si to dořeší později.
- **Žádný `sudo` bez svolení.** Pokud něco chce sudo, řekni klientovi a počkej.
- **Stručně.** Po každém kroku 1–2 věty co se stalo.
