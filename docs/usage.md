# Usage

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

For the available SLURM settings, see `docs/slurm.md`.
