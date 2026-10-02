process FASTP {
    tag "$sample_id"
    label 'process_medium'
    publishDir "${params.outdir}/qc/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_R1.clean.fq.gz"), path("${sample_id}_R2.clean.fq.gz"), emit: reads
    path "${sample_id}.fastp.json"                                                                  , emit: json
    path "${sample_id}.fastp.html"                                                                  , emit: html

    script:
    """
    fastp \
        --in1 ${reads[0]} \
        --in2 ${reads[1]} \
        --out1 ${sample_id}_R1.clean.fq.gz \
        --out2 ${sample_id}_R2.clean.fq.gz \
        --json ${sample_id}.fastp.json \
        --html ${sample_id}.fastp.html \
        --thread ${task.cpus} \
        --detect_adapter_for_pe
    """
}
