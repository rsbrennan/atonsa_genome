#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=ALL
#SBATCH --mail-user=reid.brennan@gmail.com
#SBATCH --partition=base
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 80G
#SBATCH --time=00:30:00
#SBATCH --output=%x.%A.out
#SBATCH --error=%x.%A.err
#SBATCH --job-name=hifiStats

# Move into directory:
cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX}

# pull out log file info:

cat ~/tonsa_genome/log_out/hifiasm_primary.${JID_HIFI}.err | grep "peak_hom" | tail -1 >> Atonsa.${PREFIX}.hifiasm_summary.txt

cat ~/tonsa_genome/log_out/hifiasm_primary.${JID_HIFI}.err | grep "homozygous read coverage threshold" | tail -1 >> Atonsa.${PREFIX}.hifiasm_summary.txt

cat ~/tonsa_genome/log_out/hifiasm_primary.${JID_HIFI}.err | grep "purge duplication coverage threshold" | tail -1 >> Atonsa.${PREFIX}.hifiasm_summary.txt

# convert to fasta
awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.asm.p_ctg.gfa > Atonsa.${PREFIX}.asm.p_ctg.gfa.fa

awk '/^S/{print ">"$2;print $3}' Atonsa.${PREFIX}.asm.a_ctg.gfa > Atonsa.${PREFIX}.asm.a_ctg.gfa.fa

# get fasta stats
~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.asm.p_ctg.gfa.fa > Atonsa.${PREFIX}.fasta_stats.primary.txt

~/bin/fasta_stats/bin/fasta_stats Atonsa.${PREFIX}.asm.a_ctg.gfa > Atonsa.${PREFIX}.fasta_stats.alternate.txt
