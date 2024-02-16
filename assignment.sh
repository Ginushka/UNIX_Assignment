#!/bin/bash

#Copy/paste this job script into a text file and submit with the command:
#the sbatch thefilename

#SBATCH --time=4:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 16 processor core(s) per node
#SBATCH --mem=2G   # maximum memory per node
#SBATCH --job-name="Unixassignment"
#SBATCH --mail-user=ginushik@iastate.edu   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="Unixassignment" # job standard output file (%j replaced by job id)
#SBATCH --error="Unixassignment" # job standard error file (%j replaced by job id)


# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE


#Check the groups in column three of fang_et_al_genotypes.txt and identify the groups of maize and teosinte
grep -v "^#" fang_et_al_genotypes.txt | cut -f3 | sort | uniq -c | sort -n

#Removed the headers of the fang_et_al_genotypes.txt
head -n 1 fang_et_al_genotypes.txt > headfang.txt

#Extracted the maize data from the ZMMIL, ZMMMR, ZMMLR groups and teosinte data from ZMPBA, ZMPIL, ZMPJA groups 
grep -E "(ZMMIL|ZMMMR|ZMMLR)" fang_et_al_genotypes.txt > maized.txt
grep -E "(ZMPBA|ZMPIL|ZMPJA)" fang_et_al_genotypes.txt > teosinted.txt

#Combined the headers to maize and teosinte data file
cat headfang.txt maized.txt > hmaized.txt
cat headfang.txt teosinted.txt > hteosinted.txt

#Check the files
awk -F "\t" '{print NF; exit}' hmaized.txt
wc hmaized.txt

awk -F "\t" '{print NF; exit}' hteosinted.txt
wc hteosinted.txt

#Modified the columns of maize and teosinte data file
cut -f 4-986 hmaized.txt > rhmaized.txt
cut -f 4-986 hteosinted.txt > rhteosinted.txt

#Transposed the column modified maize and teosinte data with headers
awk -f transpose.awk rhmaized.txt > tramaized.txt 
awk -f transpose.awk rhteosinted.txt > trateosinted.txt 

#Modified columns of snp_position.txt
cut -f 1,3,4-15 snp_position.txt > mcsnp.txt
head -n 1 mcsnp.txt > hsnp.txt

#Sorted the transposed maize and teosinte transposed and modified snp position files
sort -k1,1 tramaized.txt > rdytojnmaized.txt
sort -k1,1 trateosinted.txt > rdytojnteosinted.txt
sort -k1,1 mcsnp.txt > rdytojnsnpp.txt
echo $?

#Join the files
join -1 1 -2 1 -a 1 rdytojnsnpp.txt rdytojnmaized.txt > jndmaize.txt
join -1 1 -2 1 -a 1 rdytojnsnpp.txt rdytojnteosinted.txt > jndteosinte.txt

#Add header to joined files
cat hsnp.txt jndmaize.txt > hjndmaize.txt
cat hsnp.txt jndteosinte.txt > hjndteosinte.txt

#Make the directories
mkdir Maizedec Teosintedec Maizeinc Teosinteinc

#Extract data based on chromosome number and sort them based on increasing position  
for i in {1..10}; do awk '$2=='$i'' hjndmaize.txt | sort -k3,3n > Maizeinc/incmaizechr"$i".txt; done
for i in {1..10}; do awk '$2=='$i'' hjndteosinte.txt | sort -k3,3n > Teosinteinc/incrteosintechr"$i".txt; done

#Extract data based on chromosome number and sort them based on decreasing position while replacing missing values (?) with (-)
for i in {1..10}; do awk '$2=='$i'' hjndmaize.txt | sed 's/?/-/g' | sort -k3,3n -r > Maizedec/decmaizechr"$i".txt; done
for i in {1..10}; do awk '$2=='$i'' hjndteosinte.txt | sed 's/?/-/g' | sort -k3,3n -r > Teosintedec/decteosintechr"$i".txt; done

#Extract unknown data from joined files of maize and teosinte
grep "unknown" hjndmaize.txt > maizeunknown.txt
grep "unknown" hjndteosinte.txt > teosinteunknown.txt

#Extract multiple data from joined files of maize and teosinte
grep "multiple" hjndmaize.txt > maizemultiple.txt
grep "multiple" hjndteosinte.txt > teosintemultiple.txt


