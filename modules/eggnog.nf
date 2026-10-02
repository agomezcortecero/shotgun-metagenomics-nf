process EGGNOG_MAPPER {
    tag "$sample_id"
    label 'process_high'
    publishDir "${params.outdir}/functional/eggnog", mode: 'copy'

    input:
    tuple val(sample_id), path(contigs)
    path eggnog_db

    output:
    tuple val(sample_id), path("${sample_id}.emapper.annotations"), emit: annotations
    tuple val(sample_id), path("${sample_id}.emapper.seed_orthologs"), emit: seed_orthologs

    script:
    """
    emapper.py \
        -i ${contigs} \
        --output ${sample_id} \
        --cpu ${task.cpus} \
        --data_dir ${eggnog_db} \
        -m diamond
    """
}
