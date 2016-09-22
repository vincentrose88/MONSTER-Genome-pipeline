#!/bin/bash
pheno=$1; shift
gene=$1; shift
outputSuffix=$1; shift
otherArguments=$@
SNPinfo=$pheno/$gene/$outputSuffix/$pheno.${gene}_SNP_info 
positions="awk '{print \$2}' <(tail -n+2 $SNPinfo)"

chr=`eval $positions | cut -d'_' -f1 | head -1 | sed 's/chr//g'`
min=`eval $positions | cut -d'_' -f2 | sort -n | head -1`
max=`eval $positions | cut -d'_' -f2 | sort -n | tail -1`
echo -e "Gene:\t$gene\nChr:\t$chr\nRegion start\t$min\nRegion end\t$max"
zcat $(dirname $0)/MANOLIS.$pheno.assoc.txt.gz | awk -v "min=$min" -v "max=$max" -v "chr=$chr" 'NR==1 || ($1==chr && $3<=max && $3>min)' > $pheno/$gene/$outputSuffix/output/$gene.assoc
