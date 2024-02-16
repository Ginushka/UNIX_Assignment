#UNIX Assignment

##Data Inspection

###Attributes of `fang_et_al_genotypes`

```
less fang_et_al_genotypes.txt
awk -F "\t" '{print NF; exit}' fang_et_al_genotypes.txt
wc fang_et_al_genotypes.txt
du -h fang_et_al_genotypes.txt
```

By inspecting this file I learned that:

1. the file has 986 fields 
2. the data file contains 2783 lines, 2744038 words and 11051939 characters
3. file size is 6.7M


###Attributes of `snp_position.txt`

```
less snp_position.txt
awk -F "\t" '{print NF; exit}' snp_position.txt
wc snp_position.txt
du -h snp_position.txt
```

By inspecting this file I learned that:

1. the data file has 15 fields 
2. the data file contains 984 lines, 13198 words and 82763 characters
3. file size is 49k


##Data Processing

###Maize Data and Teosinte data

```
grep -v "^#" fang_et_al_genotypes.txt | cut -f3 | sort | uniq -c | sort -n
```
First I checked the groups in column three of fang_et_al_genotypes.txt and identified the groups of maize and teosinte.
```
head -n 1 fang_et_al_genotypes.txt > headfang.txt
```
Then I removed the headers of the fang_et_al_genotypes.txt and I saved the file with headers separately.
```
grep -E "(ZMMIL|ZMMMR|ZMMLR)" fang_et_al_genotypes.txt > maized.txt
grep -E "(ZMPBA|ZMPIL|ZMPJA)" fang_et_al_genotypes.txt > teosinted.txt
```
I extracted the maize data from the ZMMIL, ZMMMR, ZMMLR groups and teosinte data from ZMPBA, ZMPIL, ZMPJA groups as instructed. 
```
cat headfang.txt maized.txt > hmaized.txt
cat headfang.txt teosinted.txt > hteosinted.txt
```
I combined the file with header information to maize and teosinte data files. 
```
awk -F "\t" '{print NF; exit}' hmaized.txt
wc hmaized.txt

awk -F "\t" '{print NF; exit}' hteosinted.txt
wc hteosinted.txt
```
Then I checked the files for modifications using No of fields, lines,words and characters.   
```
cut -f 4-986 hmaized.txt > rhmaized.txt
cut -f 4-986 hteosinted.txt > rhteosinted.txt
```
Then I modified the columns of maize and teosinte data file, so that SNP id will come as the first column when files are transposed.
```
awk -f transpose.awk rhmaized.txt > tramaized.txt 
awk -f transpose.awk rhteosinted.txt > trateosinted.txt 
```
Next I transposed the column modified maize and teosinte data using the given code in transpose.awk.
```
cut -f 1,3,4-15 snp_position.txt > mcsnp.txt
head -n 1 mcsnp.txt > hsnp.txt
```
I prepared the snp_position.txt file by modifying columns as instructed and the headers.
```
sort -k1,1 tramaized.txt > rdytojnmaized.txt
sort -k1,1 trateosinted.txt > rdytojnteosinted.txt
sort -k1,1 mcsnp.txt > rdytojnsnpp.txt
echo $?
```
I sorted the transposed maize and teosinte files and modified snp file. I tested for errors in sorting using echo command.
```
join -1 1 -2 1 -a 1 rdytojnsnpp.txt rdytojnmaized.txt > jndmaize.txt
join -1 1 -2 1 -a 1 rdytojnsnpp.txt rdytojnteosinted.txt > jndteosinte.txt
```
Then I joined the files using first column of transposed maize, teosinte files and first column of modified snp file as the common column.

```
cat hsnp.txt jndmaize.txt > hjndmaize.txt
cat hsnp.txt jndteosinte.txt > hjndteosinte.txt
```
Next, I added the header of snp file to the joined files
```
mkdir Maizedec Teosintedec Maizeinc Teosinteinc
```
I made some directories to direct files from next commands.
```
for i in {1..10}; do awk '$2=='$i'' hjndmaize.txt | sort -k3,3n > Maizeinc/incmaizechr"$i".txt; done
for i in {1..10}; do awk '$2=='$i'' hjndteosinte.txt | sort -k3,3n > Teosinteinc/incrteosintechr"$i".txt; done
```
Then I extracted the data from joined file based on chromosome number from 1 to 10 and sorted them based on increasing position.  
```
for i in {1..10}; do awk '$2=='$i'' hjndmaize.txt | sed 's/?/-/g' | sort -k3,3n -r > Maizedec/decmaizechr"$i".txt; done
for i in {1..10}; do awk '$2=='$i'' hjndteosinte.txt | sed 's/?/-/g' | sort -k3,3n -r > Teosintedec/decteosintechr"$i".txt; done
```
I extracted the data from joined file based on chromosome number from 1 to 10 and sorted them based on decreasing position while replacing missing values (?) with (-).
```
grep "unknown" hjndmaize.txt > maizeunknown.txt
grep "unknown" hjndteosinte.txt > teosinteunknown.txt
```
I extracted unknown data from joined files of maize and teosinte.
```
grep "multiple" hjndmaize.txt > maizemultiple.txt
grep "multiple" hjndteosinte.txt > teosintemultiple.txt
```
Finally I extracted multiple data from joined files of maize and teosinte.
