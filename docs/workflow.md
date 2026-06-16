# Workflow

This document describes the main workflow used by `nf-bam2identity`.

The pipeline starts from a set of BAM files, runs ANGSD to generate genotype likelihood and allele frequency outputs, and then runs ngsRelate to estimate pairwise relatedness.

## Overview

```text
User input
  |
  |  params.yaml
  |  - bam_dir
  |  - ANGSD analysis parameters
  |  - ngsRelate analysis parameters
  |
  v
+-------------------------------+
| Collect BAM files             |
|                               |
| Channel.fromPath(bam_dir)     |
| Requires at least two .bam    |
+-------------------------------+
  |
  v
+-------------------------------+
| ANGSD process                 |
| bam2identity_angsd            |
|                               |
| Creates all.filelist          |
| Counts BAM files              |
| Runs ANGSD with -nThreads     |
+-------------------------------+
  |
  |  ANGSD outputs
  |  - angsd_output.glf.gz
  |  - angsd_output.mafs.gz
  |  - angsd_output.ibs.gz
  |  - angsd_output.ibsMat
  |  - n_samples.txt
  |
  v
+-------------------------------+
| ngsRelate process             |
| bam2identity_ngsRelate        |
|                               |
| Extracts allele frequencies   |
| Reads sample count            |
| Runs ngsRelate with -p        |
+-------------------------------+
  |
  v
+-------------------------------+
| Published results             |
|                               |
| results/final_output/angsd    |
| results/final_output/ngsRelate|
+-------------------------------+
```

## Input collection

The workflow reads the BAM pattern defined by `bam_dir` in `params.yaml`.

Example:

```yaml
bam_dir: "bams/*.bam"
```

Keep glob patterns inside quotes. If a pattern is passed through the command line without quotes, the shell may expand it before Nextflow receives it.

The workflow currently collects `.bam` files only. BAM index files such as `.bai` may be present next to the BAM files, but they are not explicitly staged or managed by the pipeline.

At least two BAM files are required because ngsRelate estimates pairwise relatedness.

## ANGSD step

The first process is:

```text
bam2identity_angsd
```

This process:

1. Receives the collected BAM files.
2. Creates `all.filelist`.
3. Counts the number of BAM files.
4. Stops with a clear error if fewer than two BAM files are provided.
5. Runs ANGSD using the options defined under `angsd` in `params.yaml`.

The workflow sets these ANGSD arguments automatically:

```text
-b
-out
-nThreads
```

Do not define those options in `params.yaml`.

The number of ANGSD threads is controlled by the CPUs assigned to the Nextflow process. For local runs, this comes from `nextflow.config` or the optional `local_process_resources` block in `params.yaml`. For SLURM runs, this comes from `configs/slurm.config`.

## ngsRelate step

The second process is:

```text
bam2identity_ngsRelate
```

This process:

1. Receives the ANGSD outputs.
2. Extracts allele frequencies from `angsd_output.mafs.gz`.
3. Reads the sample count from `n_samples.txt`.
4. Runs ngsRelate using the options defined under `ngsRelate` in `params.yaml`.

The workflow sets these ngsRelate arguments automatically:

```text
-g
-f
-n
-p
-O
```

Do not define those options in `params.yaml`.

The number of ngsRelate threads is controlled by the CPUs assigned to the Nextflow process.

## Outputs

Final outputs are published to:

```text
results/final_output/
├── angsd/
└── ngsRelate/
```

The `work/` directory contains intermediate Nextflow task directories and logs. These files are useful for debugging but are not the final output location.

## Local and SLURM execution

The workflow logic is the same for local and SLURM runs. The main difference is how Nextflow runs each process.

Local execution:

```text
Nextflow -> local executor -> Docker containers
```

SLURM execution:

```text
Nextflow -> SLURM executor -> cluster modules
```

For local runs, most users only need to edit `params.yaml`.

For SLURM runs, edit `params.yaml` for analysis settings and `configs/slurm.config` for cluster execution settings.
