# Shotgun Metagenomics Nextflow DSL2 Pipeline

[![Nextflow](https://img.shields.io/badge/Nextflow-DSL2-brightgreen)](https://www.nextflow.io/)
[![Docker](https://img.shields.io/badge/Containers-Docker%20%7C%20Singularity-blue)](https://www.docker.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modular, production-grade **Nextflow DSL2** pipeline for end-to-end processing of shotgun metagenomics sequencing data. Designed for reproducibility, high performance, and cloud/HPC portability (AWS Batch, SLURM, Docker, Singularity).

---

## 🧬 Pipeline Overview

The pipeline automates the following key metagenomic processing steps:

1. **Quality Control & Trimming:** `fastp` filters low-quality bases and automatically removes adapter sequences.
2. **Taxonomic Profiling:** `mOTUs v3` profiles marker gene operational taxonomic units from cleaned reads and generates a merged count table.
3. **De Novo Assembly:** `MEGAHIT` constructs metagenomic contigs from paired reads.
4. **Functional Annotation:** `EggNOG-mapper` annotates assembled contigs using the EggNOG orthology database.
5. **Coverage & Abundance Quantification:** `CoverM` maps trimmed reads back to assembly contigs to calculate mean coverage and TPM values.
6. **QC Aggregation:** `MultiQC` aggregates metrics across all samples into an interactive HTML report.

---

## 🚀 Quick Start

### Prerequisites
- [Nextflow](https://www.nextflow.io/) (v21.04.0 or higher)
- [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/singularity/)

### Run the Pipeline

```bash
# Clone the repository
git clone https://github.com/your-username/shotgun-metagenomics-nf.git
cd shotgun-metagenomics-nf

# Run with Docker on local sample data
nextflow run main.nf \
  --reads "data/*_{1,2}.fastq.gz" \
  --eggnog_db "/path/to/eggnog_db" \
  --outdir "results" \
  -profile docker
```

---

## ☁️ Cloud & HPC Execution

### Run on SLURM Cluster
```bash
nextflow run main.nf -profile slurm,singularity --reads "s3://my-bucket/reads/*_{1,2}.fq.gz"
```

### Run on AWS Batch
```bash
nextflow run main.nf -profile awsbatch --reads "s3://my-bucket/reads/*_{1,2}.fq.gz"
```

---

## 📁 Repository Structure

```
shotgun-metagenomics-nf/
├── main.nf                 # Main workflow entry point
├── nextflow.config         # Global configuration, containers & profiles
├── modules/                # Modular DSL2 process definitions
│   ├── fastp.nf
│   ├── motus.nf
│   ├── megahit.nf
│   ├── eggnog.nf
│   ├── coverm.nf
│   └── multiqc.nf
└── README.md               # Pipeline documentation
```

---

## ✍️ Author & License

Developed by **Antonio Gómez Cortecero, Ph.D.**  
Licensed under the [MIT License](LICENSE).
