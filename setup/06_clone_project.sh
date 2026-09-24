#!/bin/bash
# ============================================================================
# 06_clone_project.sh <name> — bring an EXISTING project onto a new cluster.
# Clones the code from GitHub and recreates the data folders + symlink
# (the symlink is git-ignored, so a clone does not include it).
# The data itself must be transferred separately (Globus / rsync).
# ============================================================================
set -euo pipefail
source "$(dirname "$0")/../config.sh"

PROJ="${1:?usage: 06_clone_project.sh <project-name>}"
DIR="$PROJECTS_DIR/$PROJ"

if [ -d "$DIR/.git" ]; then
    echo "$DIR already cloned (skipping clone)"
else
    mkdir -p "$PROJECTS_DIR"
    # git clone accepts an existing EMPTY folder (e.g. from 01_skeleton.sh)
    git clone "git@github.com:$GITHUB_USER/$PROJ.git" "$DIR"
fi

mkdir -p "$DATA_DIR/$PROJ/raw" "$DATA_DIR/$PROJ/processed" "$DATA_DIR/$PROJ/results"
cd "$DIR"
[ -e data ] || [ -L data ] || ln -s "../../data/$PROJ" data
ls -l data
echo "Done. Now transfer the data into $DATA_DIR/$PROJ"
