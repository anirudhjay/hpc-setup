#!/bin/bash
# ============================================================================
# 01_skeleton.sh — create the top-level folder layout inside home.
# Safe to re-run: mkdir -p never touches folders that already exist.
# ============================================================================
set -euo pipefail                               # stop at the first error
source "$(dirname "$0")/../config.sh"           # load settings

for p in $PROJECTS; do
    mkdir -p "$PROJECTS_DIR/$p"                                   # code (git repo)
    mkdir -p "$DATA_DIR/$p"/{raw,processed,results}               # data (never in git)
done
mkdir -p "$DATA_DIR/shared/references"                            # genomes used by >1 project
mkdir -p "$SOFTWARE_DIR/containers"                               # built .sif images

echo "Layout now:"
find "$PROJECTS_DIR" "$DATA_DIR" "$SOFTWARE_DIR" -maxdepth 2 -type d | sort
