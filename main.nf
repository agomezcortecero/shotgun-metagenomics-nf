nextflow.enable.dsl=2

/*
========================================================================================
    Shotgun Metagenomics Nextflow DSL2 Pipeline
========================================================================================
*/

include { FASTP }       from './modules/fastp'
include { MOTUS }       from './modules/motus'
include { MEGAHIT }     from './modules/megahit'
include { EGGNOG }      from './modules/eggnog'
include { COVERM }      from './modules/coverm'
include { MULTIQC }     from './modules/multiqc'

workflow {
    ch_raw_reads = Channel.fromFilePairs(params.input, checkIfExists: true)

    // Step 1: Quality Control & Filtering
    FASTP(ch_raw_reads)

    // Step 2: Taxonomic Profiling with mOTUs
    MOTUS(FASTP.out.reads)

    // Step 3: De Novo Metagenomic Assembly
    MEGAHIT(FASTP.out.reads)

    // Step 4: Functional Annotation
    EGGNOG(MEGAHIT.out.contigs)

    // Step 5: Contig Coverage & Abundance Quantification
    COVERM(FASTP.out.reads, MEGAHIT.out.contigs)

    // Step 6: MultiQC Consolidated Quality Report
    ch_multiqc_files = FASTP.out.json.mix(MOTUS.out.report).mix(MEGAHIT.out.log)
    MULTIQC(ch_multiqc_files.collect())
}
