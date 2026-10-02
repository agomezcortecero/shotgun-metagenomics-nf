#!/usr/bin/env bash
# ==============================================================================
# Execution script for launching the Shotgun Metagenomics Pipeline on AWS Batch
# ==============================================================================

set -euo pipefail

# Configuration variables
S3_BUCKET="s3://your-metagenomics-bucket"
INPUT_PATTERN="${S3_BUCKET}/raw_reads/*_R{1,2}.fastq.gz"
OUTDIR="${S3_BUCKET}/results/$(date +%Y%m%d_%H%M%S)"
CONFIG_PROFILE="awsbatch"

echo "======================================================================"
echo " Launching Shotgun Metagenomics Pipeline on AWS Batch"
echo " Input:  ${INPUT_PATTERN}"
echo " Output: ${OUTDIR}"
echo " Profile: ${CONFIG_PROFILE}"
echo "======================================================================"

# Execute Nextflow pipeline
nextflow run main.nf \
    --input "${INPUT_PATTERN}" \
    --outdir "${OUTDIR}" \
    -profile "${CONFIG_PROFILE}" \
    -resume

echo "Pipeline execution submitted successfully to AWS Batch!"
