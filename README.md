# hpc-setup

How I set up a fresh HPC account: layout, git, SSH, Apptainer, projects.
Run the steps **one at a time, in order**, reading the output of each.
Every script is safe to re-run.

## Layout this creates

```
~/projects/<project>/      code — one git repo per project
~/data/<project>/          raw/ processed/ results/ — never in git
~/data/shared/references/  genomes used by more than one project
~/software/containers/     built .sif images — rebuildable, never in git
~/software/apptainer/      Apptainer cache + build scratch
```

Each project repo contains `data -> ../../data/<project>` (relative symlink, git-ignored).

## Runbook for a new cluster

0. **Get this repo onto the cluster.**
   - If this repo is public: `git clone https://github.com/anirudhjay/hpc-setup.git ~/projects/hpc-setup`
   - If private: SSH to GitHub isn't set up yet, so first copy-paste
     `setup/03_ssh_github.sh` from the GitHub website and run it (step 3 below),
     then `git clone git@github.com:anirudhjay/hpc-setup.git ~/projects/hpc-setup`
1. `cd ~/projects/hpc-setup` and check `config.sh` (email, project list).
2. `bash setup/00_discover.sh` → write the answers into `clusters/<name>.md`.
3. `bash setup/01_skeleton.sh`
4. `bash setup/02_git_identity.sh`
5. `bash setup/03_ssh_github.sh`
   → MANUAL: paste the public key into GitHub, then `ssh -T git@github.com`
6. `bash setup/04_apptainer.sh` then `source ~/.bashrc`
7. For each existing project: `bash setup/06_clone_project.sh sc-aging` (etc.)
   → then transfer the data (Globus / rsync) into `~/data/<project>`
8. Only for a brand-new project: create an EMPTY repo on GitHub, then
   `bash setup/05_new_project.sh <name>`, check `git status`, commit, push.

## Rules

- Never put secrets (private keys, tokens, passwords) in this repo.
- When you change the setup by hand on a cluster, update the script here too,
  or it will be lost next time.
- Cluster-specific discoveries go in `clusters/`, not in the scripts.
