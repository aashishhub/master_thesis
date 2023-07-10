#!/bin/bash
#author: Aashish Gyawali
#purpose: Script pipeline for susetting, vep and calculating allele frequencies
#SBATCH --time=200
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --error=error_pipeline.txt
#SBATCH --job-name=Thesis_Aashish
#SBATCH --mem=10000
#SBATCH --mail-user=aashish.gyawali@wur.nl

echo "Let's start extracting vcf"

export BCFTOOLS_PLUGINS=/home/WUR/gyawa001/miniconda3/libexec/bcftools/

#lets make vcf and index file for each of our group
#lets extcract vcf for FUT genes under study

bcftools view -S all_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > allsamples_Chr6.vcf.gz
bcftools index allsamples_Chr6.vcf.gz
bcftools view -O v -e 'AC=0' -r  6:54034166-54047724 allsamples_Chr6.vcf.gz > allsamples_FUT2.vcf.gz

#bcftools view -S asianwild_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > asianwild_Chr6.vcf.gz
#bcftools index asianwild_Chr6.vcf.gz
#bcftools view -O v -e 'AC=0' -r 6:54034166-54047724 asianwild_Chr6.vcf.gz > asianwild_FUT2.vcf.gz

echo "Asian Wild done"

#bcftools view -S asiandom_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > asiandom_Chr6.vcf.gz
#bcftools index asiandom_Chr6.vcf.gz
#bcftools view -O v -e 'AC=0' -r 6:54034166-54047724 asiandom_Chr6.vcf.gz > asiandom_FUT2.vcf.gz

echo "Asian Domestic done"

#bcftools view -O z -S europeanwild_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > europeanwild_Chr6.vcf.gz
#bcftools index europeanwild_Chr6.vcf.gz
#bcftools view -O v -e 'AC=0' -r 6:54034166-54047724 europeanwild_Chr6.vcf.gz > europeanwild_FUT2.vcf.gz

echo " European Wild done"

#bcftools view -O z -S europeanlocal_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > europeanlocal_Chr6.vcf.gz
#bcftools index europeanlocal_Chr6.vcf.gz
#bcftools view -O v -e 'AC=0' -r 6:54034166-54047724 europeanlocal_Chr6.vcf.gz > europeanlocal_FUT2.vcf.gz

echo "European local done"

#bcftools view -O z -S westerncom_samples.txt Sscrofa11.1_Chr6.vcf.gz | bcftools +fill-tags | bgzip -c > westerncom_Chr6.vcf.gz
#bcftools index westerncom_Chr6.vcf.gz
#bcftools view -O v -e 'AC=0' -r 6:54034166-54047724 westerncom_Chr6.vcf.gz > westerncom_FUT2.vcf.gz



echo "vcf file generated for your samples and your genes. Enjoy"


echo "Let's start vep"

#activating and loading vep
source activate vep
module load vep

#running vep for each of the vcf file
#this will generate vep file and html summary file for each genes and population

#vep -i asianwild_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o asianwild_FUT2.vep.vcf

#vep -i asiandom_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o asiandom_FUT2.vep.vcf

#vep -i europeanwild_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o europeanwild_FUT2.vep.vcf

#vep -i europeanlocal_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o europeanlocal_FUT2.vep.vcf

#vep -i westerncom_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o westerncom_FUT2.vep.vcf

vep -i allsamples_FUT2.vcf.gz --offline --dir /lustre/nobackup/WUR/ABGC/gyawa001/cache --force_overwrite --species sus_scrofa --pick --vcf --sift b -o allsamples_FUT2.vep.vcf

echo "VEP done"

echo "parsing information from vep"

module load python/3.9

#python parse_genes_variants_WGS.py europeanwild_FUT2.vep.vcf > europeanwild_FUT2.txt
#python parse_genes_variants_WGS.py europeanlocal_FUT2.vep.vcf > europeanlocal_FUT2.txt
#python parse_genes_variants_WGS.py asianwild_FUT2.vep.vcf > asianwild_FUT2.txt
#python parse_genes_variants_WGS.py asiandom_FUT2.vep.vcf > asiandom_FUT2.txt
#python parse_genes_variants_WGS.py westerncom_FUT2.vep.vcf > westerncom_FUT2.txt
python parse_genes_variants_WGS.py allsamples_FUT2.vep.vcf > allsamples_FUT2.txt
