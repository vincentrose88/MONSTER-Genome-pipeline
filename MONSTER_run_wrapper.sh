#!/bin/bash
bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh $1/$2/$1.$2_genotype $1/$2/$1.$2_variants 15x_transformed_phenos_4testing/manolis_$1.txt $1/$2/output/$1.$2.monster
rm *mod*