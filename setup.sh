#!/bin/bash
inputfile=$1

while read i; 
    do 
    gene=`awk '{print $1}' <(echo $i)`
    trait=`awk '{print $2}' <(echo $i)`
    mkdir -p $trait/$gene
    echo -e "$gene" > $trait/$gene/$trait.$gene
    echo -e '$trait $gene exon.MAF0.05.EigenWeights.b1 -g exon -MAF 0.05 -s Eigen -b 1' >> firstRun.parameters
done < $inputfile

chmod +x *.sh
chmod +x *.py
chmod +x *.R
