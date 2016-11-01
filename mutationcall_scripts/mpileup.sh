#!/bin/bash
#$ -S /bin/bash

mkdir call_mut
samtools mpileup -f $1 $2 $3 > ./call_mut/mpileup.txt
