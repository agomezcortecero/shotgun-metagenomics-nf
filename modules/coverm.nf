process COVERM {
    tag "$sample_id"
    label 'process_high'
    publishDir "${params.outdir}/functional/coverm", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2), path(contigs)

    output:
    tuple val(sample_id), path("${sample_id}_coverage_values.txt"), emit: coverage

    script:
    """
    coverm contig \
        -1 ${r1} \
        -2 ${r2} \
        -r ${contigs} \
        -o ${sample_id}_coverage_values.txt \
        -t ${task.cpus} \
        --methods mean tpm
    """
}
