#!/bin/bash
inputfile=$1

while read i; 
    do 
    gene=`awk '{print $2}' <(echo $i)`
    trait=`awk '{print $1}' <(echo $i)`
    mkdir -p $trait/$gene
    echo -e "$gene" > $trait/$gene/$trait.$gene
    echo -e "$trait $gene exon.MAF0.05.mSNP0.01 -G exon -MAF 0.05 -m 0.01" >> firstRun.par
done < $inputfile

chmod +x *.sh
chmod +x *.py
chmod +x *.R
