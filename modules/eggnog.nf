process EGGNOG {
    tag "$sample_id"
    container 'quay.io/biocontainers/eggnog-mapper:2.1.9--pyhdfd78af_0'
    publishDir "${params.outdir}/eggnog", mode: 'copy'

    input:
    tuple val(sample_id), path(contigs)

    output:
    path "${sample_id}.emapper.annotations", emit: annotations

    script:
    """
    emapper.py \\
        -i ${contigs} \\
        --output ${sample_id} \\
        --cpu ${task.cpus} \\
        -m diamond \\
        --data_dir ${params.eggnog_db}
    """
}