process MOTUS_PROFILE {
    tag "$sample_id"
    label 'process_medium'
    publishDir "${params.outdir}/taxonomy/mOTUs", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)

    output:
    tuple val(sample_id), path("${sample_id}.motus_results.tsv"), emit: profile

    script:
    """
    motus profile \
        -f ${r1} \
        -r ${r2} \
        -n ${sample_id} \
        -o ${sample_id}.motus_results.tsv \
        -t ${task.cpus}
    """
}

process MOTUS_MERGE {
    publishDir "${params.outdir}/taxonomy/merged", mode: 'copy'

    input:
    path profiles

    output:
    path "merged_motus_profile.tsv", emit: merged_profile

    script:
    """
    motus merge \
        -i ${profiles.join(',')} \
        -o merged_motus_profile.tsv
    """
}
