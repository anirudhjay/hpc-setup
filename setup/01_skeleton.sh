#!/bin/bash
# ============================================================================
# 01_skeleton.sh — create the folder layout. Code stays in home (small);
# data and software go to BASE_DIR (the group folder when GROUP_DIR is set in
# config.sh), with links left in home:
#     ~/projects                           (code, one git repo per project: real folder in home)
#     ~/data     -> $BASE_DIR/data         (raw / processed / results)
#     ~/software -> $BASE_DIR/software     (containers, Apptainer cache)
# Old paths like ~/data/sc-aging keep working, but nothing big sits in home.
#
# Safe to re-run: existing folders and links are left alone.
# A REAL folder still in home is moved into BASE_DIR first, but only when that
# is an instant rename (same filesystem) and nothing is there yet. Otherwise the
# script stops and tells you what to do — it never merges or copies by itself.
# ============================================================================
set -euo pipefail                               # stop at the first error
source "$(dirname "$0")/../config.sh"           # load settings

# --- 1. one top folder: make it in BASE_DIR, leave a link in home -----------
link_home() {
    local name="$1"                  # data | software
    local target="$BASE_DIR/$name"   # the real folder
    local link="$HOME/$name"         # what you type

    if [ "$BASE_DIR" = "$HOME" ]; then   # no group folder: plain folder in home
        mkdir -p "$target"; return
    fi
    if [ -L "$link" ]; then              # already a link: only check where it points
        echo "~/$name is a link -> $(readlink "$link")"
        [ "$(readlink -f "$link")" = "$(readlink -f "$target")" ] || \
            echo "  WARNING: expected it to point to $target"
        mkdir -p "$target"; return
    fi
    if [ -d "$link" ]; then              # a real folder still in home
        if [ -e "$target" ]; then        # both exist: merging is a decision for you
            echo "STOP: both ~/$name and $target exist. Move the contents by hand, then re-run."
            exit 1
        fi
        mkdir -p "$BASE_DIR"
        # same device number = same filesystem = mv is an instant rename, not a copy
        if [ "$(stat -c %d "$HOME")" != "$(stat -c %d "$BASE_DIR")" ]; then
            echo "STOP: ~/$name is on another filesystem than $BASE_DIR; mv would COPY it."
            echo "      Copy it with rsync yourself, check it, then re-run."
            exit 1
        fi
        mv "$link" "$target"             # instant rename
        echo "moved ~/$name -> $target"
    fi
    mkdir -p "$target"
    ln -s "$target" "$link"              # leave the link in home
    echo "~/$name -> $target"
}

mkdir -p "$PROJECTS_DIR"            # code: a plain folder in home
for top in data software; do        # big things: real folder in BASE_DIR, link in home
    link_home "$top"
done

# --- 2. per-project folders (code in home ; data via the ~/data link) -------
for p in $PROJECTS; do
    mkdir -p "$PROJECTS_DIR/$p"                                   # code (git repo)
    mkdir -p "$DATA_DIR/$p"/{raw,processed,results}               # data (never in git)
done
mkdir -p "$DATA_DIR/shared/references"                            # genomes used by >1 project
mkdir -p "$SOFTWARE_DIR/containers"                               # built .sif images

# --- 3. show the result ------------------------------------------------------
echo; echo "Home now (projects/ is a folder; data and software are links):"
ls -la "$HOME"
echo; echo "Layout in $BASE_DIR:"
find "$PROJECTS_DIR" "$DATA_DIR" "$SOFTWARE_DIR" -maxdepth 2 -type d | sort
