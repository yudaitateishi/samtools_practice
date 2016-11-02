#!/bin/bash
#$ -S /bin/bash

ref=${1}
input1=${2}
input2=${3}
output=${4}
jobvol=${5}


if [ $# -lt 4 ]
then
    echo "Usage:./fastq_to_bam.sh reference _1.fastq _2.fastq split"
    exit 1
fi

if [ 10001 -lt ${jobvol} ]
then
    echo "Usage:split size is too large,please input 1 ~ 10000"
fi
#filename1=${2##*/}
#filename2=${3##*/}
#sequence_name=${filename1%_*}

qsub -cwd -N fastq_split -e ${4}.err -o ${4}.log ./ftb_scripts/fastq_split.sh ${input1} ${input2} ${output} ${jobvol}

qsub -cwd -N make_sam -hold_jid fastq_split -e ${4}.err -o ${4}.log -t 1-${jobvol}:1 ./ftb_scripts/make_sam.sh ${ref} ./f_split/${output} 


bamfiles="./f_split/*.bam"
qsub -cwd -N merge_dupli -hold_jid make_sam -e ${4}.err -o ${4}.log ./ftb_scripts/merge_dupli_index.sh ${output} $bamfiles 

qsub -cwd -N del_split -hold_jid merge_dupli -e ${4}.err -o${4}.log ./ftb_scripts/del_split.sh
