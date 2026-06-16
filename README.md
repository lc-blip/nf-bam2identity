# nf-bam2identity

**Status:** Active development. The current version is a functional prototype, locally tested on a small ANGSD test dataset.

A mini-pipeline focused around using Nextflow, ANGSD and ngsRelate to analyse Identity by State (IBS) and Identity by Descent (IBD) from BAM files.

## Prerequisites

To run this pipeline, you don't need to install complex bioinformatics tools locally. You only need:

* **[Docker](https://docs.docker.com/get-docker/):** To run ANGSD and ngsRelate in isolated, reproducible containers.
* **[Conda](https://docs.conda.io/en/latest/) (or Mamba):** To create the environment that runs Nextflow.

For HPC execution, the repository includes a generic SLURM profile in `configs/slurm.config`.

For a more detailed description of how the workflow is organised, see `docs/workflow.md`.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/lc-blip/nf-bam2identity.git
cd nf-bam2identity
```

### 2. Activate the conda environment

```bash
conda env create -f environment.yaml -n nf_bam2identity
conda activate nf_bam2identity
```

### 3. Define paths and parameters

Open the `params.yaml` file with your preferred text editor and follow the instructions inside.

This file controls the input BAM path, ANGSD parameters, and ngsRelate parameters. It also includes an optional commented block for local compute resources.

For a more detailed explanation of each parameter section, see `docs/parameters.md`.

By default, the example configuration expects BAM files inside a folder called `bams/`:

```yaml
bam_dir: "bams/*.bam"
```

### 4. Prepare your input BAM files

Make sure `bam_dir` in `params.yaml` points to the folder where your BAM files are stored.

If you want to use the default path, create a `bams/` folder and place your BAM files there:

```bash
mkdir -p bams
```

You can also point `bam_dir` to another location:

```yaml
bam_dir: "/path/to/my/bams/*.bam"
```

At the moment, the workflow collects only `.bam` files. BAM index files such as `.bai` can stay next to your BAMs, but they are not explicitly staged or managed by the pipeline.

At least two BAM files are required, because the workflow estimates pairwise relatedness. If the path in `bam_dir` does not match any BAM files, Nextflow will stop before running ANGSD.

Using the default configuration, the expected directory structure is:

```text
nf-bam2identity/
├── bams/
│   ├── sample1.bam
│   ├── sample2.bam
│   └── sample3.bam
├── params.yaml
├── main.nf
└── nextflow.config
```

### 5. Run the Nextflow script

Inside the `nf-bam2identity` folder, run the local Docker profile with:

```bash
nextflow run main.nf -params-file params.yaml
```

To run on an HPC cluster with SLURM, use the SLURM profile instead:

```bash
nextflow run main.nf -profile slurm -params-file params.yaml -resume
```

Before using SLURM, edit `configs/slurm.config` to match your cluster. See `docs/slurm.md` for details.

For more execution examples and optional Nextflow report commands, see `docs/usage.md` and `docs/examples.md`.

### 6. Consult your results

Results will be written to:

```text
results/
└── final_output/
    ├── angsd/
    └── ngsRelate/
```

Intermediate Nextflow files and logs can be found in:

```text
work/
```

## Parameters

Pipeline parameters are defined in `params.yaml`.

For a more complete parameter guide, see `docs/parameters.md`.

The file is divided into four main sections:

### Input BAM files

Defines the path to the BAM files that will be analysed.

```yaml
bam_dir: "bams/*.bam"
```

The `bams/` folder is not created automatically. Either create it yourself or change `bam_dir` to match the folder where your BAM files are already stored.

Only `.bam` files are collected by the current workflow. `.bai` files are ignored unless support for indexed BAM inputs is added in a future version.

The workflow requires at least two BAM files. If `bam_dir` points to an empty folder or a path with no matching BAM files, the run stops early with an input error.

### ANGSD parameters

Controls genotype likelihood estimation, allele frequency estimation, SNP filtering, read and base quality filtering, and IBS matrix generation.

Some important default parameters include:

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
  doIBS: 1
  makeMatrix: 1
```

By default, these settings produce both IBS and IBD-related outputs.

If you only want IBD results from ngsRelate, comment out or remove the following ANGSD parameters in `params.yaml`:

```yaml
doIBS: 1
makeMatrix: 1
```

### ngsRelate parameters

Controls pairwise relatedness estimation and ngsRelate runtime options.

Threads are not configured as ANGSD or ngsRelate parameters. The workflow sets ANGSD `-nThreads` and ngsRelate `-p` from the CPUs assigned to each Nextflow process.

For normal local use, leave the optional `local_process_resources` block in `params.yaml` commented. To override local CPU, memory, or time settings, uncomment and edit that block:

```yaml
# local_process_resources:
#   angsd_step:
#     cpus: 4
#     memory: "8 GB"
#     time: "06:00:00"
#
#   ngsrelate_step:
#     cpus: 4
#     memory: "4 GB"
#     time: "04:00:00"
```

For SLURM runs, keep `local_process_resources` commented and edit `configs/slurm.config` instead:

```groovy
params.slurm_angsd_cpus = 4
params.slurm_angsd_memory = '16 GB'
params.slurm_angsd_time = '06:00:00'

params.slurm_ngsrelate_cpus = 4
params.slurm_ngsrelate_memory = '8 GB'
params.slurm_ngsrelate_time = '04:00:00'
```

This avoids defining CPU, memory, or time in two different places.

Advanced execution details are defined in `nextflow.config` for local runs and in `configs/slurm.config` for SLURM runs.

For most use cases, edit `params.yaml` directly rather than changing `main.nf`.

## Documentation

Additional documentation is available in:

* `docs/workflow.md`
* `docs/usage.md`
* `docs/parameters.md`
* `docs/slurm.md`
* `docs/examples.md`

## Citation

If you use `nf-bam2identity` in your work, please cite it as:

```bibtex
@software{nf_bam2identity,
  author = {Caridade, Lucas},
  title = {nf-bam2identity: a Nextflow mini-pipeline for IBS and IBD analyses from BAM files},
  url = {https://github.com/lc-blip/nf-bam2identity},
  year = {2026}
}
```
