#!/bin/bash
inputfile=$1

inputTraitGene=`cat $inputfile | awk '$2!="Trait" || '$1!="Gene" {print $0}' | sort -u`
for i in $inputTraitGene;
    do 
    gene=`awk '{print $1}'`
    trait`awk '{print $2}'`
    mkdir -p $trait/$gene
    echo -e "$gene" > $trait/$gene/$trait.$gene
    echo -e "$trait $gene exon.MAF0.05.EigenWeights.b1 -g exon -MAF 0.05 -s Eigen -b 1" >> firstRun.parameters
    done
done

chmod +x *.sh
chmod +x *.py
chmod +x *.R
