#!/bin/bash
#$ -S /bin/bash


SGE=`expr $SGE_TASK_ID - 1`
taskid=`printf %04d ${SGE}`

bwa aln $1 $2_1.fastq.$taskid > $2_1.$taskid.sai
bwa aln $1 $2_2.fastq.$taskid > $2_2.$taskid.sai

bwa sampe $1 $2_1.$taskid.sai $2_2.$taskid.sai $2_1.fastq.$taskid $2_2.fastq.$taskid > $2.$taskid.sam

samtools view -bS $2.$taskid.sam > $2.$taskid.bam
samtools sort $2.$taskid.bam $2.$taskid

