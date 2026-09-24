# MPI-AGE cluster (hpc.bioinformatics.studio) — set up 2026-09-21

## Storage
- Home: `/nexus/posix0/MAGE-flaski/service/hpc/home/ajairam` (200 TB shared network FS)
- Decision: ALL data lives inside home (`~/data/<project>`)
- No quota command ("ask your administrator"); home permissions drwx------
- Next to home: `group/`; top level also has `ftp_data/`, `globus/`, `tmp/`

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
- Usable space: ~60 TB

## Open questions
- Do compute nodes have fast local /tmp? (run `df -h /tmp` inside a job)
- Is home backed up?

