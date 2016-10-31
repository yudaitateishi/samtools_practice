#!/bin/bash
#$ -S /bin/bash

read=`grep "@$1" $2 | wc -l`
sp=`expr \(\($read\/$4\)+1\)\*4`
mkdir split
cd split

split -d -a 4 -l $(($sp)) ../$2 $5.
split -d -a 4 -l $(($sp)) ../$3 $6.

cd ..
