#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --output=%x.%A.%a.out
#SBATCH --error=%x.%A.%a.err
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem 120G
#SBATCH --time=10:00:00
#SBATCH --job-name=fastk

source ~/miniforge3/etc/profile.d/conda.sh
conda activate assembly

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish

# using 4 threads
FastK -v -t4 -k31 -M16 -P/gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish/ \
-N/gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish/FastK_Table -T4 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*.fastq.gz 

