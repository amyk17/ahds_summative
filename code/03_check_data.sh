#!/bin/bash

##set working directory
datadir="${1:-../data/raw/batches}"

#counting duplicates
duplicate_num=$(cat "$datadir"/batch_??.xml | grep -oE '<PMID Version="1">[0-9]+' | sed 's/<[^>]*>//g' | sort | uniq -d | wc -l)
echo "Number of duplicate articles found: $duplicate_num"

##total number of articles for reference
articles=$(cat "$datadir"/batch_??.xml| grep -o '<PubmedArticle>' | wc -l) ##just articles
echo "Number of articles fetched: $articles"

##total number of book articles
book_articles=$(cat "$datadir"/batch_??.xml | grep -o '<PubmedBookArticle>' | wc -l) ##book articles
echo "Number of book articles: $book_articles"

##total number of records fetched 
total=$((articles + book_articles))
echo "Total number of records: $total" ##total of book and online articles

##checking each article has a title
article_title=$(cat "$datadir"/batch_??.xml | grep -o '<ArticleTitle>' | wc -l)
echo "Number of articles without a title: $((articles - article_title))" ##doesn't include book articles with a title

##checking each article has an abstract
article_abstract=$(cat "$datadir"/batch_??.xml | grep -o '<Abstract>' | wc -l)
echo "Number of articles without an abstract: $((articles - article_abstract))" ###doesn't include book articles

##checking each book article has a title
book_title=$(cat "$datadir"/batch_??.xml | grep -o '</BookTitle>' | wc -l)
echo "Number of book articles without a title: $((book_articles - book_title))"

##checking each book article has an abstract, using perl to look at more than 1 match in a line
book_abstract=$(cat "$datadir"/batch_??.xml | perl -0777 -ne '
  $with_abstract = grep { /<Abstract/ } /<PubmedBookArticle>.*?<\/PubmedBookArticle>/gs;
  print $with_abstract
  ')
echo "Number of book articles without an abstract: $((book_articles - book_abstract ))"

##checking each fetched article (including books) has a publication date
article_pub=$(cat "$datadir"/batch_??.xml | grep -o '<PubDate>' | wc -l)
echo "Number of articles without a publication date: $((total - article_pub))"

##create directory for formatted data
mkdir -p "../data/raw/formatted"

##formatting data to use awk for removing articles
for f in "$datadir"/batch_??.xml; do
  xmllint --format --nonet "$f" > "../data/raw/formatted/$(basename "$f")" || echo "xmllint failed on $f"
done

##create directory to put checked & altered articles in 
mkdir -p "../data/clean"

##removing articles with missing abstracts from the formatted copies
for f in ../data/raw/formatted/batch_??.xml; do
  out="../data/clean/$(basename "$f")"
  awk '
    /<PubmedArticle>/ { inrec=1; rec=""; has=0 }
    inrec {
      rec = rec $0 "\n"
      if ($0 ~ /<Abstract>/) has=1
      if ($0 ~ /<\/PubmedArticle>/) { if (has) printf "%s", rec; inrec=0 }
      next
    }
    { print }
  ' "$f" > "$out"
done


##checking the new number of articles with abstracts
num_ab_articles=$(cat ../data/clean/batch_??.xml | grep -o '<Abstract>' | wc -l)
echo "Number of articles with an abstact: $num_ab_articles"

#checking the new number of book articles with abstracts
num_book_ab=$(cat ../data/clean/batch_??.xml | perl -0777 -ne '
  $with_abstract = grep { /<Abstract/ } /<PubmedBookArticle>.*?<\/PubmedBookArticle>/gs;
  print $with_abstract
  ')
echo "Number of book articles with an abstract: $num_book_ab" 

##total number of checked articles (should be 6792)
chk_total=$((num_ab_articles + num_book_ab))
echo "Total number of checked articles: $chk_total"



