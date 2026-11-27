#!/bin/Rscript

##tidytext
library(tidytext)

#for paths
library(this.path)

##plots
library(ggplot2)

##tidyverse
library(tidyverse)

##wordcloud
install.packages("ggwordcloud")
library(ggwordcloud)

##set working directory
setwd(paste0(this.dir(), "/.."))

##loading top terms file
top_terms <- read_rds("./data/clean/top_terms.rds")

##creating colour terms
therapy_groups<- sort(unique(top_terms$topic))
therapy_colours <- setNames(
  c("darkolivegreen", "deepskyblue4", "darkmagenta", "darkorange", "firebrick2", "blue4", "goldenrod2", "hotpink1")
  [seq_along(therapy_groups)],
  therapy_groups
  )

word_colours <- therapy_colours[as.character(top_terms$topic)]

top_terms <- top_terms |>
  group_by(topic) |> 
  slice_max(beta, n = 20) |> ##reducing number of words from each category in the cloud
  ungroup() ##ungrouping so topic is recognised by ggplot
  

##creating aes terms outside of ggplot so wordcloud runs
terms_map <- aes(label = token, size = beta, color = factor(topic))

##creating the wordcloud
set.seed(1)
therapy_cloud <- (ggplot(data=top_terms, mapping=terms_map) +
  geom_text_wordcloud_area(show.legend = TRUE) +
    scale_size_area(max_size=20) +
    scale_colour_manual(labels = c("Antibodies", "Anti-sense Therapeutics", "Anti-microbial Peptides", "Bacteriophages", 
                        "CRISPR", "Resistance Barriers", "Vaccinations", "Other Therapies"),
                        values = word_colours,
                        name= "Therapies") +
    theme_minimal() #+
    #facet_wrap("topic") ##to sort into individual therapy specific wordclouds
)

##creating results directory
dir.create("results")

##saving wordcloud as an image
ggsave("./results/therapy_wordcloud.png", plot=therapy_cloud, height=6, width = 10, units = "in")
  
