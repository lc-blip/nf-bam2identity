# SLURM Profile

The SLURM profile lets the workflow run on an HPC cluster instead of running all processes locally.

Most users do not need this profile. If you are running on your own computer with Docker, use the default command:

```bash
nextflow run main.nf -params-file params.yaml
```

Use the SLURM profile only when your cluster uses the SLURM scheduler and provides the required software through environment modules.

## How to run

Edit `params.yaml` as usual for your BAM path and analysis parameters.

Then edit `configs/slurm.config` to match your cluster.

Run:

```bash
nextflow run main.nf -profile slurm -params-file params.yaml -resume
```

You can inspect the resolved SLURM configuration without submitting jobs:

```bash
nextflow config -profile slurm
```

## Important rule

Keep the optional `local_process_resources` block in `params.yaml` commented when using SLURM.

For SLURM runs, define CPU, memory, time, queue, modules, and other cluster options in:

```text
configs/slurm.config
```

This avoids defining compute resources in two different places.

## Queue

Set the SLURM partition/queue used by the jobs:

```groovy
params.slurm_queue = 'standard'
```

This is equivalent to a SLURM option such as:

```bash
#SBATCH --partition=standard
```

Cluster queue names vary. Common examples are `standard`, `short`, `long`, `compute`, or `highmem`, but you must use the names available on your cluster.

## Resources

Default resources are used as a fallback:

```groovy
params.slurm_default_cpus = 1
params.slurm_default_memory = '4 GB'
params.slurm_default_time = '02:00:00'
```

ANGSD resources:

```groovy
params.slurm_angsd_cpus = 4
params.slurm_angsd_memory = '16 GB'
params.slurm_angsd_time = '06:00:00'
```

ngsRelate resources:

```groovy
params.slurm_ngsrelate_cpus = 4
params.slurm_ngsrelate_memory = '8 GB'
params.slurm_ngsrelate_time = '04:00:00'
```

The CPU values also control the number of threads passed to the tools:

```text
ANGSD     -> -nThreads
ngsRelate -> -p
```

Do not set `nThreads` under `angsd` or `p` under `ngsRelate` in `params.yaml`.

## Software modules

The default SLURM profile assumes ANGSD and ngsRelate are available as environment modules.

The module names below are examples:

```groovy
params.slurm_angsd_module = 'angsd/0.940'
params.slurm_ngsrelate_module = 'ngsrelate/2.0'
```

Replace them with the actual module names available on the cluster where you are running the workflow.

Module names vary between clusters. Check the available modules on your HPC system, for example:

```bash
module avail angsd
module avail ngsrelate
```

Then replace the module names in `configs/slurm.config` if needed.

## Optional SLURM settings

Some clusters require an account, QoS, constraint, or email notifications.

Leave unused options as `null`:

```groovy
params.slurm_account = null
params.slurm_qos = null
params.slurm_constraint = null
params.slurm_mail_user = null
params.slurm_mail_type = 'END,FAIL'
params.slurm_extra_options = []
```

Example with an account:

```groovy
params.slurm_account = 'my_project'
```

Example with QoS:

```groovy
params.slurm_qos = 'normal'
```

Example with a constraint:

```groovy
params.slurm_constraint = 'my_constraint'
```

Example with email notifications:

```groovy
params.slurm_mail_user = 'your.email@example.com'
params.slurm_mail_type = 'END,FAIL'
```

Example with extra SLURM options:

```groovy
params.slurm_extra_options = ['--nodes=1']
```

Only add options that your cluster supports.

## Containers and modules

The local profile uses Docker containers.

The SLURM profile disables Docker and uses modules instead:

```groovy
docker.enabled = false
container = null
module = params.slurm_angsd_module
```

This keeps local execution and HPC execution separate.

The current SLURM profile does not configure Apptainer or Singularity. It is intentionally kept module-based for now.

## Logs

Nextflow creates task logs inside the `work/` directory.

Useful files inside each task directory include:

```text
.command.sh
.command.out
.command.err
.command.log
```

For run-level summaries, use:

```bash
nextflow run main.nf \
  -profile slurm \
  -params-file params.yaml \
  -resume \
  -with-report \
  -with-trace \
  -with-timeline
```
