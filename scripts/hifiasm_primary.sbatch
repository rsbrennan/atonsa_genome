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

#PREFIX=primary

# check if the directory exists so I don't write over things on accident
if [ ! -d /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX} ]; then
	echo "${PREFIX} directory does not exist, making new."
	mkdir -p /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX}
else
	echo "${PREFIX} directory exists. Either delete this directory or choose a different directory name"
	echo "Killing job"
	exit 1
fi

# run hifiasm
cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/hifi_assemblies/${PREFIX}

~/bin/hifiasm/hifiasm --primary -s 0.3 -o Atonsa.${PREFIX}.asm -t 25 /gxfs_work/geomar/smomw504/acartia_tonsa_genome_PacBio_v2/*fastq.gz

# change to fasta

#awk '/^S/{print ">"$2;print $3}'



