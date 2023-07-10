#this is a script for calculating stats of the vcf file. Bcftools was used to calculate the stats of the vcf file.

#load bcfools
module load bcftools

#calculate stats for each of the vcf file
bcftools stats westerncom_FUT2.vcf.gz > westerncom_FUT2.stats.txt
bcftools stats europeanwild_FUT2.vcf.gz > europeanwild_FUT2.stats.txt
bcftools stats europeanlocal_FUT2.vcf.gz > europeanlocal_FUT2.stats.txt
bcftools stats asianwild_FUT2.vcf.gz > asianwild_FUT2.stats.txt
bcftools stats asiandom_FUT2.vcf.gz > asiandom_FUT2.stats.txt

echo "done"
