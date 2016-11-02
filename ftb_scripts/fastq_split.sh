#!/bin/bash
#$ -S /bin/bash

line=`grep "" -c $1`
read=`expr ${line}/4`
sp=`expr \(\($((${read}))\/$4\)+1\)\*4`
mkdir f_split
cd f_split

split -d -a 4 -l $((${sp})) ../$1 $3_1.fastq.
split -d -a 4 -l $((${sp})) ../$2 $3_2.fastq.

cd ..
