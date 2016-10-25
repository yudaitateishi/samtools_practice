#!/usr/bin/env python

import sys
import re
import string


with open(sys.argv[1],"r") as mpileup_file:
	mpileup_list = []
	for line in mpileup_file.readlines():
		mpileup_list.append(line.strip("\n").split("\t"))


depth_filter = int(sys.argv[3])
snp_list = []

for nuc_position in mpileup_list:
	chrom = nuc_position[0]
	position = nuc_position[1]
	reference = nuc_position[2]
	cover_depth = nuc_position[3]
	aln = nuc_position[4]
	qual = nuc_position[5]

	if int(cover_depth) < int(depth_filter):
		continue
	elif int(depth_filter) <= int(cover_depth):
		pass
	else:
		sys.stderr.write("This script has problem in depth filter")
		quit()
	
	if round((aln.count(".") + aln.count(",")) / float(cover_depth),2) < 0.9:
		pass
	elif 0.9 <= round((aln.count(".") + aln.count(",")) / float(cover_depth),2):
		continue
	else:
		sys.stderr.write("This script has problem in match average filter")
		quit()

	start_end = re.compile("(\^[\x20-\x7E])|\$")
	markstrip_aln = start_end.sub("",aln)
	
	indel_split = re.split("\+|-",markstrip_aln)
	indel_out = []
	for i in indel_split:
		if i[0].isdigit() == True:
			indel_out.append(i[int(i[0]) + 1 :])
		else:
			indel_out.append(i)

	aln_text = "".join(indel_out)
	snpdict = {}
	snpdict["A"] = aln_text.count("a") + aln_text.count("A")
	snpdict["T"] = aln_text.count("t") + aln_text.count("T")
	snpdict["C"] = aln_text.count("c") + aln_text.count("C")
	snpdict["G"] = aln_text.count("g") + aln_text.count("G")
	alignment_score = max(snpdict[x] for x in snpdict)
	mismatch_avg = round(alignment_score / float(cover_depth),3)
	snp = []
	mismatch_count = []
	if 0.25 < mismatch_avg:
		for k,v in snpdict.items():
			if 4 <= v and 0.1 < round(v / float(cover_depth),3):
				snp.append(k)
				mismatch_count.append(str(v))
			else:
				pass
		if len(snp) == 0:
			continue
		else:
			pass
	else:
		continue

	snp_list.append("\t".join([chrom,str(position),reference,",".join(snp),str(cover_depth),",".join(mismatch_count)]))
	
with open(sys.argv[2],"w") as result_file:
	result_file.write("\n".join(snp_list))

