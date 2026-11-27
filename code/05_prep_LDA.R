#!/bin/Rscript

##Data preparation for a seeded Latent Dirichelt Allocation 

#for paths
library(this.path)

#for tidyverse
library(tidyverse)

##tidytext
library(tidytext)

#setting working directory
setwd(paste0(this.dir(), "/.."))

##import tibble 
article_info <- read_rds("./data/clean/article_information.rds") |>
  as_tibble()

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




