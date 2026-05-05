#!/usr/bin/env bash
# Univerzalni "posli nekam zpravu" skript, ktery agent muze volat.
# Aktualne jen appenduje do logu. Pri Agent Day prepiseme na Slack webhook / SMTP / SMS.
#
# Pouziti: ./tools/odeslat-zpravu.sh "<zprava>"
#
# Bezpecnost: pokud pridate webhook URL nebo SMTP heslo, dejte ho do .env, nikoli sem.

set -euo pipefail

ZPRAVA="${1:-prazdna zprava}"
LOG="$(dirname "$0")/odeslane-zpravy.log"

CAS=$(date "+%Y-%m-%d %H:%M:%S")
echo "[${CAS}] ${ZPRAVA}" >> "${LOG}"
echo "Zprava zalogovana do ${LOG}"

# === Az budete chtit poslat skutecne nekam, odkomentujte jednu z variant ===

# --- Slack webhook ---
# if [ -n "${SLACK_WEBHOOK_URL:-}" ]; then
#   curl -s -X POST -H "Content-Type: application/json" \
#     -d "{\"text\":\"${ZPRAVA}\"}" \
#     "${SLACK_WEBHOOK_URL}"
# fi

# --- macOS Mail (otevre koncept v Mail.app) ---
# osascript <<EOF
# tell application "Mail"
#   set newMessage to make new outgoing message with properties {subject:"Agent Day", content:"${ZPRAVA}", visible:true}
#   tell newMessage
#     make new to recipient with properties {address:"sef@firma.cz"}
#   end tell
# end tell
# EOF
