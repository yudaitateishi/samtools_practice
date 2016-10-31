#!/bin/bash
#$ -S /bin/bash

input=$1
output=$2
filter=$3
taskvol=$4

qsub -N split -cwd -o ${1}.log -e ${1}.err ./mutationcall_scripts/split_pileuptxt.sh ${input} ${taskvol}
qsub -N call -hold_jid split -cwd -o ${1}.log -e ${1}.err -t 1-${taskvol}:1 ./mutationcall_scripts/run_python.sh ${input} ${filter}
qsub -N cat -hold_jid call -cwd -o ${1}.log -e ${1}.err ./mutationcall_scripts/cat_pileup.sh ${output}
