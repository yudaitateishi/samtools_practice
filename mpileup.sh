#!/bin/bash
#$ -S /bin/bash

samtools mpileup -f $1 $2 $3 > $4
