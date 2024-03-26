#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=highmem
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 240G
#SBATCH --time=2:00:00
#SBATCH --output=/gxfs_home/geomar/smomw504/tonsa_genome/log_out/%x.%A.%a.out
#SBATCH --error=/gxfs_home/geomar/smomw504/tonsa_genome/log_out/%x.%A.%a.err
#SBATCH --job-name=smudge

source ~/miniforge3/etc/profile.d/conda.sh
conda activate assembly

cd /gxfs_work/geomar/smomw504/acartia_tonsa_genome_hifi_newassembly/jellyfish

L=$(smudgeplot.py cutoff reads.histo L)
U=$(smudgeplot.py cutoff reads.histo U)
echo $L $U
# L should be like 20 - 200
# U should be like 500 - 3000
#jellyfish dump -c -L $L -U $U reads.jf > jfish_L"$L"_U"$U".dump
echo "jellyfish dump is done"

#smudgeplot.py hetkmers -o kmer_pairs < jfish_L"$L"_U"$U".dump
smudgeplot.py hetkmers -o kmer_pairs < jfish_L12_U2100.dump
echo "smudgeplot is done"

# note that if you would like use --middle flag, you would have to sort the jellyfish dump first
