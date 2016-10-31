#!/bin/bash
#$ -S /bin/bash


samtools merge $1.bam $2
samtools rmdup $1.bam $1.dupli.bam
samtools index $1.dupli.bam
rm $1.bam
