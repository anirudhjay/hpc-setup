#!/bin/bash
# ============================================================================
# 00_discover.sh — inspect a NEW cluster. Changes nothing.
# Read the output and record the answers in clusters/<cluster-name>.md
# ============================================================================

echo "=== Home directory and its filesystem ==="
echo "$HOME"
df -h "$HOME"

echo; echo "=== Quota (may say 'ask your administrator') ==="
quota -s 2>/dev/null || lfs quota -h "$HOME" 2>/dev/null || echo "no quota command worked"

echo; echo "=== Large filesystems (look for scratch / data / group areas) ==="
df -h | grep -v -E 'tmpfs|/snap/|loop'

echo; echo "=== What sits next to home (group or project folders?) ==="
ls "$(dirname "$HOME")/.." 2>/dev/null

echo; echo "=== Who can read home (want drwx------) ==="
ls -ld "$HOME"

echo; echo "=== Tools ==="
for t in git apptainer singularity conda module; do
    printf "%-12s " "$t"; command -v "$t" || echo "(not found)"
done
git --version 2>/dev/null        # < 2.28 ignores init.defaultBranch
apptainer --version 2>/dev/null

echo; echo "=== This (login) node ==="
echo "cores: $(nproc)"; free -h | head -2

echo; echo "=== SLURM nodes: name, cores, memory (MB), partition ==="
sinfo -N -o "%N %c %m %P" 2>/dev/null || echo "sinfo not available"
sinfo -o "%P %l" 2>/dev/null     # partition time limits
