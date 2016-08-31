# MONSTER-Genome-pipeline
Mini pipeline for running genome wide moster burden test on top of Daniels MONSTER wrapper scripts (the real MVP)
**NB: Pipeline is dependent on Daniel Suveges MONSTER wrapper script, and on MONSTER itself.**

### Note on parallelization on SANGER FARM:
Besides the `MONSTER_prepare_wrapper.sh` script and setup.sh script, everything can be parallelized: Just echo the below commands and direct it to bsub_jobarray_FARM_specific.py (see `./bsub_jobarray_FARM_specific.py -h` for how to use this).

Ex. `while read i; do MONSTER_run_wrapper.sh $i; done < phenotype_to_test | bsub_jobarray_FARM_specific.py -n prepareMonster -m 5g`

## How to run

### Input needed: List of genes and associated traits, tab-seperated
See `gene_traits_all` as example

### Run `setup.sh` with gene-trait list as only argument

This create folders and subfolders for each phenotype to be tested and adds a list of genes associated with each phenotype in corresponding folder

It also create `phenotype_to_test` file which we will use to feed the other scripts in the pipeline

**NB: You need to manually link your phenotypes and single point association files in the corresponding folders. Names does matter, so check the scripts. Don't run blindly**

### Run `while read i; do MONSTER_prepare_wrapper.sh $i firstRun; done < phenotype_to_test` with output_suffix as an additional argument. 
Should be modified to fit the specifics needs (MAF, MAC, features to include)

Ex `./MONSTER_prepare_wrapper.sh phenotype_to_test firstRun`

**NB can't be parallelized in current form**

This will run Daniels perl MONSTER script, extract the corresponding regions with default exclusions and features (MAF<0.05, exons)

### Run `while read i; do MONSTER_run_wrapper.sh $i firstRun; done < phenotype_to_test` 

This will run the actual MONSTER script on the extracted regions from the previous step (firstRun is the same outputname as before)

### Run `while read i; do 1x/1x_single_snp_assoc/extract_regions.sh $i; done < phenotype_to_test` 

Loops through each single point association (SPA) file (manually linked in 1x_single_snp_assoc folder) and extract the regions used by MONSTER

### Run `while read i; do ./plot_output_nice.R $i; done < phenotype_to_test` 

This plots the SPA regions, marks the SNPs used by MONSTER, notes the p-value from the MONSTER analyse, and saves the SPA results for the used SNPs#Date: 31/8/2016-25/8/16 (V.1.3)


# Old manual version control mini-pipeline overview

#Change log:
#V2.0
	Clean up and added to github. Manual version-loggin dismissed
#V1.3
	Added setup script to automatically set up folder-structure
#V1.2 = NULL
	Tried to split 1x single point association files into chromosome but ended up taking too much diskspace (above 1TB) so removed them again.
#V1.11
	Fixed extractor bug, rerun extraction and plot (with extra plot-features)
#V1.1
	Added known errors and issues, rerun with extra genes manually found
#V1.0
	Run pipeline for UK10K
#V0.0
	Tested with BMI manually - UK10K genes


#####

#all folders and starting-files are already premade manully or using the setup.sh script: ./setup.sh gene_traits_final (tab-seperated file with header)
#Using google spreadsheet and R I've sorted out a list of genes for each phenotype, created folders for each phenotype and put the gene-list there.
#Additionally I've also linked all the single-point association results for the 1x data (firstly Manolis)


#Example for BMI - can be exchanged with a loop-iter that goes through the phenotypes_to_be_tested file

##First enter the folder, run Daniels wrapper script, which dumps a lot into that folder

	cd BMI/ && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.2.pl  -i BMI.genes -o BMI.UK10 -G exon -MAF 0.05

##Then run the monster with the resulting files and save in a subfolder:

      bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh BMI/BMI.UK10_genotype BMI/BMI.UK10_variants 15x_transformed_phenos_4testing/manolis_BMI.txt BMI/output/BMI.UK10_monster

#Now find regions in the single point SNP associations and put into the output-folder (use nifty script for this):

     1x_single_snp_assoc/extract_regions.sh BMI

## Parallized:

  while read line; do echo -e "1x_single_snp_assoc/extract_regions.sh $line"; done < phenotypes_to_be_tested | ~/submit_jobarray.py -n extractor -m 5g

## This finds the regions from the BED-files (GRCh37 mapped) and extract the corresponding single snp associations and puts them in the output subfolder

#Now create a nice output, using another nifty script (this time in R):

     ./plot_output_nice.R BMI

##Parallized:

  while read line; do echo -e "./plot_output_nice.R $line"; done < phenotypes_to_be_tested | ~/submit_jobarray.py -n plotNice -m 2g

 

### Known error/issues 
#V. 1.1:
No single point association (SPA) file found for phenotype
Extractor not returning any SPA variants in given region
No rare or common SPA variants returns empty plot
Daniels wrapper script not able to parallized - gives weird error of files not being there or individuals missing (!?)
# Return broken pipe even when working

Coverage of variants between 1x and 15x is very strange - any filtering beside MAF on monster?
