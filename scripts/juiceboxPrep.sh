#!/bin/bash
#SBATCH --job-name=juiceBox_prep 
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10000
#SBATCH --output=/gxfs_home/geomar/smomw504/tonsa_genome/juiceBox_prep.out
#SBATCH --error=/gxfs_home/geomar/smomw504/tonsa_genome/juiceBox_prep.err
#SBATCH --partition=base

# activate a specific conda environment, if you so choose
mamba activate manual_correction

# go to a particular directory
cd /gxfs_work/geomar/smomw504/genome_manual_edits

# make things fail on errors
set -o nounset
set -o errexit
set -x

### run your commands here!

snakemake -s GAP_hic_map7.txt --cluster
