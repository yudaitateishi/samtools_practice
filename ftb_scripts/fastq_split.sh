#!/bin/bash
#$ -S /bin/bash

read=`grep "@$1" $2 | wc -l`
sp=`expr \(\($read\/$4\)+1\)\*4`
mkdir f_split
cd f_split

split -d -a 4 -l $(($sp)) ../$2 $1_1.fastq.
split -d -a 4 -l $(($sp)) ../$3 $1_2.fastq.

cd ..
