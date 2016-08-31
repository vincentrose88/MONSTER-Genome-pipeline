# MONSTER-Genome-pipeline
Mini pipeline for running genome wide moster burden test on top of Daniels MONSTER wrapper scripts (the real MVP)
**NB: Pipeline is dependent on Daniel Suveges MONSTER wrapper script, and on MONSTER itself.**

### Note on parallelization on SANGER FARM:
Besides the `MONSTER_prepare_wrapper.sh` script and setup.sh script, everything can be parallelized: Just echo the below commands and direct it to bsub_jobarray_FARM_specific.py (see `./bsub_jobarray_FARM_specific.py -h` for how to use this).

Ex. `while read i; do MONSTER_run_wrapper.sh $i; done < phenotype_to_test | bsub_jobarray_FARM_specific.py -n prepareMonster -m 5g`

## How to run

### Input needed: List of genes and associated traits, tab-seperated
Ex. FTO	  BMI

### Run `setup.sh` with gene-trait list as only argument

This create folders and subfolders for each phenotype to be tested and adds a list of genes associated with each phenotype in corresponding folder

It also create `phenotype_to_test` file which we will use to feed the other scripts in the pipeline

**NB: You need to manually link your phenotypes and single point association files in the corresponding folders. Names does matter, so check the scripts. Don't run blindly**

### Run `MONSTER_prepare_wrapper.sh phenotype_to_test` with output_suffix as an additional argument. Should be modified to fit the specifics needs (MAF, MAC, features to include)

Ex `./MONSTER_prepare_wrapper.sh phenotype_to_test firstRun`

**NB can't be parallelized in current form**

This will run Daniels perl MONSTER script, extract the corresponding regions with default exclusions and features (MAF<0.05, exons)

### Run `while read i; do MONSTER_run_wrapper.sh $i firstRun; done < phenotype_to_test` 

This will run the actual MONSTER script on the extracted regions from the previous step (firstRun is the same outputname as before)

### Run `while read i; do 1x/1x_single_snp_assoc/extract_regions.sh $i; done < phenotype_to_test` 

Loops through each single point association (SPA) file (manually linked in 1x_single_snp_assoc folder) and extract the regions used by MONSTER

### Run `while read i; do ./plot_output_nice.R $i; done < phenotype_to_test` 

This plots the SPA regions, marks the SNPs used by MONSTER, notes the p-value from the MONSTER analyse, and saves the SPA results for the used SNPs