process COVERM {
    tag "$sample_id"
    container 'quay.io/biocontainers/coverm:0.6.1--h07ea139_1'
    publishDir "${params.outdir}/coverm", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    tuple val(sample_id), path(contigs)

    output:
    path "${sample_id}_coverage.tsv", emit: coverage

    script:
    """
    coverm contig \\
        -1 ${reads[0]} -2 ${reads[1]} \\
        -r ${contigs} \\
        -m tpm mean coverage \\
        -t ${task.cpus} \\
        -o ${sample_id}_coverage.tsv
    """
}