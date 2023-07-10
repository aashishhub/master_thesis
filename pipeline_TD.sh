#!/bin/bash
#author: Aashish Gyawali
#purpose: Script for tajima D calculation 
#SBATCH --time=300
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --error=error_pipeline.txt
#SBATCH --job-name=Thesis_Aashish
#SBATCH --mem=10000
#SBATCH --mail-user=aashish.gyawali@wur.nl

module load vcftools

vcftools --gzvcf asianwild_Chr6.vcf.gz --TajimaD 10000 --out asianwild_TD

echo "asianwild done"

and so on for other samples...