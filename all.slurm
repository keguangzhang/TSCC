#!/bin/bash

#SBATCH --partition=hotel

#SBATCH --nodes=1

#SBATCH --ntasks-per-node=1

#SBATCH --time=00:10:00

#SBATCH --account=htl108

#SBATCH --qos=hotel

module load py-cutadapt/2.10-rclcert
cutadapt -a CTGTAGGCACCATCAAT -m 18 -M 32 -o Inputs/aftercutadapt/output134.fastq Inputs/inputfastq/SRR5008134.fastq.gz
# Cutadapt cut adaptor sequence. See cutadapt manual for command line and option description.
    
module load bowtie/1.3.0-lefzv2n
bowtie -y -a --best --strata Indexes/rDNA Inputs/aftercutadapt/output134.fastq Inputs/useless134.fastq --un Inputs/afterbowtie1/134.fastq
bowtie --chunkmbs 512 -y -a -m 1 -p 8 --best --strata Indexes/genome Inputs/afterbowtie1/134.fastq Inputs/afterbowtie2/134.fastq
# Align sequence to rDNA and genome respectively not reporting reads that have more then 1 alignments. 
# See cutadapt manual for command line and option description

module load python/3.8.12-bha4gif #load python3
python3 Inputs/FeatureCounts.py Inputs/afterfeaturecounts/134 Inputs/afterbowtie2/134.fastq Inputs/Chrom/
#align sequence to genes and count number

python3 Inputs/polarity.py Inputs/afterfeaturecounts/ Inputs/afterpolarity/
#calculate polarity
