#!/usr/bin/env bash
# Posila notifikaci do macOS lišty. Spousti se Stop hookem v .claude/settings.json.
# Pouziti: ./tools/notify.sh "<zprava>"
# Na Windows/Linux nahrad telo skriptu za vlastni notifikacni prikaz.

set -euo pipefail

ZPRAVA="${1:-Agent dokoncil praci}"

if command -v osascript >/dev/null 2>&1; then
  # macOS
  osascript -e "display notification \"${ZPRAVA}\" with title \"Agent Day\" sound name \"Glass\""
elif command -v notify-send >/dev/null 2>&1; then
  # Linux (libnotify)
  notify-send "Agent Day" "${ZPRAVA}"
elif command -v powershell.exe >/dev/null 2>&1; then
  # Windows pres WSL nebo Git Bash
  powershell.exe -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; \$n = New-Object System.Windows.Forms.NotifyIcon; \$n.Icon = [System.Drawing.SystemIcons]::Information; \$n.Visible = \$true; \$n.ShowBalloonTip(3000, 'Agent Day', '${ZPRAVA}', 'Info')"
else
  # Fallback: jen do stdoutu
  echo "[notify] ${ZPRAVA}"
fi
