#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=ALL
#SBATCH --mail-user=reid.brennan@gmail.com
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=25
#SBATCH --mem 180G
#SBATCH --time=30:00:00
#SBATCH --output=%x.%A.out
#SBATCH --error=%x.%A.err
#SBATCH --job-name=hifiasm_hicInt

source ~/miniforge3/etc/profile.d/conda.sh
#eval "$(conda shell.bash hook)" # needed for slurm
conda activate assembly

PREFIX=hic_integrated
SVAL=0.55

# run hifiasm
cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX}

~/bin/hifiasm/hifiasm --primary -s $SVAL -o Atonsa.${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

OMNIC_R1=/gxfs_work/geomar/smomw504/acartia_tonsa_genome_hiRise_v2/atonsa_omni.R1.fastq
OMNIC_R2=/gxfs_work/geomar/smomw504/acartia_tonsa_genome_hiRise_v2/atonsa_omni.R2.fastq

hifiasm -t 25 -o Atonsa.${PREFIX} \
        --primary \
        -s $SVAL \
        --h1 $OMNIC_R1 \
        --h2 $OMNIC_R2 \
        /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

