#!/bin/bash
inputfile=$1

traits=`cat $inputfile | awk '$2!="Trait" {print $2}' | sort -u`
genes=`cat $inputfile | awk '$1!="Gene" {print $1}' | sort -u`
for i in $traits; 
do 
    for j in $genes;
    do 
	mkdir -p $i/$j
	cat $inputfile | awk -v "trait=$i" -v "gene=$k" '$2==trait && $1==gene {print $1}' | sort -u > $i/$j/$i.$j
	echo -e "$i $j exon.MAF0.05.EigenWeights.b1 -g exon -MAF 0.05 -s Eigen -b 1" >> firstRun.parameters
    done
done

chmod +x *.sh
chmod +x *.py
chmod +x *.R
