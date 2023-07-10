#!/bin/bash
#author: Aashish Gyawali
#purpose: Script for calculating nucleotide diversity
#SBATCH --time=300
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --error=error_pipeline.txt
#SBATCH --job-name=Thesis_Aashish
#SBATCH --mem=10000
#SBATCH --mail-user=aashish.gyawali@wur.nl

module load vcftools

vcftools --gzvcf allsamples_Chr6.vcf.gz --window-pi 10000 --out allsamples_ND

echo "done"

and so on for other samples ...