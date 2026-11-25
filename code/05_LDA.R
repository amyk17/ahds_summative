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

##setting a seed 
amr_lda <- LDA(article_info, k=8 )
