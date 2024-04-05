#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=ALL
#SBATCH --mail-user=reid.brennan@gmail.com
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem 30G
#SBATCH --time=48:00:00
#SBATCH --output=%x.%A.out
#SBATCH --error=%x.%A.err
#SBATCH --job-name=bamtofastq

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hiRise_v2

echo "sorting started"

samtools sort -n DTG-OmniC-468_R1_001.bam -o DTG-OmniC-468_R1_001.bam_sorted.bam

echo "sorting done"

echo "bam to fastq started"

bedtools bamtofastq -i DTG-OmniC-468_R1_001.bam_sorted.bam -fq atonsa_omni.R1.fastq -fq2 atonsa_omni.R2.fastq
