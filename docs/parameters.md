# Parameters

Most users should only edit `params.yaml`.

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

## Optional local resources

Local execution uses default resources from `nextflow.config`. Most users can leave them unchanged.

If you are running locally and want to change CPU, memory, or time settings, uncomment the optional `local_process_resources` block in `params.yaml`:

```yaml
# local_process_resources:
#   default:
#     cpus: 1
#     memory: "4 GB"
#     time: "02:00:00"
#
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

The commands use `task.cpus` internally, so the number of tool threads always matches the CPUs requested by Nextflow.

Do not use `local_process_resources` for SLURM runs. For SLURM, define CPU, memory, time, queue, modules, and other cluster settings in `configs/slurm.config`.

Advanced users may edit `nextflow.config` or `configs/slurm.config` to change execution backends, containers, modules, or cluster-specific options.
