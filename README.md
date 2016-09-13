# MONSTER-Genome-pipeline
Mini pipeline for running genome wide moster burden test on top of Daniels MONSTER wrapper scripts (the real MVP)
**NB: Pipeline is dependent on Daniel Suveges MONSTER wrapper script, and on MONSTER itself.**

### Known issues
#### No single point association (SPA) file found for phenotype doesn't return any nice errors
#### Extractor not returning any SPA variants in given region: Extractor returns empty files, which the plotter knowns to ignore. Not an elegant solution.
#### Returns `broken pipe` even when working

### Note on parallelization on SANGER FARM:
Besides the setup.sh script, everything can be parallelized: Just echo the below commands (inside while loop) and direct it to bsub_jobarray_FARM_specific.py (see `./bsub_jobarray_FARM_specific.py -h` for how to use this).

Ex. `while read i; do echo -e "MONSTER_run_wrapper.sh $i"; done < phenotypes_to_test | bsub_jobarray_FARM_specific.py -n prepareMonster -m 5g`

## How to run

### Input needed: List of genes and associated traits, tab-seperated or white space-seperated, **no header**
See `gene_traits_all` as example

### Run `setup.sh` with gene-trait list as only argument

This create folders and subfolders for each phenotype and each gene to be tested

It also create `firstRun.par` file which we will use to feed the other scripts in the pipeline (exon, maf=5%, Eigen weights, b=1)

**NB: You need to manually link your phenotypes and single point association files in the corresponding folders. Names does matter, so check the scripts. Don't run blindly**

### Run the MONSTER main script (Prepare and Run)

`while read par; do ./MONSTER_prepare_and_run_wrapper.sh $par; done < firstRun.par` 

This will run Daniels perl MONSTER script, extract the corresponding regions and then run the actual MONSTER script on the extracted regions

### Extract single point association

`while read i; do 1x_single_snp_assoc/extract_regions.sh $i firstRun; done < <(awk '{print $1,$2,$3}' firstRun.par)` 

**NB: This is a slow process - only do for selected genes**. Loops through each single point association (SPA) file (manually linked in 1x_single_snp_assoc folder) and extract the regions used by MONSTER. 

**NB: The $1 $2 and $3 arguments in the awk-command correspond to phenotype, gene and outputSuffix, respectively.**

### Plots single point association

`while read i; do ./plot_output_nice.R $i firstRun; done < <(awk '{print $1,$2,$3}' firstRun.par)` 
This plots the SPA regions, marks the SNPs used by MONSTER, notes the p-value from the MONSTER analyse, and saves the SPA results for the used SNPs


# Old manual version control mini-pipeline overview

## Change log:
### V2.0
	Clean up and added to github. Manual version-loggin dismissed
### V1.3
	Added setup script to automatically set up folder-structure
### V1.2 = NULL
	Tried to split 1x single point association files into chromosome but ended up taking too much diskspace (above 1TB) so removed them again.
### V1.11
	Fixed extractor bug, rerun extraction and plot (with extra plot-features)
### V1.1
	Added known errors and issues, rerun with extra genes manually found
### V1.0
	Run pipeline for UK10K
### V0.0
	Tested with BMI manually - UK10K genes

# Mini-pipeline

**all folders and starting-files are already premade manully or using the setup.sh script: ./setup.sh gene_traits_final (tab-seperated file with header)**
**Using google spreadsheet and R I've sorted out a list of genes for each phenotype, created folders for each phenotype and put the gene-list there.**
**Additionally I've also linked all the single-point association results for the 1x data (firstly Manolis)**


## Example for BMI - can be exchanged with a loop-iter that goes through the phenotypes_to_be_tested file

### First enter the folder, run Daniels wrapper script, which dumps a lot into that folder

	`cd BMI/ && perl /nfs/team144/ds26/burden_testing/scripts/burden_get_regions_v2.2.pl  -i BMI.genes -o BMI.UK10 -G exon -MAF 0.05`

### Then run the monster with the resulting files and save in a subfolder:

      `bash /nfs/team144/ds26/burden_testing/scripts/MONSTER_wrapper.sh BMI/BMI.UK10_genotype BMI/BMI.UK10_variants 15x_transformed_phenos_4testing/manolis_BMI.txt BMI/output/BMI.UK10_monster`

### Now find regions in the single point SNP associations and put into the output-folder (use nifty script for this):

     `1x_single_snp_assoc/extract_regions.sh BMI`

#### Parallized:

  `while read line; do echo -e "1x_single_snp_assoc/extract_regions.sh $line"; done < phenotypes_to_be_tested | ~/submit_jobarray.py -n extractor -m 5g`

### This finds the regions from the BED-files (GRCh37 mapped) and extract the corresponding single snp associations and puts them in the output subfolder

### Now create a nice output, using another nifty script (this time in R):

     `./plot_output_nice.R BMI`

#### Parallized:

  `while read line; do echo -e "./plot_output_nice.R $line"; done < phenotypes_to_be_tested | ~/submit_jobarray.py -n plotNice -m 2g`

 

# Known error/issues 
## V. 1.1:
No single point association (SPA) file found for phenotype
Extractor not returning any SPA variants in given region
No rare or common SPA variants returns empty plot
Daniels wrapper script not able to parallized - gives weird error of files not being there or individuals missing (!?)
Return broken pipe even when working

Coverage of variants between 1x and 15x is very strange - any filtering beside MAF on monster?
