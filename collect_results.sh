#!/bin/bash
count=0
while read line
do
    pheno=`awk '{print $1}' <(echo $line)`
    gene=`awk '{print $2}' <(echo $line)`
    outputSuffix=`awk '{print $3}' <(echo $line)`

    if [ $count -eq 0 ] #Create folder and adds header to results file
	then
	echo -e 'TestName\tTrait\tGene\tN.Ind\tN.SNPs\tRho\tP' > $1.results.merged
	count=$(( $count + 1))
	awk -v "TestName=$outputSuffix" -v "pheno=$pheno" 'NR>1 {print TestName"\t"pheno"\t"$0}' $pheno/$gene/$outputSuffix/output/$pheno.$gene.monster.out >> $1.results.merged
    else
	awk -v "TestName=$outputSuffix" -v "pheno=$pheno" 'NR>1 {print TestName"\t"pheno"\t"$0}' $pheno/$gene/$outputSuffix/output/$pheno.$gene.monster.out >> $1.results.merged    	
    fi

done < $1

