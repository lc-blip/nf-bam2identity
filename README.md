# nf-bam2identity

**Work in Progress:** This repository is currently under active development.

A mini-pipeline focused around using ANGSD and Nextflow to analyse Identity by State (IBS) and Identity by Descent (IBD) from BAM files.

## Prerequisites

To run this pipeline, you don't need to install complex bioinformatics tools locally. You only need:

* **[Docker](https://docs.docker.com/get-docker/):** To run ANGSD and ngsRelate in isolated, reproducible containers.
* **[Conda](https://docs.conda.io/en/latest/) (or Mamba):** To create the environment that runs Nextflow.

## Getting Started

*Note: The pipeline code is currently being written. These instructions represent the intended workflow.*

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

This file controls the input BAM path, ANGSD parameters, and ngsRelate parameters.

By default, the pipeline expects BAM files inside the `bams/` folder:

```yaml
bam_dir: "bams/*.bam"
```

### 4. Prepare your input BAM files

Make sure your BAM files are in the directory defined by `bam_dir` in `params.yaml`.

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

Inside the `nf-bam2identity` folder, run:

```bash
nextflow run main.nf -params-file params.yaml
```

### 6. Consult your results

Results will be written to:

```text
final_output/
├── angsd/
└── ngsRelate/
```

Intermediate Nextflow files and logs can be found in:

```text
work/
```

## Parameters

Pipeline parameters are defined in `params.yaml`.

The file is divided into three main sections:

### Input BAM files

Defines the path to the BAM files that will be analysed.

```yaml
bam_dir: "bams/*.bam"
```

### ANGSD parameters

Controls genotype likelihood estimation, allele frequency estimation, SNP filtering, read and base quality filtering, and IBS matrix generation.

Some important default parameters include:

```yaml
angsd:
  nThreads: 4
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

The default configuration uses:

```yaml
ngsRelate:
  p: 4 # Number of threads used by ngsRelate
```

For most use cases, edit `params.yaml` directly rather than changing `main.nf`.

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