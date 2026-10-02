process MEGAHIT {
    tag "$sample_id"
    container 'quay.io/biocontainers/megahit:1.2.9--h43fd322_0'
    publishDir "${params.outdir}/megahit", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_megahit/${sample_id}.contigs.fa"), emit: contigs
    path "${sample_id}_megahit/opts.log"                                      , emit: log

    script:
    """
    megahit \\
        -1 ${reads[0]} -2 ${reads[1]} \\
        -o ${sample_id}_megahit \\
        --out-prefix ${sample_id} \\
        -t ${task.cpus} \\
        --min-contig-len 500
    """
}