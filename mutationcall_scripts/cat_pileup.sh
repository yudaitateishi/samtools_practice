#!/bin/bash
#$ -S /bin/bash


cd call_mut
called_files=`ls |grep output `
cat ${called_files} > ../${1}

cd ..
rm -rf call_mut
