# Parameters

Most users should only edit `params.yaml`.

This document explains how the main sections of `params.yaml` are used by the workflow. For the execution flow, see `workflow.md`.

## File structure

The parameter file is organised into four sections:

```text
params.yaml
├── Input BAM files
├── Optional local compute resources
├── ANGSD parameters
└── ngsRelate parameters
```

Keep analysis parameters in `params.yaml`. Keep SLURM queue, memory, time, account, and module settings in `configs/slurm.config`.

## Analysis parameters

Analysis parameters belong in `params.yaml`.

Examples include:

```yaml
bam_dir: "bams/*.bam"

angsd:
  GL: 1
  doGlf: 3
  doMajorMinor: 1
  doMaf: 1
  doCounts: 1
  SNP_pval: "1e-6"
  minMaf: 0.05
  minMapQ: 30
  minQ: 20
  doIBS: 1
  makeMatrix: 1

ngsRelate:
  m: 1
```

The `bams/` folder is not created by Nextflow. Create it yourself or replace `bam_dir` with the path to your BAM files.

The current workflow collects only `.bam` files. `.bai` files may be present in the same folder, but they are not explicitly staged or managed by the pipeline.

At least two BAM files are required for pairwise relatedness analysis. If `bam_dir` does not match any files, Nextflow stops before running ANGSD. If only one BAM is provided, the ANGSD process stops with a clear error message.

Do not set ANGSD `nThreads` or ngsRelate `p` in `params.yaml`. The workflow sets these automatically from the CPUs assigned to each Nextflow process.

## Input BAM files

The `bam_dir` value tells Nextflow where to find input BAM files.

Default:

```yaml
bam_dir: "bams/*.bam"
```

Use quotes around glob patterns. This prevents the shell from expanding the path before Nextflow can interpret it.

Examples:

```yaml
bam_dir: "bams/*.bam"
bam_dir: "/absolute/path/to/bams/*.bam"
bam_dir: "../relative/path/to/bams/*.bam"
```

The workflow collects only `.bam` files. It does not explicitly collect `.bai` files.

## ANGSD parameters

The `angsd` block controls the ANGSD command.

Example:

```yaml
angsd:
  GL: 1
  doGlf: 3
  doMajorMinor: 1
  doMaf: 1
  doCounts: 1
  SNP_pval: "1e-6"
  minMaf: 0.05
  minMapQ: 30
  minQ: 20
  remove_bads: 1
  uniqueOnly: 1
  only_proper_pairs: 1
  doIBS: 1
  makeMatrix: 1
```

The workflow automatically sets:

```text
-b
-out
-nThreads
```

Do not add these manually to the `angsd` block.

By default, the ANGSD settings produce genotype likelihood outputs for ngsRelate and IBS-related outputs from ANGSD.

To skip IBS matrix generation, comment out or remove:

```yaml
doIBS: 1
makeMatrix: 1
```

## ngsRelate parameters

The `ngsRelate` block controls optional ngsRelate settings.

Example:

```yaml
ngsRelate:
  # m: 1
  # i: 1000
  # t: 0.000001
```

The workflow automatically sets:

```text
-g
-f
-n
-p
-O
```

Do not add these manually to the `ngsRelate` block.

Most users can leave the `ngsRelate` block unchanged at first.

## Optional local resources

Local execution uses one CPU per process by default and does not set memory or time limits. This keeps local runs portable across laptops and workstations with different amounts of RAM.

If you are running locally and want to change CPU settings, or add explicit memory or time limits, uncomment the optional `local_process_resources` block in `params.yaml`:

```yaml
# local_process_resources:
#   default:
#     cpus: 1
#     # memory: "4 GB"
#     # time: "02:00:00"
#
#   angsd_step:
#     cpus: 4
#     # memory: "8 GB"
#     # time: "06:00:00"
#
#   ngsrelate_step:
#     cpus: 4
#     # memory: "4 GB"
#     # time: "04:00:00"
```

The commands use `task.cpus` internally, so the number of tool threads always matches the CPUs requested by Nextflow.

Do not use `local_process_resources` for SLURM runs. For SLURM, define CPU, memory, time, queue, modules, and other cluster settings in `configs/slurm.config`.

Advanced users may edit `nextflow.config` or `configs/slurm.config` to change execution backends, containers, modules, or cluster-specific options.

## Resource settings

There are two places where process resources can be configured, depending on how the workflow is run.

For local runs:

```text
params.yaml -> local_process_resources
```

For SLURM runs:

```text
configs/slurm.config -> slurm_* resource settings
```

Do not define local resources in `params.yaml` when running with `-profile slurm`.

## Quick decision guide

Use `params.yaml` when changing:

1. Input BAM path.
2. ANGSD filtering and output options.
3. ngsRelate analysis options.
4. Optional local CPU, memory, or time settings.

Use `configs/slurm.config` when changing:

1. SLURM queue or partition.
2. SLURM account, QoS, constraint, or mail settings.
3. CPU, memory, and time for SLURM jobs.
4. ANGSD and ngsRelate module names on the cluster.
