process MOTUS {
    tag "$sample_id"
    container 'quay.io/biocontainers/motus:3.1.0--pyhdfd78af_0'
    publishDir "${params.outdir}/motus", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_motus.tsv"), emit: profile
    path "${sample_id}_motus.log"                       , emit: report

    script:
    """
    motus profile \\
        -f ${reads[0]} -r ${reads[1]} \\
        -n ${sample_id} \\
        -o ${sample_id}_motus.tsv \\
        -t ${task.cpus} > ${sample_id}_motus.log
    """
}