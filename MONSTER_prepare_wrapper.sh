#!/bin/bash
mkdir -p $1/$2/output/plots
cd $1/$2 && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.2.pl -i ../$1.genes -o $1.$2 -G gene -MAF 0.05 -v