# Shotgun Metagenomics Nextflow DSL2 Pipeline

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A1%EF%B8%8E%2022.10.6-brightgreen.svg)](https://www.nextflow.io/)
[![Docker](https://img.shields.io/badge/containers-Docker%2FSingularity-blue.svg)](https://www.docker.com/)
[![AWS Batch](https://img.shields.io/badge/cloud-AWS%20Batch-orange.svg)](https://aws.amazon.com/batch/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A scalable, containerized **Nextflow DSL2** pipeline for end-to-end processing of **shotgun metagenomics** data. Designed for high-throughput execution across local environments, HPC clusters (SLURM), and AWS Cloud (AWS Batch & S3).

---

## 🧬 Workflow Overview

```
                        +----------------------+
                        | Raw FASTQ Read Pairs |
                        +----------+-----------+
                                   |
                                   v
                      +--------------------------+
                      | FASTP: Quality Filtering |
                      +------------+-------------+
                                   |
          +------------------------+------------------------+
          |                        |                        |
          v                        v                        v
+-------------------+    +--------------------+    +------------------+
| mOTUs: Taxonomic  |    | MEGAHIT: De Novo   |    | CoverM: Coverage |
|    Profiling      |    |     Assembly       |    |  Quantification  |
+---------+---------+    +---------+----------+    +--------+---------+
          |                        |                        |
          |                        v                        |
          |              +-------------------+              |
          |              | EggNOG-mapper:    |              |
          |              | Functional Annot. |              |
          |              +---------+---------+              |
          |                        |                        |
          +------------------------+------------------------+
                                   |
                                   v
                      +--------------------------+
                      | MULTIQC: Combined Report |
                      +--------------------------+
```

### Key Analytical Steps:
1. **Read QC & Filtering (`fastp`):** Adapter trimming, Phred quality filtering ($Q \ge 20$), and length filtering.
2. **Taxonomic Profiling (`mOTUs v3`):** Marker-gene profiling for bacterial, archaeal, and eukaryotic quantification.
3. **De Novo Assembly (`MEGAHIT`):** High-efficiency metagenomic assembly of short reads into contigs.
4. **Functional Annotation (`EggNOG-mapper`):** Gene prediction and functional mapping (KEGG pathways, GO terms, COGs).
5. **Coverage & Abundance (`CoverM`):** Mapping clean reads back to contigs for TPM and mean coverage metrics.
6. **QC Aggregation (`MultiQC`):** Consolidated HTML quality diagnostic report across all processed samples.

---

## 📁 Repository Structure

```
shotgun-metagenomics-nf/
├── main.nf                 # Main workflow entrypoint (DSL2 architecture)
├── nextflow.config         # Global parameters, Docker containers, and execution profiles
├── run_awsbatch.sh         # Bash execution wrapper for AWS Batch submission
├── modules/                # Modular DSL2 process components
│   ├── fastp.nf
│   ├── motus.nf
│   ├── megahit.nf
│   ├── eggnog.nf
│   ├── coverm.nf
│   └── multiqc.nf
├── terraform/              # Infrastructure as Code (IaC) for AWS Batch & S3
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
└── .github/
    └── workflows/          # GitHub Actions CI syntax verification
        └── ci.yml
```

---

## 🚀 Quick Start

### Prerequisites
- **Nextflow** ($\ge 22.10.6$)
- **Docker** or **Singularity** (no tool installation required; containers auto-pull from Biocontainers)

### 1. Local / Server Execution (Docker)
```bash
nextflow run main.nf \
    --input 'data/*_R{1,2}.fastq.gz' \
    --outdir 'results' \
    -profile docker
```

### 2. HPC Cluster Execution (SLURM)
```bash
nextflow run main.nf \
    --input '/path/to/reads/*_R{1,2}.fastq.gz' \
    --outdir '/path/to/results' \
    -profile slurm,singularity
```

### 3. AWS Cloud Execution (AWS Batch & S3)
```bash
# Using the provided helper script
./run_awsbatch.sh

# Or directly via Nextflow CLI
nextflow run main.nf \
    --input 's3://my-bucket/raw_reads/*_R{1,2}.fastq.gz' \
    --outdir 's3://my-bucket/results' \
    -profile awsbatch
```

---

## 🏗️ Infrastructure as Code (IaC) with Terraform

To deploy the AWS Batch compute environment, S3 buckets, and IAM roles required for this pipeline, check the `terraform/` directory:

```bash
cd terraform
terraform init
terraform apply
```

See [`terraform/README.md`](terraform/README.md) for step-by-step setup details.

---

## 👨‍💻 Author

**Antonio Gómez Cortecero, Ph.D.**  
Bioinformatics & Data Engineering Specialist  
[LinkedIn](https://linkedin.com/in/antoniogomezcortecero) | [ORCID](https://orcid.org/0000-0002-3162-4309)

---
## 📄 License
Licensed under the [MIT License](LICENSE).
