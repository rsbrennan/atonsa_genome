#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=ALL
#SBATCH --mail-user=reid.brennan@gmail.com
#SBATCH --partition=highmem
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=25
#SBATCH --mem 540G
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

# ~/bin/hifiasm/hifiasm --primary -s $SVAL -o Atonsa.${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

OMNIC_R1=/gxfs_work/geomar/smomw504/OmniC_reads/DTG-OmniC-468_R1_001.fastq.gz
OMNIC_R2=/gxfs_work/geomar/smomw504/OmniC_reads/DTG-OmniC-468_R2_001.fastq.gz

~/bin/hifiasm/hifiasm -t 25 -o Atonsa.${PREFIX} \
        --primary \
        -s $SVAL \
        --h1 $OMNIC_R1 \
        --h2 $OMNIC_R2 \
        /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

# convert to fasta
awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.hic.hap1.p_ctg.gfa > Atonsa.${PREFIX}.hic.hap1.p_ctg.gfa.fa

awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.hic.hap2.p_ctg.gfa > Atonsa.${PREFIX}.hic.hap2.p_ctg.gfa.fa

awk '/^S/{print ">"$2;print $3}' Atonsa.hic_integrated.hic.p_ctg.gfa > Atonsa.${PREFIX}.hic.primary.p_ctg.gfa.fa


# get fasta stats
~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.hic.hap1.p_ctg.gfa.fa  > Atonsa.${PREFIX}_${SVAL}.fasta_stats.primary.txt

~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.hic.hap2.p_ctg.gfa.fa > Atonsa.${PREFIX}_${SVAL}.fasta_stats.alternate.txt

# cp primary assembly bc will be overwritten by next run:
cp Atonsa.${PREFIX}.hic.hap1.p_ctg.gfa.fa Atonsa.${PREFIX}_${SVAL}.hic.hap1.p_ctg.gfa.fa
cp Atonsa.${PREFIX}.hic.hap2.p_ctg.gfa.fa Atonsa.${PREFIX}_${SVAL}.hic.hap2.p_ctg.gfa.fa

