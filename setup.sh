#!/bin/bash
inputfile=$1

traits=`cat $inputfile | awk '$2!="Trait" {print $2}' | sort -u`
for i in $traits; 
do 
    mkdir $i/
    cat $inputfile | awk -v "trait=$i" '$2==trait {print $1}'| sort -u > $i/$i.genes
done
echo -e "$traits firstRun -g exon -MAF 0.05 -s Eigen -b 1" | tr ' ' '\n' > firstRun.parameters
chmod +x *.sh
chmod +x *.py
chmod +x *.R
