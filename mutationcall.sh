#!/bin/bash
#$ -S /bin/bash

ref=$1
normal=$2
tumor=$3
output=$4
filter=$5
taskvol=$6

qsub -N mpileup -cwd -o ${4}.log -e ${4}.err ./mutationcall_scripts/mpileup.sh ${ref} ${normal} ${tumor} 
qsub -N split -hold_jid mpileup -cwd -o ${1}.log -e ${1}.err ./mutationcall_scripts/split_pileuptxt.sh ./call_mut/mpileup.txt ${taskvol}
qsub -N call -hold_jid split -cwd -o ${1}.log -e ${1}.err -t 1-${taskvol}:1 ./mutationcall_scripts/run_python.sh mpileup.txt ${filter}
qsub -N cat -hold_jid call -cwd -o ${1}.log -e ${1}.err ./mutationcall_scripts/cat_pileup.sh ${output}
qsub -N annotate -hold_jid cat -cwd -o ${1}.log -e ${1}.err ./mutationcall_scripts/annotate.sh ${output}
