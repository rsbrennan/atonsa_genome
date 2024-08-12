#!/bin/bash
#SBATCH -D /gxfs_home/geomar/smomw504/tonsa_genome/log_out/
#SBATCH --mail-type=END
#SBATCH --mail-user=rbrennan@geomar.de
#SBATCH --partition=data
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 4G
#SBATCH --time=30:00:00
#SBATCH --output=%x.%A.out
#SBATCH --error=%x.%A.err
#SBATCH --job-name=omni_download

cd /gxfs_work/geomar/smomw504/OmniC_reads

wget 'https://dovebucket.s3.us-west-2.amazonaws.com/projects/UNI2350/data/OmniC/DTG-OmniC-468_R1_001.fastq.gz?AWSAccessKeyId=AKIARPAV7S2IIPRQWTZE&Signature=OWlmHVYywBt8UCXYIFgPCuTJCFg%3D&Expires=1714929954' -O DTG-OmniC-468_R1_001.fastq.gz
wget 'https://dovebucket.s3.us-west-2.amazonaws.com/projects/UNI2350/data/OmniC/DTG-OmniC-468_R1_001.fastq.gz.md5?AWSAccessKeyId=AKIARPAV7S2IIPRQWTZE&Signature=ZBdW2T8ZWOiDcyzBGLHMZPVINyA%3D&Expires=1714929955' -O DTG-OmniC-468_R1_001.fastq.gz.md5
wget 'https://dovebucket.s3.us-west-2.amazonaws.com/projects/UNI2350/data/OmniC/DTG-OmniC-468_R2_001.fastq.gz?AWSAccessKeyId=AKIARPAV7S2IIPRQWTZE&Signature=qQcOwLKcT10On1DggWFVWL87aPU%3D&Expires=1714929955' -O DTG-OmniC-468_R2_001.fastq.gz
wget 'https://dovebucket.s3.us-west-2.amazonaws.com/projects/UNI2350/data/OmniC/DTG-OmniC-468_R2_001.fastq.gz.md5?AWSAccessKeyId=AKIARPAV7S2IIPRQWTZE&Signature=c8deGo2JcsLc%2FevYxXXKAWbExEk%3D&Expires=1714929956' -O DTG-OmniC-468_R2_001.fastq.gz.md5

