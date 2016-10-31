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
	chrom = nuc_position[0].strip("chr")
	position = nuc_position[1]
	reference = nuc_position[2]
	nor_cover_depth = nuc_position[3]
	nor_aln = nuc_position[4]
	nor_qual = nuc_position[5]
	tum_cover_depth = nuc_position[6]
	tum_aln = nuc_position[7]
	tum_qual = nuc_position[8]

	if int(tum_cover_depth) < int(depth_filter): #Filter by cover depth
		continue
	elif int(depth_filter) <= int(tum_cover_depth):
		pass
	else:
		sys.stderr.write("This script has problem in depth filter")
		quit()
	if int(nor_cover_depth) < int(depth_filter): #Filter by cover depth
		continue
	elif int(depth_filter) <= int(nor_cover_depth):
		pass
	else:
		sys.stderr.write("This script has problem in depth filter")
		quit()

	
	if round((tum_aln.count(".") + tum_aln.count(",")) / float(tum_cover_depth),2) < 0.9:
		pass
	elif 0.9 <= round((tum_aln.count(".") + tum_aln.count(",")) / float(tum_cover_depth),2):
		continue #If This line has meny matched read,skip process 
	else:
		sys.stderr.write("This script has problem in match average filter")
		quit()

	start_end = re.compile("(\^[\x20-\x7E])|\$") #strip read start/end marking
	nor_markstrip_aln = start_end.sub("",nor_aln)
	tum_markstrip_aln = start_end.sub("",tum_aln)
	
	nor_indel_split = re.split("\+|-",nor_markstrip_aln) #strip InDel
	nor_indel_out = []
	for i in nor_indel_split:
		if i[0].isdigit() == True:
			nor_indel_out.append(i[int(i[0]) + 1 :])
		else:
			nor_indel_out.append(i)
	tum_indel_split = re.split("\+|-",tum_markstrip_aln) #strip InDel
	tum_indel_out = []
	for i in tum_indel_split:
		if i[0].isdigit() == True:
			tum_indel_out.append(i[int(i[0]) + 1 :])
		else:
			tum_indel_out.append(i)


	nor_aln_text = "".join(nor_indel_out)
	nor_snpdict = {}
	nor_snpdict["A"] = nor_aln_text.count("a") + nor_aln_text.count("A")
	nor_snpdict["T"] = nor_aln_text.count("t") + nor_aln_text.count("T")
	nor_snpdict["C"] = nor_aln_text.count("c") + nor_aln_text.count("C")
	nor_snpdict["G"] = nor_aln_text.count("g") + nor_aln_text.count("G")
	nor_snpdict["N"] = nor_aln_text.count("n") + nor_aln_text.count("N")
	nor_alignment_score = max(nor_snpdict[x] for x in nor_snpdict)
	nor_mismatch_avg = round(nor_alignment_score / float(nor_cover_depth),3)

	tum_aln_text = "".join(tum_indel_out)
	tum_snpdict = {}
	tum_snpdict["A"] = tum_aln_text.count("a") + tum_aln_text.count("A")
	tum_snpdict["T"] = tum_aln_text.count("t") + tum_aln_text.count("T")
	tum_snpdict["C"] = tum_aln_text.count("c") + tum_aln_text.count("C")
	tum_snpdict["G"] = tum_aln_text.count("g") + tum_aln_text.count("G")
	tum_snpdict["N"] = tum_aln_text.count("n") + tum_aln_text.count("N")
	tum_alignment_score = max(tum_snpdict[x] for x in tum_snpdict)
	tum_mismatch_avg = round(tum_alignment_score / float(tum_cover_depth),3)


	snp = []
	mismatch_count = []
	if 0.25 < tum_mismatch_avg:
		if nor_mismatch_avg < 0.1:
			for k,v in tum_snpdict.items():
				if 4 <= int(v) and 0.25 < round(v / float(tum_cover_depth),3):
					snp.append(k)
					mismatch_count.append(str(v))  
				else:
					pass
			if len(snp) == 0:
				continue
			else:
				pass
		elif 0.1 <= nor_mismatch_avg:
			continue
		else:
			sys.stderr.write("ERROE")
			quit()	 
	else:
		continue

	snp_list.append("\t".join([chrom,str(position),str(position),reference,",".join(snp),str(tum_cover_depth),",".join(mismatch_count)]))
	
with open(sys.argv[2],"w") as result_file:
	if len(snp_list) == 0:
		pass
	else:
		result_file.write("\n".join(snp_list) + "\n")

