#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=25
#SBATCH --mem 160G
#SBATCH --time=40:00:00
#SBATCH --output=%x.%A.%a.out
#SBATCH --error=%x.%A.%a.err
#SBATCH --job-name=hifiasm_default

source ~/miniforge3/etc/profile.d/conda.sh
#eval "$(conda shell.bash hook)" # needed for slurm
conda activate assembly
PREFIX=Atonsa_default

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/

~/bin/hifiasm/hifiasm -o ${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz 
