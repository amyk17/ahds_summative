#!/bin/Rscript

##for associating key words
install.packages("keyATM")
library(keyATM)

##tidyverse
library(tidyverse)

##tidytext
library(tidytext)

##setting working directory
setwd(paste0(this.dir(), "/.."))

##importing the article information tibble
article_info <- read_rds("./data/clean/article_information.rds") |>
  as_tibble()

##merging titles and abstract for guided search 
article_info <- article_info %>%
mutate(title_abstract = str_squish(paste(Title, Abstract)) )

##defining keyword dictionary for guided search
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

##create columns based on therapies
for (nm in names(therapies))
{
  article_info[[nm]] <- str_detect(article_info$title_abstract, regex(therapies[[nm]], ignore_case = TRUE))
}

##save as rds
write_rds(article_info, "./data/clean/article_therapies.rds")

