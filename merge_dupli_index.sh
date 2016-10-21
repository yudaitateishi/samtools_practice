#!/bin/sh
#$ -S /bin/sh

samtools merge $1.bam $2
samtools rmdup $1.bam $1.dupli.bam
samtools index $1.dupli.bam
