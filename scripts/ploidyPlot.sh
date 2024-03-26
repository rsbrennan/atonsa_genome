#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --output=%x.%A.%a.out
#SBATCH --error=%x.%A.%a.err
#SBATCH --partition=highmem
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem 360G
#SBATCH --time=6:00:00
#SBATCH --job-name=ploidyPlot

source ~/miniforge3/etc/profile.d/conda.sh
conda activate assembly

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish

# Run PloidyPlot to find all k-mer pairs in the dataset
~/bin/smudgeplot/exec/PloidyPlot -e12 -k -v -T4 -odata/gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish/kmerpairs /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish/FastK_Table
