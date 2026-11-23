#!/bin/bash

##set working directory
datadir="${1:-../data/raw/batches}"

#make directory for the cleaned data
mkdir -p "../data/cleaned"

#counting duplicates
duplicate_num=$(cat "$datadir"/batch_??.xml | grep -o '<Id>[0-9]*</Id>' | sed 's/<[^>]*>//g' | sort | uniq -d | wc -l)
echo "Number of duplicate articles found: $duplicate_num"

##total number of articles for reference
articles=$(cat "$datadir"/batch_??.xml| grep -o '<PubmedArticle>' | wc -l) ##just articles
echo "Number of articles fetched: $articles"
book_articles=$(cat "$datadir"/batch_??.xml | grep -o '<PubmedBookArticle>' | wc -l) ##book articles
echo "Number of book articles: $book_articles"
total=$((articles + book_articles))
echo "Total number of articles: $total" ##total of book and online articles

##checking each article has a title
article_title=$(cat "$datadir"/batch_??.xml | grep -o '<ArticleTitle>' | wc -l)
echo "Number of articles without a title: $((total - article_title))"

##checking each article has an abstract
article_abstract=$(cat "$datadir"/batch_??.xml | grep -o '<AbstractText>' | wc -l)
echo "Number of articles without an abstract: $((total - article_abstract))"

##checking each article has a publication date
article_pub=$(cat "$datadir"/batch_??.xml | grep -o '<PubDate>' | wc -l)
echo "Number of articles without a publication date: $((total - article_pub))"





