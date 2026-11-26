#!/bin/Rscript

##tidytext
library(tidytext)

##plots
library(ggplot2)

##tidyverse
library(tidyverse)

##wordcloud
install.packages("wordcloud")
library(wordcloud)

##set working directory
setwd(paste0(this.dir(), "/.."))

##loading top terms file
top_terms <- read_rds("./data/clean/top_terms.rds")

##creating colour terms
therapy_groups<- sort(unique(top_terms$topic))
therapy_colours <- setNames(
  c("darkolivegreen", "deepskyblue4", "darkmagenta", "darkorange", "maroon", "firebrick2", "turquoise1", "goldenrod2", "hotpink1")
  [seq_along(therapy_groups)],
  therapy_groups
  )

word_colours <- therapy_colours[as.character(top_terms$topic)]

##creating the wordclouds 
wordcloud(
  top_terms$token,
  freq= top_terms$beta,
  max.words = 150,
  random.order = FALSE,
  rot.per=0,
  colors = word_colours,
  ordered.colors = TRUE)

