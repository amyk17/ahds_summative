#!/bin/Rscript 

##tidyverse
library(tidyverse)

####install and load LDA generation
install.packages("topicmodels")
library(topicmodels)

##for LDA
install.packages("tidylda")
library(tidylda)

#for paths
library(this.path)

##tidytext
library(tidytext)

##set working directory
setwd(paste0(this.dir(), "/.."))

##importing tibble
article_search <- read_rds("./data/clean/article_search.rds") |>
  as_tibble()

##setting the list for the seed
therapies <- list(
  antibodies = c("antibodies", "monoclonal antibodies", "IgG",  "mAbs", "immunoprophylaxis", "bioconjugation", "MAPS", "antibody", "immunotherapy", "immunotherapeutic"),
  antisense_therapeutics = c("antisense therapeutics", "mRNA", "RNA", "oligomers", "nucleotide antibiotics", "oligonucleotides", "locked nucleic acids",
                             "phosphorothioates", "phosphorodiamidate morpholino oligomers", "peptide nucleic acids", "bridged nucleic acids"),
  antimicrobial_peptides = c("antimicrobial peptides", "AMPs", "host defense peptides", "CPPs", "bac7"),
  bacteriophages = c("bacteriophages", "phage-derived products", "phages", "bacteriophage endolysins", "lytic phages"),
  crispr = c("CRISPR", "Cas9", "Cas12", "Cas13", "SpyCas9", "gRNA" ),
  resistance_breakers = c("resistance breakers", "adjuvants", "matrix disruptors", "efflux pump inhibitors", "membrane permeabilizers", "beta-lactamase inhibitors" ),
  vaccinations = c("vaccines", "immunisation", "herd immunity", "vaccinations")
)

#removing generic words from the search that will distract from the therapy
generic_words <- c("antibiotic", "resistance", "acid", "therapeutics", "therapy", "antimicrobial", "dna", "bacteria", "bacterial", "infection", "broad",
                   "treatment", "patient", "infections", "drug", "mortality", "stewardship", "gram", "study", "1", "susceptibility", 
                   "95", "rapid", "vivo", "ci", "patients", "resistant", "outcomes", "methods", "results", "patterns", "producing", "2", "negative", "antibiotics",
                   "health", "chronic", "ml", "days", "clinical", "activity", "review", "3", "hospital", "amr", "studies", "data", "evidence", "including", "guidelines", "management",
                   "care", "strategies")

##expanding search so multiword phrases can be read
expand_seeds <- function(terms, seed_vocab) {
  words <- terms |> tolower() |> str_split("[ \\-]+") |> unlist() |> unique() |> setdiff(generic_words) ##cleans to single words & lowercase
  pats  <- paste0("^", "$") ##turns each word into a regular expression
  seed_vocab[str_detect(tolower(seed_vocab), str_c(pats, collapse = "|"))]
}

##creating matrix for lda
words_matrix <- article_search |>
  unnest(data) |>
  count(PMID, token_text) |>
  filter(!token_text %in% generic_words, !str_detect(token_text, "^[0-9]+$")) |> 
  anti_join(tibble(token_text = generic_words), by = "token_text") |>
  cast_sparse(PMID, token_text, n)

##setting variables
seed_vocab <- colnames(words_matrix)
num_resid <- 1 #number of 'other' categories
therapy_types <-c(names(therapies), paste0("residual_", seq_len(num_resid))) #categories
base_prior <- 0.05 #weak association for non-topic words
therapy_prior <- 1 #stronger association for topical words
boost <- 1

##create eta to control the topic word distribution
control_distribution <- matrix(0.05, nrow = length(therapy_types), ncol=length(seed_vocab), dimnames = list(therapy_types, seed_vocab))

##search for matches in words
for (nm in names(therapies)){
  pattern <- paste0("^(", paste(therapies[[nm]], collapse = "|"), ")")
  hits <-grep(pattern, seed_vocab, ignore.case=TRUE)
  message(nm, ": ", sum(hits), " seed words found in article information")
  control_distribution[nm, hits] <- boost
}

##fitting the LDA model
set.seed(1)
therapies_lda <- tidylda(
    data= words_matrix,
    k= 8,
    iterations= 1000,
    burnin = 500,
    alpha = 0.1,
    eta = control_distribution,
    verbose = TRUE,
    optimize_alpha = FALSE,
    calc_likelihood = TRUE, 
    likelihood_every = 10, 
    calc_r2 = FALSE, 
    threads=1,
    mh_steps = 1
    )

beta  <- tidy(therapies_lda, matrix = "beta")    # topic, token, beta

top_terms <- beta |>
  group_by(topic) |> 
  slice_max(beta, n = 25)
  
##save top terms per therapy
write_rds(top_terms, "./data/clean/top_terms.rds")