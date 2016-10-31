#!/bin/bash
#$ -S /bin/bash


read=`cat ${1} | wc -l`
sp=`expr ${read}\/${2}`
mkdir split
cd split

split -d -a 4 -l $(($sp)) ../${1} ${1}.

cd ..
