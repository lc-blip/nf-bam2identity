# nf-bam2identity

**Work in Progress:** This repository is currently under active development.

A mini-pipeline focused around using ANGSD and Nextflow to analyse Identity by State (IBS) and Identity by Descent (IBD) from BAM files.

## Prerequisites

To run this pipeline, you don't need to install complex bioinformatics tools locally. You only need:

* **[Docker](https://docs.docker.com/get-docker/):** To run the ANGSD software in an isolated, reproducible container.
* **[Conda](https://docs.conda.io/en/latest/) (or Mamba):** To easily create the environment that runs Nextflow.

## Getting Started

*Note: The pipeline code is currently being written. These instructions represent the intended workflow.*

**1. Clone the repository**
```bash
git clone https://github.com/lc-blip/nf-bam2identity.git
cd nf-bam2identity
