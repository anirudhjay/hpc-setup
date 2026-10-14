#!/bin/bash
# ============================================================================
# 07_check_home.sh — how big is home itself? Run it now and then.
# On MPI-AGE, home has a 100 GB limit and was WIPED when it went over, so the
# warning threshold (HOME_WARN_GB in config.sh) is set well below that.
# du does not follow links, so ~/data and ~/software (in the group folder) are
# NOT counted here — only what really sits in home (code, dot-files, caches).
# Changes nothing.
# ============================================================================
set -euo pipefail
source "$(dirname "$0")/../config.sh"

kb=$(du -sk "$HOME" 2>/dev/null | cut -f1)              # size of home in KB
gb=$(( kb / 1024 / 1024 ))
echo "home ($HOME): ${gb} GB  (warning above ${HOME_WARN_GB} GB)"

echo; echo "Biggest items in home (hidden caches included):"
{ du -sh "$HOME"/.[!.]* "$HOME"/* 2>/dev/null || true; } | sort -h | tail -8   # '|| true': an empty pattern must not stop the script

echo; echo "data and software should be links into the group folder:"
for top in data software; do
    if [ -L "$HOME/$top" ]; then echo "  ok   ~/$top -> $(readlink "$HOME/$top")"
    elif [ -e "$HOME/$top" ]; then echo "  BAD  ~/$top is a real folder in home: run setup/01_skeleton.sh"
    else echo "  --   ~/$top missing: run setup/01_skeleton.sh"; fi
done

if [ "$gb" -ge "$HOME_WARN_GB" ]; then
    echo; echo "WARNING: home is ${gb} GB. Move the big items above into $BASE_DIR now."
    exit 1
fi
