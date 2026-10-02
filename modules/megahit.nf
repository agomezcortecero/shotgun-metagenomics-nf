process MEGAHIT {
    tag "$sample_id"
    label 'process_high'
    publishDir "${params.outdir}/assembly/megahit", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)

    output:
    tuple val(sample_id), path("${sample_id}/${sample_id}.contigs.fa"), emit: contigs

    script:
    """
    megahit \
        -1 ${r1} \
        -2 ${r2} \
        --num-cpu-threads ${task.cpus} \
        --out-dir ${sample_id} \
        --out-prefix ${sample_id}
    """
}
