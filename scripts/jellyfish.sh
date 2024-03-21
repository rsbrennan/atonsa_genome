#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem 120G
#SBATCH --time=20:00:00
#SBATCH --output=%x.%A.%a.out
#SBATCH --error=%x.%A.%a.err
#SBATCH --job-name=jellyfish

source ~/miniforge3/etc/profile.d/conda.sh
#eval "$(conda shell.bash hook)" # needed for slurm
conda activate assembly

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish

#zcat /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*.fastq.gz |\
#jellyfish count /dev/fd/0 -C -m 21 -s 1000000000 -t 10 -o reads.jf

jellyfish histo -t 10 --high=10000000 reads.jf > reads.histo
