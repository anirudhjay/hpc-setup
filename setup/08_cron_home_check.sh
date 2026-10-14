#!/bin/bash
# ============================================================================
# 08_cron_home_check.sh — run 07_check_home.sh automatically every hour (cron),
# so a growing home is noticed long before the 100 GB limit wipes it.
#   - result of the last check:  ~/.home_check.log
#   - if home is too big (or the check failed), the file ~/HOME_TOO_BIG appears,
#     and every new login prints a warning (line added to ~/.bashrc)
# A cron job lives on ONE login node: install it on the node you normally use.
# Safe to re-run: the cron line and the .bashrc line are only added once.
# Remove again with:  crontab -l | grep -v home_check | crontab -
# ============================================================================
set -euo pipefail
SETUP_DIR="$(cd "$(dirname "$0")/.." && pwd)"   # absolute path of hpc-setup/
CHECK="$SETUP_DIR/setup/07_check_home.sh"

# 1) is cron allowed for us? An EMPTY crontab says "no crontab for <user>" (fine);
#    a forbidden one says e.g. "not allowed". Read the answer once ('|| true':
#    an empty crontab returns an error code, which must not stop the script).
out=$(crontab -l 2>&1) || true
if echo "$out" | grep -qiE "not allowed|permission denied|command not found"; then
    echo "$out" | head -2
    echo "STOP: cron is not available for your account on $(hostname). Ask the admins."
    exit 1
fi

# 2) the cron line: minute 17 of every hour (not :00, when everyone's jobs start)
#    check OK -> remove the flag ; check warns or fails -> create the flag
LINE="17 * * * * bash $CHECK > \$HOME/.home_check.log 2>&1 && rm -f \$HOME/HOME_TOO_BIG || touch \$HOME/HOME_TOO_BIG   # home_check (hpc-setup)"
if echo "$out" | grep -q "home_check (hpc-setup)"; then
    echo "cron job already installed on $(hostname)"
else
    ( crontab -l 2>/dev/null || true; echo "$LINE" ) | crontab -   # keep existing lines, add ours
    echo "cron job installed on $(hostname)"
fi

# 3) warning at every login if the flag exists
MARKER="# ---- home size warning (hpc-setup) ----"
if ! grep -qF "$MARKER" "$HOME/.bashrc" 2>/dev/null; then
    {
        echo ""
        echo "$MARKER"
        echo '[ -f "$HOME/HOME_TOO_BIG" ] && echo "WARNING: home is getting big (limit 100 GB) - see ~/.home_check.log"'
    } >> "$HOME/.bashrc"
    echo "login warning added to ~/.bashrc"
fi

echo; echo "Current cron jobs:"; crontab -l
echo; echo "Running the check once now:"
bash "$CHECK" | head -3 || true
