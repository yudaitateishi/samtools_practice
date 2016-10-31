#!/bin/bash
#$ -S /bin/bash


cd split
called_files=`ls |grep output `
cat ${called_files} > ../${1}


