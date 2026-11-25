#!/bin/Rscript

##install packages
install.packages("XML")

##download packages
#tidyverse
library(tidyverse)

#reading the xml files 
library(xml2)
library(XML)

#setting the working directory
setwd(paste0(this.dir(), "/.."))

##create variable for checked data directory 
clean_dir <- "./data/clean/"

##creating an object of batch_??.xml files to specify file use
articles<-list.files(clean_dir, pattern="^batch_.*\\.xml$", full.names=TRUE)

##creating a list of the batches (+article information)
xml_articles <- map(articles, read_xml)

##extracting article information from xml file list 
article_info <- map_dfr(xml_articles, function(x) {
  records <- xml_find_all(x, ".//PubmedArticle | .//PubmedBookArticle")
  map_dfr(records, function(article) {
  tibble(
      PMID = xml_text(xml_find_first(article, ".//PMID")),
      Year = xml_text(xml_find_first(article, ".//Year")),
      Title = xml_text(xml_find_first(article, ".//ArticleTitle | .//BookTitle")),
      Abstract = paste(xml_text(xml_find_all(article, ".//Abstract/AbstractText")), collapse = " ")
    )
  })
})

##check correct number of rows and columns
glimpse(article_info)

##saving tibble as an RDS file
write_rds(article_info, "./data/clean/article_information.rds")
