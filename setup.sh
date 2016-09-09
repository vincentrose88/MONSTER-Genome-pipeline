#!/bin/bash
inputfile=$1

traits=`cat $inputfile | awk '$2!="Trait" {print $2}' | sort -u`
for i in $traits; 
do 
    mkdir $i/
    cat $inputfile | awk -v "trait=$i" '$2==trait {print $1}'| sort -u > $i/$i.genes
    echo -e "$i firstRun.exon.MAF0.05.EigenWeights.b1 -g exon -MAF 0.05 -s Eigen -b 1" >> firstRun.parameters
done

chmod +x *.sh
chmod +x *.py
chmod +x *.R
