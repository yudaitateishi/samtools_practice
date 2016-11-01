#!/bin/bash
#$ -S /bin/bash

cd ./mpile_split
SGE=`expr ${SGE_TASK_ID} - 1`
taskid=`printf %04d ${SGE}`
python ../mutationcall_scripts/call_snp.py ${1}.${taskid} ${1}.output.${taskid} ${2}
cd ..
