#!/bin/sh
#$ -S /bin/sh

if [ $# -lt 4 ]
then
    echo "Usage:./fastq_to_bam.sh reference _1.fastq _2.fastq split"
    exit 1
fi

filename1=${2##*/}
filename2=${3##*/}
sequence_name=${filename1%_*}

read=`grep "@$sequence_name" $2 | wc -l`
sp=`expr \(\($read\/$4\)+1\)\*4`
mkdir split
cd split
split -d -l $(($sp)) ../$2 $filename1.
echo "$2 split"
split -d -l $(($sp)) ../$3 $filename2.
echo "$3 split"
cd ..

qsub -o ./qlogs -e ./qerrors -cwd  -t 1-$4:1 ./make_sam.sh $1 ./split/$sequence_name

while :
do
	sleep 1m
	if [ $((`qstat | wc -l`-4)) -lt 1 ]
	then
		break
	fi 
done

samtools merge $sequence_name.bam ./split/$seqence_name.*.bam
samtools sort -o $sequence_name.sorted.bam $sequence_name.bam
samtools index $sequence_name.sorted.bam

