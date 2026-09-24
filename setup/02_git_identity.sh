#!/bin/bash
# ============================================================================
# 02_git_identity.sh — tell git who you are (written to ~/.gitconfig).
# Safe to re-run: git config simply overwrites the same values.
# ============================================================================
set -euo pipefail
source "$(dirname "$0")/../config.sh"

# Refuse to run with the placeholder email still in config.sh
if [ "$GIT_EMAIL" = "CHANGE_ME" ]; then
    echo "Edit GIT_EMAIL in config.sh first."; exit 1
fi

git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main   # ignored by git < 2.28 (harmless)
git config --global core.editor nano

git config --global --list
