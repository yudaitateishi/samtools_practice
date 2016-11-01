#!/bin/bash
#$ -S /bin/bash

~/annovar/table_annovar.pl ${1} ~/annovar/humandb/ -buildver hg19 -out ${1}.anotated -protocol refGene,snp138,cosmic68 -operation g,f,f
