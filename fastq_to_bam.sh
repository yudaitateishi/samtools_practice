#!/bin/bash
#$ -S /bin/bash

if [ $# -lt 4 ]
then
    echo "Usage:./fastq_to_bam.sh reference _1.fastq _2.fastq split"
    exit 1
fi

if [ 10001 -lt $4 ]
then
    echo "Usage:split size is too large,please input 1 ~ 10000"
fi
filename1=${2##*/}
filename2=${3##*/}
sequence_name=${filename1%_*}

qsub -cwd -N fastq_split ./ftb_scripts/fastq_split.sh $sequence_name $2 $3 $4 $filename1 $filename2

qsub -o ./qlogs -e ./qerrors -cwd  -t 1-$4:1 -N make_sam -hold_jid fastq_split ./ftb_scripts/make_sam.sh $1 ./split/$sequence_name $4


bamfiles="./split/*.bam"
qsub -cwd -N merge_dupli -hold_jid make_sam ./ftb_scripts/merge_dupli_index.sh $sequence_name $bamfiles

qsub -cwd -hold_jid merge_dupli ./ftb_scripts/del_split.sh
