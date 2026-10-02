process FASTP {
    tag "$sample_id"
    container 'biocontainers/fastp:0.23.2--h5bf99c5_0'
    publishDir "${params.outdir}/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_clean_R*.fastq.gz"), emit: reads
    path "${sample_id}_fastp.json"                               , emit: json
    path "${sample_id}_fastp.html"                               , emit: html

    script:
    """
    fastp \\
        -i ${reads[0]} -I ${reads[1]} \\
        -o ${sample_id}_clean_R1.fastq.gz -O ${sample_id}_clean_R2.fastq.gz \\
        -j ${sample_id}_fastp.json -h ${sample_id}_fastp.html \\
        --thread ${task.cpus} \\
        --qualified_quality_phred 20 \\
        --length_required 50
    """
}