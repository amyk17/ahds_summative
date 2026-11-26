#!/bin/Rscript

##Data preparation for a seeded Latent Dirichelt Allocation 

#for tidyverse
library(tidyverse)

##tidytext
library(tidytext)

#setting working directory
setwd(paste0(this.dir(), "/.."))

##import tibble 
article_info <- read_rds("./data/clean/article_information.rds") |>
  as_tibble()

##setting the list for the seed
therapies <- list(
  antibodies = c("antibodies", "monoclonal antibodies", "IgG",  "mAbs", "immunoprophylaxis", "bioconjugation", "MAPS", "antibody", "immunotherapy", "immunotherapeutic"),
  antisense_therapeutics = c("antisense therapeutics", "mRNA", "RNA", "oligomers", "nucleotide antibiotics", "oligonucleotides", "locked nucleic acids", "phosphorothioates", "phosphorodiamidate morpholino oligomers", "peptide nucleic acids", "bridged nucleic acids"),
  antimicrobial_peptides = c("antimicrobial peptides", "AMPs", "host defense peptides", "CPPs", "bac7"),
  bacteriophages = c("bacteriophages", "phage-derived products", "phages", "bacteriophage endolysins", "lytic phages"),
  CRISPR = c("CRISPR", "Cas9", "Cas12", "Cas13", "SpyCas9", "gRNA" ),
  other_antibiotics = c("narrow spectrum antibiotics", "first-line antibiotics", "novel antibiotics", "gram negative", "gram positive"),
  resistance_breakers = c("resistance breakers", "adjuvants", "matrix disruptors", "efflux pump inhibitors", "membrane permeabilizers", "beta-lactamase inhibitors" ),
  vaccinations = c("vaccin*", "immunisation", "herd immunity")
)

##merging abstract & title for search
article_info <- article_info |>
  mutate(title_abstract = str_squish(paste(Title, Abstract)) )

##tokenisation 
article_info <- article_info |>
  unnest_tokens(output = token_text,
              input = title_abstract)

##remove stop words
article_info <- article_info |>
  anti_join(stop_words, join_by(token_text == word)) 


##creating tibble for each PMID - all tokens for each article are in 1 row
article_info <- article_info |>
  group_by(PMID, Year, Title, Abstract) |> ##grouping words from same article in 1 tibble 
  nest()

#removing title & abstract columns
article_info <- article_info |>
  ungroup() |> ##cannot remove columns from a grouped tibble
  select (-c(Title, Abstract))

##save tibble
write_rds(article_info, "./data/clean/article_search.rds")




