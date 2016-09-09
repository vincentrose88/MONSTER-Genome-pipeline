#!/bin/bash
pheno=$1; shift
outputSuffix=$1; shift
otherArguments=$@
mkdir -p $pheno/$outputSuffix/output/plots

cd $pheno/$outputSuffix && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.5.pl -i ../$pheno.genes -o $pheno.$outputSuffix -v $otherArguments