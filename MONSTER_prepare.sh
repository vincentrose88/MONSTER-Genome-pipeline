#!/bin/bash
pheno=$1; shift
gene=$1; shift
outputSuffix=$1; shift
otherArguments=$@
mkdir -p $pheno/$gene/$outputSuffix/output/plots

cd $pheno/$gene/$outputSuffix && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.53.pl -i ../$pheno.$gene -o $pheno.$gene -v $otherArguments
