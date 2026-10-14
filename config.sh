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

# Where things live. Home is SMALL on most clusters (MPI-AGE: 100 GB, and the whole
# home was wiped when it went over). Code is small, so it stays in home; data and
# software (containers, caches) live in the lab's group folder, reached via links.
# Leave GROUP_DIR empty ("") on a cluster without a group folder: then all stays in home.
GROUP_DIR="/nexus/posix0/MAGE-flaski/service/hpc/group/Anne_Schaefer/ajairam"
BASE_DIR="${GROUP_DIR:-$HOME}"              # GROUP_DIR if set, otherwise home

# Top-level layout: code in home ; data and software in BASE_DIR (~/data, ~/software are links)
PROJECTS_DIR="$HOME/projects"
DATA_DIR="$BASE_DIR/data"
SOFTWARE_DIR="$BASE_DIR/software"

# Warn when home itself (links not followed) grows past this size
HOME_WARN_GB=50
