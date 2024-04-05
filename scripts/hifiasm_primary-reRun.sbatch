#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=25
#SBATCH --mem 180G
#SBATCH --time=30:00:00
#SBATCH --output=%x.%A.out
#SBATCH --error=%x.%A.err
#SBATCH --job-name=hifiasm_primary

source ~/miniforge3/etc/profile.d/conda.sh
#eval "$(conda shell.bash hook)" # needed for slurm
conda activate assembly

PREFIX=primary
SVAL=0.1

# run hifiasm
cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX}

~/bin/hifiasm/hifiasm --primary -s $SVAL -o Atonsa.${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

#~/bin/hifiasm/hifiasm --primary -o Atonsa.${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

# change to fasta

# pull out log file info:

# convert to fasta
awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.asm.p_ctg.gfa > Atonsa.${PREFIX}.asm.p_ctg.gfa.fa

awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.asm.a_ctg.gfa > Atonsa.${PREFIX}.asm.a_ctg.gfa.fa

# get fasta stats
~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.asm.p_ctg.gfa.fa > Atonsa.${PREFIX}_${SVAL}.fasta_stats.primary.txt

~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.asm.a_ctg.gfa.fa > Atonsa.${PREFIX}_${SVAL}.fasta_stats.alternate.txt

# cp primary assembly bc will be overwritten by next run:
cp Atonsa.${PREFIX}.asm.p_ctg.gfa.fa Atonsa.${PREFIX}_${SVAL}.asm.p_ctg.gfa.fa
cp Atonsa.${PREFIX}.asm.a_ctg.gfa.fa Atonsa.${PREFIX}_${SVAL}.asm.a_ctg.gfa.fa

