This repository has some scripts for alignment fastq file and call mutation.

You can convert fastq to bam for fastq_to_bam.sh.
fastq_to_bam.sh is driver scripts for HGC Shirokane3.
This script run some scripts in ftb_scripts directory.
You can run ./fastq_to_bam <ref.fa> <input1.fastq> <input2.fastq> <job volume>

You can [samtools mpileup] for mpileup.sh.
./mpileup.sh <ref.fa> <normal.bam> <tumor.bam> <output>

snpcall.sh and mutationcall.sh are driver scripts.
You can make VCF format file.
<./snpcall.sh or mutationcall.sh> <input> <output> <depth filter size> <job volume>
