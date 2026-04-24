# Development Journal: nf-bam2identity
**Date:** April 24, 2026

## Today's Achievements

**1. Project Conceptualization & Architecture**
* Decided to transition a legacy bash script for calculating IBS/IBD from BAM files using ANGSD into a modern, reproducible pipeline.
* Chose the industry-standard architecture: **Nextflow** for orchestration and **Docker** for dependency isolation.
* Defined the division of labor: Conda manages Nextflow (the manager), while Docker handles ANGSD and its complex C++ dependencies (the worker).
* Settled on a professional project name: `nf-bam2identity`.

**2. Repository Setup & Version Control**
* Initialized a local Git repository and created the foundational files (`main.nf`, `nextflow.config`, `README.md`, `environment.yaml`).
* Created a public GitHub repository and successfully linked the local codebase to the remote origin.
* Overcame the fear of working in public by adopting a "Work in Progress" mindset.

**3. Environment & Dependency Management**
* Encountered a classic bioinformatics shared library error (`libhts.so.1`) when trying to run ANGSD locally via Conda, proving exactly why Docker is necessary.
* Cleaned up the local Conda environment by removing local installations of `angsd` and `htslib`.
* Created a clean, portable `environment.yaml` file (fixing a hardcoded local `prefix:` path issue to ensure the project is shareable).
* Set up Docker on the local Linux machine, configured user permissions (`usermod -aG docker`), and successfully ran the `hello-world` test.

**4. Best Practices & Documentation**
* Learned about VS Code creating local `.vscode` configuration folders and how they shouldn't be committed.
* Created a `.gitignore` file to keep the repository clean from local editor settings and heavy Nextflow execution folders (`work/`, `.nextflow/`).
* Wrote and pushed a clean, professional `README.md` with project descriptions, prerequisites, and a "🚧 Work in Progress" banner.

## Next Steps for Tomorrow
* Write the actual Nextflow code in `main.nf`.
* Test the connection between Nextflow and the ANGSD Docker container.
