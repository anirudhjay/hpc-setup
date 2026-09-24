#!/bin/bash
# ============================================================================
# 03_ssh_github.sh — create an SSH key for GitHub and configure SSH to use it.
# Safe to re-run: an existing key is kept, and the config block is only
# added if it is not already there.
# MANUAL STEP afterwards: paste the printed public key into GitHub.
# ============================================================================
set -euo pipefail
source "$(dirname "$0")/../config.sh"

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

# 1) Key: create only if missing (never overwrite a working key)
if [ -f "$SSH_KEY" ]; then
    echo "Key already exists: $SSH_KEY (keeping it)"
else
    # Label the key with user@host so it is recognisable on GitHub
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$SSH_KEY"
fi

# 2) SSH config: add the github.com block only if not present
touch "$HOME/.ssh/config"
if grep -q "^Host github.com" "$HOME/.ssh/config"; then
    echo "~/.ssh/config already has a github.com block (leaving it)"
else
    cat >> "$HOME/.ssh/config" << CFG
Host github.com
    HostName github.com
    User git
    IdentityFile $SSH_KEY
    IdentitiesOnly yes
CFG
    echo "Added github.com block to ~/.ssh/config"
fi
chmod 600 "$HOME/.ssh/config" "$SSH_KEY"

# 3) Show the PUBLIC key for the manual GitHub step
echo
echo "=== Paste this line into GitHub → Settings → SSH and GPG keys → New SSH key ==="
cat "${SSH_KEY}.pub"
echo
echo "Then test with:  ssh -T git@github.com"
echo "(If it hangs, port 22 is blocked: use 'HostName ssh.github.com' + 'Port 443')"
