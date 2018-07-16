# genomics_related_scripts
# I have uploaded some codes used for processing comparative genomic analysis
### 1. put the sample files Orthogroups.GeneCount.csv Orthogroups.txt in the same folder together with the perl scripts 1get_group_conserve.pl
### command: perl 1get_group_conserve.pl	

### 2. reads filter
### copy the command in the file "perl scripts for reads filtering" and type it in the command line.
#### filter criteria
####  1) average quality score >20
#### 	2) no N in the first 20 bp
#### 	3) >50% of the nucleotides with quality <5 
####  4) >20% of the nucleotides with quality <13	
#### 	5) >10% of the nucleotides with quality <10

