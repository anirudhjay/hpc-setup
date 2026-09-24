#!/bin/bash
# ============================================================================
# 05_new_project.sh <name> — create a BRAND-NEW project repo from scratch.
# (For a project that already exists on GitHub, use 06_clone_project.sh.)
#
# MANUAL STEP first: create an EMPTY private repo <name> on GitHub
# (no README, no .gitignore, no license).
#
# Stops before committing so you can check 'git status' yourself.
# ============================================================================
set -euo pipefail
SETUP_DIR="$(cd "$(dirname "$0")/.." && pwd)"   # absolute path of hpc-setup/
source "$SETUP_DIR/config.sh"

PROJ="${1:?usage: 05_new_project.sh <project-name>}"
DIR="$PROJECTS_DIR/$PROJ"

# Refuse to touch something that is already a repo
if [ -d "$DIR/.git" ]; then echo "$DIR is already a git repo; stopping."; exit 1; fi

mkdir -p "$DIR" "$DATA_DIR/$PROJ/raw" "$DATA_DIR/$PROJ/processed" "$DATA_DIR/$PROJ/results"
cd "$DIR"

# Standard folders; .gitkeep so git tracks the empty ones
for d in scripts slurm notebooks config containers logs; do
    mkdir -p "$d" && touch "$d/.gitkeep"
done

# Relative symlink to the data (works inside containers and after migrations)
[ -e data ] || ln -s "../../data/$PROJ" data

# Shared .gitignore and a minimal README
cp "$SETUP_DIR/templates/gitignore" .gitignore
cat > README.md << README
# $PROJ

Description goes here.

- Code: this repo
- Data: \`data/\` -> \`~/data/$PROJ\` (not tracked)
- Software: Apptainer images built from \`containers/*.def\`
README

# 'checkout -b main' before the first commit works on every git version
git init -q
git checkout -q -b main
git remote add origin "git@github.com:$GITHUB_USER/$PROJ.git"
git add .

echo "=== CHECK: expect .gitignore, README.md, .gitkeep files — and NO 'data' ==="
git status --short
echo
echo "If that looks right:"
echo "  cd $DIR"
echo "  git commit -m \"Initial project skeleton\""
echo "  git push -u origin main"
