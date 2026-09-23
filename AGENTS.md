# AGENTS.md

Class: `blaze` (Blaze company s.r.o.). Flow: `pr-review` -> open a PR and stop after review; merge and deploy on Daniel's word. Primary: https://github.com/blaze-it/agent-day-starter, default branch `main`.

## What this is

The public starter Claude Code project that clients take home from Blaze's AI Agent Day workshop, plus the one-line installers that set up their machine. It is a deliberately minimal skeleton: one slash command (`/denni-report`, a daily report from a sample CSV), one Stop hook (desktop notification) and one local tool script, which get customized to the client's process during the day. Everything is in Czech. The facilitator playbook lives in the private repo `blaze-it/agent-day`.

## Stack and layout

Claude Code project files, Markdown, Bash and PowerShell. No package manager, no build.

- `CLAUDE.md` - project memory template with `<...>` placeholders for the client's company and process, plus safety rules
- `.claude/settings.json` - permission allowlist/denylist and the Stop hook
- `.claude/commands/denni-report.md` - sample slash command; `.claude/commands/agent-day-setup.md` - setup command
- `data/transakce-vzor.csv` - sample transactions
- `reports/` - output folder (`.gitkeep` only)
- `tools/notify.sh` - notification (osascript / notify-send / PowerShell); `tools/odeslat-zpravu.sh` - "send a message" stub that appends to a log
- `install.sh` (macOS/Linux), `install.ps1` (Windows) - installers for Node.js, Git + GitHub CLI and Claude Code, then clone of this repo

## Commands

From README and the installer headers:

```bash
curl -fsSL https://get.blaze.codes/agent-day | bash   # intended one-liner (see agent-day installer/HOSTING.md; may not be live)
claude                                                # in the project folder, then run /denni-report
./tools/notify.sh "<zprava>"
./tools/odeslat-zpravu.sh "<zprava>"
```

## Deploy

Nothing is deployed. The repo is public and is itself the distribution: the installer clones it onto the client's machine.

## Rules for agents

- Flow `pr-review`: open a PR and stop after review; merge only on Daniel's word.
- This repo is PUBLIC. Never commit `.env`, secrets, webhook URLs, client names, client data or anything from the private `agent-day` repo's `clients/` or `sessions/`.
- There is no `.gitignore` in this repo, although README says `.env` is ignored; `tools/odeslat-zpravu.sh` writes `tools/odeslane-zpravy.log` and `/denni-report` writes `reports/*.md`. Do not commit those outputs; adding a `.gitignore` is an open gap.
- Keep it a minimal teaching skeleton: placeholders in `CLAUDE.md` stay placeholders, the settings keep the deny rules (`.env` reads, `rm`, `curl`, `git push`), and nothing uses `--dangerously-skip-permissions`.
- `install.sh`/`install.ps1` and the `starter-agent/` copy in `blaze-it/agent-day` have diverged from this repo; when changing one, check the other.
- Installers must stay idempotent and avoid sudo where possible (per the `agent-day` installer README).
