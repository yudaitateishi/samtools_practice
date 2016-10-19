#!/bin/sh
#$ -S /bin/sh


SGE=`expr $SGE_TASK_ID - 1`
if [ $SGE -lt 10 ]
then
	taskid=0$SGE
else
	taskid=$SGE
fi

bwa aln $1 $2_1.fastq.$taskid > $2_1.$taskid.sai
bwa aln $1 $2_2.fastq.$taskid > $2_2.$taskid.sai

bwa sampe $1 $2_1.$taskid.sai $2_2.$taskid.sai $2_1.fastq.$taskid $2_2.fastq.$taskid > $2.$taskid.sam

samtools view -bS $2.$taskid.sam > $2.$taskid.bam

echo "make $2.$taskid.bam."

