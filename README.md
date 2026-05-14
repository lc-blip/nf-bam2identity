# nf-bam2identity

**Work in Progress:** This repository is currently under active development.

A mini-pipeline focused around using ANGSD and Nextflow to analyse Identity by State (IBS) and Identity by Descent (IBD) from BAM files.

## Prerequisites

To run this pipeline, you don't need to install complex bioinformatics tools locally. You only need:

* **[Docker](https://docs.docker.com/get-docker/):** To run the ANGSD and ngsRelate software in an isolated, reproducible container.
* **[Conda](https://docs.conda.io/en/latest/) (or Mamba):** To easily create the environment that runs Nextflow.

## Getting Started

*Note: The pipeline code is currently being written. These instructions represent the intended workflow.*

**1. Clone the repository**
```bash
git clone https://github.com/lc-blip/nf-bam2identity.git
cd nf-bam2identity
```

**2. Activate the conda environment**
```bash
conda env create -f environment.yaml -n nf_bam2identity
conda activate nf_bam2identity
```

**3. Define paths and parameters inside params.yaml**

Open the **params.yaml** file with your prefered text editor and follow the instructions found inside.

**4. Run the nextflow script**

Inside the **nf-bam2identity** folder run the following command:
```bash
nextflow run main.nf -params-file params.yaml
```

**5. Consult you results**

The results will be found inside the folder **nf-bam2identity/results**.

Additional logs can be found inside **nf-bam2identity/work**.






