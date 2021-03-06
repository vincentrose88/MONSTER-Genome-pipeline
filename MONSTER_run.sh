#!/bin/bash
pheno=$1; shift
gene=$1; shift
outputSuffix=$1; shift
otherArguments=$@

cd $pheno/$gene/$outputSuffix && bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh $pheno.${gene}_genotype $pheno.${gene}_variants ../../../15x_transformed_phenos/${pheno}_HA.txt output/$pheno.$gene.monster
