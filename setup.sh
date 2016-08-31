#!/bin/bash
inputfile=$1

traits=`cat $inputfile | awk '$2!="Trait" {print $2}' | sort -u`
for i in $traits; 
do 
    mkdir -p $i/output
    cat $inputfile | awk -v "trait=$i" '$2==trait {print $1}'| sort -u > $i/$i.genes
done
echo $traits | tr ' ' '\n' > phenotypes_to_test
chmod +x *.sh
chmod +x *.py
chmod +x *.R
