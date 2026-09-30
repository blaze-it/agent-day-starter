# AGENTS.md

**Who this file is for.** These notes are for maintainers of the upstream template repository https://github.com/blaze-it/agent-day-starter (default branch `main`). The installers clone this repo onto every workshop participant's machine, so this file also ends up in client copies (`~/agent-day-starter` or a client's own repo).

**If you are working in a client's copy, ignore the "Rules for template maintainers" section below.** A client copy is meant to be customized: fill in the `<...>` placeholders in `CLAUDE.md`, rename or rewrite the slash commands, replace the sample data in `data/` with the client's own, point `tools/odeslat-zpravu.sh` at the client's real channel, and move the project into the client's own (private) repository (README, "Modifikace pro váš proces"). `CLAUDE.md` and the client's instructions take precedence over this file.

## What this is

The public starter Claude Code project that participants take home from the AI Agent Day workshop (https://blaze.codes/produkty/ai-agenti), plus the one-line installers that set up their machine. It is a deliberately minimal skeleton: two slash commands (`/denni-report`, a daily report from a sample CSV, and `/agent-day-setup`, which finishes the setup: Node.js, Paperclip, the Jarvis MCP and a demo), one Stop hook (desktop notification) and two local tool scripts in `tools/`. It gets customized to the client's process during the day. Everything user-facing is in Czech.

## Stack and layout

Claude Code project files, Markdown, Bash and PowerShell. No package manager, no build.

- `CLAUDE.md` - project memory template with `<...>` placeholders for the client's company and process, plus safety rules
- `.claude/settings.json` - permission allowlist/denylist and the Stop hook
- `.claude/commands/denni-report.md` - sample slash command; `.claude/commands/agent-day-setup.md` - post-install setup command (installs Node.js and Paperclip, adds the Jarvis MCP)
- `data/transakce-vzor.csv` - sample transactions
- `reports/` - output folder (`.gitkeep` only)
- `tools/notify.sh` - notification (osascript / notify-send / PowerShell); `tools/odeslat-zpravu.sh` - "send a message" stub that appends to a log
- `install.sh` (macOS/Linux), `install.ps1` (Windows) - installers for Node.js, Git + GitHub CLI and Claude Code, then a clone of this repo into `~/agent-day-starter`

## Commands

```bash
curl -fsSL https://get.blaze.codes/agent-day | bash        # intended macOS/Linux one-liner (from the install.sh header)
irm https://get.blaze.codes/agent-day.ps1 | iex            # intended Windows (PowerShell) one-liner
claude                                                     # in the project folder, then /agent-day-setup and /denni-report
./tools/notify.sh "<zprava>"
./tools/odeslat-zpravu.sh "<zprava>"
```

The `get.blaze.codes` one-liners are not live: the name did not resolve (NXDOMAIN) on 2026-09-30. Until it is hosted, run `install.sh` / `install.ps1` from a checkout.

## Deploy

Nothing is deployed. The repo is public and is itself the distribution: the installers clone the default branch onto the participant's machine, and existing installs pick up changes with `git pull`. Anything merged to `main` therefore reaches every new and updated install.

## Rules for template maintainers

These apply only to the upstream template repo, not to client copies.

- This repo is PUBLIC and every file in it is shipped to participants. Never commit `.env`, secrets, webhook URLs, real client names or client data, and nothing from the private workshop materials.
- Keep the template generic: `CLAUDE.md` keeps its `<...>` placeholders (participants fill them in their own copy), the settings keep the deny rules (`.env` reads, `rm`, `curl`, `git push`), and nothing uses `--dangerously-skip-permissions`.
- There is no `.gitignore` in this repo, although README says `.env` is ignored; `tools/odeslat-zpravu.sh` writes `tools/odeslane-zpravy.log` and `/denni-report` writes `reports/*.md`. Do not commit those outputs; adding a `.gitignore` is an open gap.
- A second copy of the starter project and of `install.sh`/`install.ps1` is kept in the private workshop repo and has diverged from this one; when changing one, check the other.
- Installers must stay idempotent and avoid sudo where possible.
- Changes go through a pull request and review; do not push to `main` directly.
