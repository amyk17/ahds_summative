#!/bin/Rscript

##Performing a seeded Latent Dirichelt Allocation 

##install and load LDA generation
install.packages("topicmodels")
library(topicmodels)

##for seeded LDA
install.packages("seededlda")
library(seededlda)

#for tidyverse
library(tidyverse)

#setting working directory
setwd(paste0(this.dir(), "/.."))

##import tibble 
article_info <- read_rds("./data/clean/article_therapies.rds") |>
  as_tibble()

##setting the list for the seed
therapies <- list(
  antibodies = "antibodies| monoclonal antibodies | IgG | mAbs | immunoprophylaxis | bioconjugation | MAPS | antibody | immunotherapy | immunotherapeutic",
  antisense_therapeutics = "antisense therapeutics | mRNA | RNA | oligomers | nucleotide antibiotics | oligonucleotides | locked nucleic acids | phosphorothioates | phosphorodiamidate morpholino oligomers | peptide nucleic acids | bridged nucleic acids",
  antimicrobial_peptides = "antimicrobial peptides | AMPs | host defense peptides | CPPs | bac7",
  bacteriophages = "bacteriophages | phage-derived products | phages | bacteriophage endolysins | lytic phages ",
  CRISPR = "CRISPR | Cas9 | Cas12 | Cas13 | SpyCas9 | gRNA ",
  other_antibiotics = "narrow spectrum antibiotics | first-line antibiotics | novel antibiotics | gram negative | gram positive",
  resistance_breakers = "resistance breakers | adjuvants | matrix disruptors | efflux pump inhibitors | membrane permeabilizers | beta-lactamase inhibitors ",
  vaccinations = "vaccinations | vaccines | immunisation"
)