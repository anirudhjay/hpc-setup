#!/bin/bash
# ============================================================================
# 04_apptainer.sh — move Apptainer's cache and build scratch out of hidden
# folders and the small /tmp, then test that building images works.
# Safe to re-run: the ~/.bashrc block is only added once.
# ============================================================================
set -euo pipefail
source "$(dirname "$0")/../config.sh"

mkdir -p "$SOFTWARE_DIR/apptainer/cache" "$SOFTWARE_DIR/apptainer/tmp" "$SOFTWARE_DIR/cache"   # all in BASE_DIR (group)

# Add the environment variables to ~/.bashrc only if not already there.
# A unique marker line lets us detect a previous run.
MARKER="# ---- Apptainer: cache and build scratch (hpc-setup) ----"
if grep -qF "$MARKER" "$HOME/.bashrc" 2>/dev/null; then
    echo "~/.bashrc already configured for Apptainer"
else
    {
        echo ""
        echo "$MARKER"
        echo "export APPTAINER_CACHEDIR=\"$SOFTWARE_DIR/apptainer/cache\""
        echo "export APPTAINER_TMPDIR=\"$SOFTWARE_DIR/apptainer/tmp\""
        echo "export XDG_CACHE_HOME=\"$SOFTWARE_DIR/cache\"      # pip and other tools: cache out of ~/.cache"
    } >> "$HOME/.bashrc"
    echo "Added Apptainer settings to ~/.bashrc"
fi

# Use the settings for the test below. (A script cannot change your login
# shell, so run 'source ~/.bashrc' yourself afterwards.)
export APPTAINER_CACHEDIR="$SOFTWARE_DIR/apptainer/cache"
export APPTAINER_TMPDIR="$SOFTWARE_DIR/apptainer/tmp"

# Test a fakeroot build in a throwaway folder; 'trap' deletes it on exit,
# even if the build fails
TESTDIR=$(mktemp -d "$SOFTWARE_DIR/apptainer/tmp/buildtest.XXXX")
trap 'rm -rf "$TESTDIR"' EXIT
printf 'Bootstrap: docker\nFrom: ubuntu:22.04\n%%post\n    echo "build works" > /opt/test.txt\n' > "$TESTDIR/test.def"

echo "Testing 'apptainer build --fakeroot' (takes a minute)..."
if apptainer build --fakeroot "$TESTDIR/test.sif" "$TESTDIR/test.def" > "$TESTDIR/log" 2>&1; then
    apptainer exec "$TESTDIR/test.sif" cat /opt/test.txt
    echo "=> Custom images CAN be built on this cluster."
else
    tail -5 "$TESTDIR/log"
    echo "=> fakeroot build FAILED: build images elsewhere and 'apptainer pull' them."
fi

echo; echo "Now run:  source ~/.bashrc"
