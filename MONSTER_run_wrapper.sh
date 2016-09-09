#!/bin/bash
cd $1/$2 && bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh $1.$2_genotype $1.$2_variants ../../15x_transformed_phenos_4testing/$1_HA.txt output/$1.$2.monster