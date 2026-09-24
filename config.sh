#!/bin/bash
# ============================================================================
# config.sh — the ONE place for personal settings. Every setup script reads
# this file, so edit here and nowhere else.
# ============================================================================

# Identity stamped on every git commit
GIT_NAME="Anirudh Jairam"
GIT_EMAIL="anirudhjay97@gmail.com"          # tip: GitHub's private noreply address (Settings → Emails)

# GitHub account and the SSH key file used to talk to it
GITHUB_USER="anirudhjay"
SSH_KEY="$HOME/.ssh/id_ed25519_github"

# Projects: each gets ~/projects/<name> (code, git) and ~/data/<name> (data)
PROJECTS="sc-aging array-aging nanopore-rdna"

# Top-level layout (all inside home)
PROJECTS_DIR="$HOME/projects"
DATA_DIR="$HOME/data"
SOFTWARE_DIR="$HOME/software"
