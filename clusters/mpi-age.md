# MPI-AGE cluster (hpc.bioinformatics.studio) — set up 2026-09-21

## Storage
- Home: `/nexus/posix0/MAGE-flaski/service/hpc/home/ajairam`
- **Home limit 100 GB. When it went over (Oct 2026, ~3.2 TB of raw data under ~/data),
  the whole home was erased.** No quota command shows the limit ("ask your administrator").
- Decision (2026-10-14): code (~/projects) stays in home; data and software live in the group folder
  `/nexus/posix0/MAGE-flaski/service/hpc/group/Anne_Schaefer/ajairam` (data/, software/),
  reached via the links ~/data and ~/software.
- Group folder and home are the same filesystem (`nexus-posix0.hpccloud.mpcdf.mpg.de`,
  ~105 TB free), so `mv` between them is an instant rename.
- Permissions drwx------ (home and group/ajairam)
- Next to home: `group/`; top level also has `ftp_data/`, `globus/`, `tmp/`
- Login node: no clean-up timer touches home or group (only /tmp via systemd-tmpfiles)

## Software
- git 2.25.1 (< 2.28 ignores init.defaultBranch → use `git checkout -b main`)
- Apptainer/Singularity system-installed; `--fakeroot` builds WORK
- No module system, no conda. Decision: containers only

## Compute (SLURM)
- Login node: 8 cores, 15 GB — edit and submit only
- `cluster` (default): 9 nodes × 20 cores, ~69 GB (70353 MB)
- `dedicated`: 6 nodes × 32 cores, ~945 GB (967182 MB)
- Time limit 14 days; all nodes usable → 372 cores for independent jobs
- Never request more memory/cores than one node has (job never starts)

## Open questions
- Do compute nodes have fast local /tmp? (run `df -h /tmp` inside a job)
- Is home / the group folder backed up or snapshotted?
- Does the group folder have a limit or purge rule too?
