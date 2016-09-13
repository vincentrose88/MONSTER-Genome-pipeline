#!/bin/bash
pheno=$1; shift
gene=$1; shift
outputSuffix=$1; shift
otherArguments=$@
mkdir -p $pheno/$outputSuffix/output/plots

cd $pheno/$gene/$outputSuffix && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.5.pl -i ../$pheno.$gene -o $pheno.$gene.$outputSuffix -v $otherArguments
cd $pheno/$gene/$outputSuffix && bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh $pheno.${geno}_genotype $pheno.${geno}_variants ../../../15x_transformed_phenos/${pheno}_HA.txt output/$pheno.$geno.monster