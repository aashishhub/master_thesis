## Script to parse variants in a VCF file 
## Install vcf,intermine, and subprocess package using: 
## 1. pip install PyVCF --user
## 2. pip install intermine --user
## 3. pip install subprocess --user

import sys
import vcf
from intermine.webservice import Service
from subprocess import Popen, PIPE
import subprocess
import pysam

def sample_dic():
    """ Read sample breed information """	
    sample_dic={}
    species_list = open("/lustre/nobackup/WUR/ABGC/gyawa001/final_species_list.tsv","r") 
    header = species_list.readline()
    for sample in species_list:
        sample = sample.strip().split("\t")
        samplename, origin, race_species, line_country, pigid = sample[0],sample[1],sample[2],sample[3],sample[4]
        sample_dic[samplename] = [origin.strip(), race_species.strip(), line_country.strip()]
    return sample_dic
    
def get_vcf_information(sample_dic):
    """ Read VCF file and parse output """
    vcf_reader = vcf.Reader(filename=sys.argv[1], strict_whitespace=True)
    print("Chr\tPos\tRef\tAlt\tRef_Homozygotes\tHeterozygotes\tAlt_Homozygotes\tMissing\tRef_Hom_samples\tHet_samples\tAlt_Hom_samples\tMissing_samples\tBreed\tCSQ\tIMPACT\tAF\tBreed_AF")
    gene_go_dic={}
    mgi_dic={}
    
    for record in vcf_reader:
        if int(record.INFO['AC'][0]) < 1:
            continue
        breed_dic={}
        freq_dic={}
        breed_count={}
        hom_ref_samples,het_samples,hom_samples,mis_samples=[],[],[],[]
        for sample in record.get_hom_refs():
            hom_ref_samples.append(sample.sample)
            breed = "-".join(sample_dic[sample.sample][1:])
            if breed in breed_count:
                breed_count[breed] +=2
            else:
                breed_count[breed] = 2
                
        for sample in record.get_hets():
            het_samples.append(sample.sample)
            breed = "-".join(sample_dic[sample.sample][1:]) ## Normal
            #breed = sample_dic[sample.sample][2] ## origin
            if breed in breed_dic:
                breed_dic[breed] +=1
                freq_dic[breed] +=1
            else:
                breed_dic[breed] = 1
                freq_dic[breed] =1
            if breed in breed_count:
                breed_count[breed] +=2
            else:
                breed_count[breed] = 2
                
        for sample in record.get_hom_alts():
            hom_samples.append(sample.sample)
            breed = "-".join(sample_dic[sample.sample][1:]) ## Normal
            #breed = sample_dic[sample.sample][2] ## origin
            if breed in breed_dic:
                breed_dic[breed] +=1
                freq_dic[breed] +=2
            else:
                breed_dic[breed] = 1
                freq_dic[breed] = 2
            if breed in breed_count:
                breed_count[breed] +=2
            else:
                breed_count[breed] = 2
                
        for sample in record.get_unknowns():
            mis_samples.append(sample.sample)
        if het_samples == []:
            het_samples = ["-"]
        if hom_samples == []:
            hom_samples = ["-"]
        if mis_samples == []:
            mis_samples = ["-"]
        csq=record.INFO['CSQ'][0].split("|")
        csq_impact=csq[2]
        sym,geneid=csq[3],csq[4]
        
        ## get GO annotation
        #go, gene_go_dic = gene_ontology(geneid,gene_go_dic)
        #go_output = geneid+":"+go
        
        ## Get phenotypes
        #phenotypes, mgi_dic = get_homologous_phenotypes(geneid, mgi_dic)
        #phenotypes=phenotypes.split("\t")
        #if phenotypes=="":
        #    phenotypes=["-","-","-"]	        
            
        ## get frequencies per breed
        freq_list=[]
        #pCADD_score = pCADD(record.CHROM,record.POS,record.ALT[0])	
        for breed in freq_dic:
            freq_list.append(breed+":"+str(round(float(freq_dic[breed])/breed_count[breed],2)))
        breed = ", ".join(["=".join([key, str(val)]) for key, val in breed_dic.items()])	
        outlist= [record.CHROM,record.POS,record.REF,record.ALT,record.num_hom_ref,record.num_het, record.num_hom_alt, record.num_unknown, ",".join(hom_ref_samples), ",".join(het_samples), ",".join(hom_samples), ",".join(mis_samples), breed, "".join(record.INFO['CSQ']), csq_impact, record.INFO['AF'][0], ",".join(freq_list)]
        print("\t".join(map(str,outlist)))
    
sample_dic=sample_dic()
get_vcf_information(sample_dic)