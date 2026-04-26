nextflow.enable.dsl=2

// 1. Params
params {
    input: Path = ""
}

// 2. Process
process bam2identity {
    input:
    path bams

    output:
    path "angsd_output*", emit: angsd_results
    path "ngsRelate_output*", emit: relate_results

    script:
    """
    # Criar o filelist dinamicamente com os BAMs que o Nextflow injetou na pasta
    ls *.bam > all.filelist

    # ANGSD filters -> https://www.popgen.dk/angsd/index.php/Filters

    # Runing ANGSD to generate GL's.

    angsd -b all.filelist \\
            -GL 1 \\
            -doGlf 3 \\
            -doMajorMinor 1 \\
            -doMaf 1 \\
            -minMaf 0.05 \\
            -minMapQ 30 \\
            -minQ 20 \\
            -remove_bads 1 \\
            -only_proper_pairs 1 \\
            -uniqueOnly 1 \\
            -out angsd_output


    # Running ngsRelate

    # Extract allele frequency column for NGSrelate from .mafs.gz file
    zcat angsd_output.mafs.gz | cut -f5 | sed 1d > freqs

    echo "Extracting allele frequencies: "
    ls freqs

    # Obtain number of samples in the glf.gz file
    n_samples=\$(wc -l < all.filelist)

    echo "Obtaining number of samples in GL's file: "
    echo \$n_samples

    # ngsRelate filters -> https://github.com/angsd/ngsrelate

    echo "Running ngsRelate."

    ngsRelate -g angsd_output.glf.gz \\
            -f freqs \\
            -n \$n_samples \\
            -O ngsRelate_output

    echo "Generated outputs: "
    ls ngsRelate_output*


    """

}
// 3. Workflow
workflow {
    main:

    // Preparare Bam processing channel
    bam_ch = channel.fromPath(params.input).collect()

    // Run full script
    bam2identity(bam_ch)

    publish:
    results_angsd = bam2identity.out.angsd_results
    results_relate = bam2identity.out.relate_results

}

// 4. Ouput
output {
    results_angsd {
        path "final_output/angsd"
        mode 'copy'
    }
    results_relate {
        path "final_output/ngsRelate"
        mode 'copy'
    }
}