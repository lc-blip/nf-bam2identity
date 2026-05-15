nextflow.enable.dsl=2

// 1. Params
params.bam_dir = ""
params.angsd     = [:]
params.ngsRelate = [:]

// 2. Process
process bam2identity_angsd {

    cpus { params.angsd.nThreads ?: 1 }
    
    input:
    path bams

    output:
    path("angsd_output*"), emit: angsd_results
    tuple path("angsd_output*"), path("n_samples.txt"), emit: angsd_for_ngsRelate

    script:
    def angsd_flags = params.angsd.collect { k, v -> "-${k} ${v}" }.join(" ")

    """
    # Creates the filelist 
    ls *.bam > all.filelist

    # Stores the number of BAM files/samples for ngsRelate
    wc -l < all.filelist > n_samples.txt

    # Running ANGSD to generate GL's.

    angsd -b all.filelist ${angsd_flags} -out angsd_output

    """

}

process bam2identity_ngsRelate {

    cpus { params.ngsRelate.p ?: 1 }

    input:
    tuple path(angsd_files), path(n_samples_file)

    output:
    path "ngsRelate_output*", emit: relate_results
    
    script:

    def relate_flags = params.ngsRelate.collect { k, v -> v != null ? "-${k} ${v}" : "" }.join(" ")

    """
    # Running ngsRelate

    # Extract allele frequency column for ngsRelate from .mafs.gz file
    zcat angsd_output.mafs.gz | cut -f5 | sed 1d > freqs

    echo "Extracting allele frequencies: "
    ls freqs

    # Obtain number of samples 
    n_samples=\$(cat ${n_samples_file})

    echo "Obtaining number of samples in GL file: "
    echo \$n_samples

    echo "Running ngsRelate."

    ngsRelate -g angsd_output.glf.gz \\
            -f freqs \\
            -n \$n_samples \\
            ${relate_flags} \\
            -O ngsRelate_output

    echo "Generated outputs: "
    ls ngsRelate_output*
    """

}

// 3. Workflow
workflow {
    main:

    // Preparar BAM processing channel
    bam_ch = channel.fromPath(params.bam_dir).collect()

    // Run angsd script
    bam2identity_angsd(bam_ch)

    // Run ngsRelate script
    bam2identity_ngsRelate(bam2identity_angsd.out.angsd_for_ngsRelate)

    publish:
    results_angsd = bam2identity_angsd.out.angsd_results
    results_relate = bam2identity_ngsRelate.out.relate_results

}

// 4. Output
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
