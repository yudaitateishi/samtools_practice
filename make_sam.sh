#!/bin/bash
#$ -S /bin/bash


SGE=`expr $SGE_TASK_ID - 1`
if [ $3 -lt 101 ]
then
	if [ $SGE -lt 10 ]
	then
		taskid=0$SGE
	else
		taskid=$SGE
	fi
elif [ $3 -lt 1001 ]
then
	if [ $SGE -lt 10 ]
	then
		taskid=00$SGE
	elif [ $SGE -lt 100 ]
	then
		taskid=0$SGE
	else
		taskid=$SGE
	fi
else
	if [ $SGE -lt 10 ]
	then
		taskid=000$SGE
	elif [ $SGE -lt 100 ]
	then
		taskid=00$SGE
	elif [ $SGE -lt 1000 ]
	then
		taskid=0$SGE
	else
		taskid=$SGE
	fi
fi

bwa aln $1 $2_1.fastq.$taskid > $2_1.$taskid.sai
bwa aln $1 $2_2.fastq.$taskid > $2_2.$taskid.sai

bwa sampe $1 $2_1.$taskid.sai $2_2.$taskid.sai $2_1.fastq.$taskid $2_2.fastq.$taskid > $2.$taskid.sam

samtools view -bS $2.$taskid.sam > $2.$taskid.bam
samtools sort $2.$taskid.bam $2.$taskid

