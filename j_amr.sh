#!/bin/bash

#SBATCH --account=SSCM040064
#SBATCH --job-name=amr_visualisation
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:20:00
#SBATCH--mem=500M

module add languages/R/4.5.1

conda activate env_2394435

snakemake --profile 