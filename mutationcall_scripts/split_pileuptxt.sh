#!/bin/bash
#$ -S /bin/bash


read=`cat ${1} | wc -l`
sp=`expr ${read}\/${2}`
 
cd call_mut

name=${1##*/}
split -d -a 4 -l $(($sp)) ../${1} ${name}.

cd ..
