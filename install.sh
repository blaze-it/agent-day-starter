#!/usr/bin/env bash
#
# Agent Day starter — instalátor pro macOS / Linux
# https://github.com/blaze-it/agent-day-starter
#
# Použití:
#   curl -fsSL https://get.blaze.codes/agent-day | bash
#
# Co dělá:
#   1. Zkontroluje OS (macOS / Linux)
#   2. Doinstaluje Node.js (přes Homebrew na macOS, přes nvm na Linuxu) — pokud chybí
#   3. Doinstaluje Git + GitHub CLI — pokud chybí
#   4. Doinstaluje Claude Code (npm -g)
#   5. Naklonuje starter-agent do ~/agent-day-starter
#   6. Vypíše další kroky
#
# Idempotentní — můžete spustit vícekrát, přeskakuje hotové.

set -euo pipefail

# ====================== UI helpery ======================
INFO()  { printf "▸ %s\n" "$*"; }
OK()    { printf "✓ %s\n" "$*"; }
WARN()  { printf "⚠ %s\n" "$*" >&2; }
FAIL()  { printf "✗ %s\n" "$*" >&2; exit 1; }
HEAD()  { printf "\n— %s\n" "$*"; }

has() { command -v "$1" >/dev/null 2>&1; }

# ====================== Banner ======================
cat <<'EOF'

  ╔═══════════════════════════════════════════════════╗
  ║            Agent Day starter — instalace          ║
  ║                  Blaze · Ostrava                  ║
  ╚═══════════════════════════════════════════════════╝

EOF

# ====================== Detekce OS ======================
HEAD "1/6 · Detekce systému"

case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)  OS="linux" ;;
  *)      FAIL "Nepodporovaný systém: $(uname -s). Pro Windows použijte install.ps1." ;;
esac

ARCH="$(uname -m)"
OK "Systém: $OS / $ARCH"

# ====================== Node.js ======================
HEAD "2/6 · Node.js"

if has node; then
  NODE_VERSION="$(node --version)"
  NODE_MAJOR="$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\).*/\1/')"
  if [ "$NODE_MAJOR" -ge 20 ]; then
    OK "Node.js $NODE_VERSION — OK"
  else
    WARN "Node.js $NODE_VERSION je starší než LTS. Doinstaluji novější."
    INSTALL_NODE=1
  fi
else
  INFO "Node.js není, instaluji…"
  INSTALL_NODE=1
fi

if [ "${INSTALL_NODE:-0}" = "1" ]; then
  if [ "$OS" = "macos" ]; then
    if ! has brew; then
      INFO "Homebrew není, instaluji…"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Persist brew on PATH for future shells too — otherwise user has to
      # re-export every time they open a terminal.
      BREW_PREFIX=""
      if [ -d "/opt/homebrew/bin" ]; then
        BREW_PREFIX="/opt/homebrew"
      elif [ -d "/usr/local/Homebrew" ]; then
        BREW_PREFIX="/usr/local"
      fi
      if [ -n "$BREW_PREFIX" ]; then
        eval "$("$BREW_PREFIX/bin/brew" shellenv)"
        SHELL_RC="$HOME/.zprofile"
        [ "${SHELL:-}" = "/bin/bash" ] && SHELL_RC="$HOME/.bash_profile"
        if ! grep -qs "brew shellenv" "$SHELL_RC" 2>/dev/null; then
          printf '\neval "$(%s/bin/brew shellenv)"\n' "$BREW_PREFIX" >> "$SHELL_RC"
          INFO "Přidáno 'brew shellenv' do $SHELL_RC (projeví se v dalším terminálu)."
        fi
      fi
    fi
    brew install node
  else
    # Linux — use nvm so we don't need sudo
    if [ ! -d "$HOME/.nvm" ]; then
      INFO "Instaluji nvm…"
      curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
  fi
  OK "Node.js: $(node --version)"
fi

# ====================== Git ======================
HEAD "3/6 · Git"

if has git; then
  OK "Git $(git --version | sed 's/git version //') — OK"
else
  INFO "Git není, instaluji…"
  if [ "$OS" = "macos" ]; then
    brew install git
  else
    sudo apt-get update -qq && sudo apt-get install -y git
  fi
  OK "Git nainstalován"
fi

# ====================== GitHub CLI ======================
HEAD "4/6 · GitHub CLI (gh)"

if has gh; then
  OK "GitHub CLI $(gh --version | head -1 | awk '{print $3}') — OK"
else
  INFO "Instaluji GitHub CLI…"
  if [ "$OS" = "macos" ]; then
    brew install gh
  else
    # Linux (Debian/Ubuntu)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod 644 /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y gh
  fi
  OK "GitHub CLI nainstalován"
fi

# ====================== Claude Code ======================
HEAD "5/6 · Claude Code"

if has claude; then
  OK "Claude Code $(claude --version 2>/dev/null | head -1 || echo '(nainstalovaný)') — OK"
else
  INFO "Instaluji Claude Code…"
  npm install -g @anthropic-ai/claude-code
  OK "Claude Code nainstalován"
fi

# ====================== Klonování starter-agenta ======================
HEAD "6/6 · Starter agent"

DEST="${AGENT_DAY_DEST:-$HOME/agent-day-starter}"

if [ -d "$DEST/.git" ]; then
  OK "Starter už existuje v $DEST — přeskakuji klonování"
  INFO "Pro aktualizaci spusťte:  cd $DEST && git pull"
else
  if [ -d "$DEST" ]; then
    FAIL "Cesta $DEST existuje, ale není to git repo. Smažte ji a spusťte znovu."
  fi
  INFO "Klonuji starter do ${DEST}…"
  git clone --depth 1 https://github.com/blaze-it/agent-day-starter.git "$DEST"
  OK "Starter naklonován"
fi

# Make tools executable (in case git lost the bit)
if [ -d "$DEST/tools" ]; then
  chmod +x "$DEST/tools/"*.sh 2>/dev/null || true
fi

# ====================== Hotovo ======================
cat <<EOF

  ╔═══════════════════════════════════════════════════╗
  ║                    Hotovo! ✓                      ║
  ╚═══════════════════════════════════════════════════╝

  Další krok:

      cd $DEST
      claude

  Při prvním spuštění Claude Code:
    1. Otevře vám prohlížeč k přihlášení Anthropic účtem
       (nebo Claude Max — pokud ho máte)
    2. Po přihlášení napište v Claude Code:  /denni-report

  Plná dokumentace:
    https://github.com/blaze-it/agent-day-starter

  Pomoc během 14denní podpory:
    team@blaze.codes  ·  předmět "Agent Day support — <vaše firma>"

EOF
