# Examples

## Run with default parameters

Create the default input folder and place your BAM files there:

```bash
mkdir -p bams
```

```bash
nextflow run main.nf -params-file params.yaml
```

## Run with BAMs in another folder

Edit `params.yaml`:

```yaml
bam_dir: "/path/to/my/bams/*.bam"
```

Then run:

```bash
nextflow run main.nf -params-file params.yaml
```

## Run only IBD-related analysis

To skip IBS matrix generation, remove or comment out these ANGSD options in `params.yaml`:

```yaml
angsd:
  # doIBS: 1
  # makeMatrix: 1
```

Then run:

```bash
nextflow run main.nf -params-file params.yaml -resume
```

## Run on SLURM

Edit `configs/slurm.config` for the target cluster, then run:

```bash
nextflow run main.nf -profile slurm -params-file params.yaml -resume
```
