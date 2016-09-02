#!/bin/bash
for i in $1/$2/*_GRCh37.bed;
do
    phenotype=`basename $1`
    gene=`basename $i | cut -d'_' -f1`
    chr=`cut -f1 $i | head -1 | sed 's/chr//g'`
    min=`cut -f2 $i | sort -n | head -1`
    max=`cut -f3 $i | sort -n | tail -1`
    echo -e "gene:\t$i\nChr:\t$chr\nstart\t$min\nend\t$max"
    zcat $(dirname $0)/MANOLIS.$phenotype.assoc.txt.gz | awk -v "min=$min" -v "max=$max" -v "chr=$chr" 'NR==1 || ($1==chr && $3<=max && $3>min)' > $1/output/$gene.assoc
done