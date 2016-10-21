#!/bin/sh
#$ -S /bin/sh


read=`grep "@$1" $2 | wc -l`
sp=`expr \(\($read\/$4\)+1\)\*4`
mkdir split
cd split

if [ $4 < 101 ]
then
	split -d -l $(($sp)) ../$2 $5.
	split -d -l $(($sp)) ../$3 $6.
elif [ $4 < 1001 ]
then
	split -d -a 3 -l $(($sp)) ../$2 $5.
	split -d -a 3 -l $(($sp)) ../$3 $6.
else
then
	split -d -a 4 -l $(($sp)) ../$2 $5.
	split -d -a 4 -l $(($sp)) ../$3 $6.
fi

cd ..
