# Usage

This document gives step-by-step execution guidance. For a diagram of the full workflow, see `workflow.md`.

## Before running

Start from the project directory:

```bash
cd nf-bam2identity
```

Activate the conda environment that contains Nextflow:

```bash
conda activate nf_bam2identity
```

Check that Nextflow is available:

```bash
nextflow -version
```

Edit `params.yaml` before running. At minimum, confirm that `bam_dir` points to the BAM files you want to analyse.

## Local execution

Run the workflow with the default local Docker configuration:

```bash
nextflow run main.nf -params-file params.yaml
```

The default `params.yaml` expects input files matching:

```yaml
bam_dir: "bams/*.bam"
```

Create that folder yourself, or edit `bam_dir` to point to the folder where your BAM files are stored.

The workflow requires at least two BAM files. If the path does not match any BAM files, the run stops before ANGSD starts.

If your BAM files are elsewhere, edit `params.yaml`:

```yaml
bam_dir: "/path/to/my/bams/*.bam"
```

Then run the same Nextflow command.

Resume a previous run:

```bash
nextflow run main.nf -params-file params.yaml -resume
```

Generate Nextflow execution reports:

```bash
nextflow run main.nf \
  -params-file params.yaml \
  -resume \
  -with-report \
  -with-trace \
  -with-timeline
```

## SLURM execution

Before using SLURM, edit `configs/slurm.config` to match the cluster where the workflow will run.

Run the workflow with the generic SLURM profile:

```bash
nextflow run main.nf -profile slurm -params-file params.yaml -resume
```

Preview the resolved configuration without submitting jobs:

```bash
nextflow config -profile slurm
```

For the available SLURM settings, see `slurm.md`.

## Checking outputs

Final outputs are published to:

```text
results/final_output/
├── angsd/
└── ngsRelate/
```

ANGSD outputs are copied to:

```text
results/final_output/angsd/
```

ngsRelate outputs are copied to:

```text
results/final_output/ngsRelate/
```

Intermediate task files are stored in `work/`. These are useful when debugging failed runs, but users should normally inspect `results/final_output/` first.

## Common run checks

Before reporting a failed run, check:

1. `bam_dir` points to at least two `.bam` files.
2. The BAM glob pattern is quoted in `params.yaml`.
3. Docker is running for local execution.
4. The conda environment is active.
5. For SLURM runs, module names in `configs/slurm.config` match the modules available on the cluster.
