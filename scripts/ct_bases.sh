#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem 40G
#SBATCH --time=12:00:00
#SBATCH --output=/gxfs_home/geomar/smomw504/tonsa_genome/log_out/%x.%A.%a.out
#SBATCH --error=/gxfs_home/geomar/smomw504/tonsa_genome/log_out/%x.%A.%a.err
#SBATCH --job-name=seqCT

source ~/miniforge3/etc/profile.d/conda.sh
conda activate assembly

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2

seqkit -j 4 stats *.fastq.gz
