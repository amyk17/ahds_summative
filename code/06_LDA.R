#!/bin/Rscript

##install and load tidylda for LDA generation
install.packages("tidylda")
library(tidylda)

#for tidyverse
library(tidyverse)

#setting working directory
setwd(paste0(this.dir(), "/.."))

##import .rds of tibble
read_rds("./data/clean/article_information.rds")