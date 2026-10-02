/*
========================================================================================
    Shotgun Metagenomics Nextflow DSL2 Pipeline
========================================================================================
    Description: End-to-end modular pipeline for shotgun metagenomics (QC, Taxonomy,
                 Assembly, Functional Annotation & Coverage).
========================================================================================
*/

nextflow.enable.dsl = 2

// Include modules
include { FASTP }                       from './modules/fastp'
include { MOTUS_PROFILE; MOTUS_MERGE }  from './modules/motus'
include { MEGAHIT }                     from './modules/megahit'
include { EGGNOG_MAPPER }               from './modules/eggnog'
include { COVERM }                      from './modules/coverm'
include { MULTIQC }                     from './modules/multiqc'

workflow {

    // 1. Channel creation from read pairs
    ch_reads = Channel.fromFilePairs(params.reads, checkIfExists: true)

    // 2. Read Quality Control & Trimming (fastp)
    FASTP(ch_reads)

    // 3. Taxonomic Profiling (mOTUs)
    MOTUS_PROFILE(FASTP.out.reads)
    ch_motus_profiles = MOTUS_PROFILE.out.profile.map { sample_id, profile -> profile }.collect()
    MOTUS_MERGE(ch_motus_profiles)

    // 4. De novo Metagenomic Assembly (MEGAHIT)
    MEGAHIT(FASTP.out.reads)

    // 5. Functional Annotation (EggNOG-mapper)
    ch_eggnog_db = file(params.eggnog_db)
    EGGNOG_MAPPER(MEGAHIT.out.contigs, ch_eggnog_db)

    // 6. Contig Abundance & Coverage Quantification (CoverM)
    ch_coverm_input = FASTP.out.reads.join(MEGAHIT.out.contigs)
    COVERM(ch_coverm_input)

    // 7. MultiQC Aggregate Report
    ch_multiqc_inputs = FASTP.out.json.collect()
    MULTIQC(ch_multiqc_inputs)
}
