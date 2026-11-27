rule all: 
    input:
        "logs/01_pmid_derivation.log",
        "logs/02_download_articles.log",
        "logs/03_check_data.log",
        "data/clean/article_information.rds",
        "data/clean/article_search.rds",
        "data/clean/top_terms.rds",
        "results/therapy_wordcloud.png"

rule derive_pmid:
    input: 
        "code/README.md"
    output:
        "logs/01_pmid_derivation.log"
    shell:
        """
        cd code
        bash 01_pmid_derivation.sh > ../logs/01_pmid_derivation.log
        """

rule download_articles:
    input:
        "logs/01_pmid_derivation.log"
    output:
        "logs/02_download_articles.log"
    shell:
        """
        cd code
        bash 02_download_articles.sh > ../logs/02_download_articles.log
        """

rule check_data:
    input:
        "logs/02_download_articles.log"
    output:
        "logs/03_check_data.log"
    shell:
        """
        cd code
        bash 03_check_data.sh > ../logs/03_check_data.log
        """

rule parse_data:
    input:
        "logs/03_check_data.log"
    output:
        "data/clean/article_information.rds"
    shell:
        """
        cd code
        Rscript 04_parsing_data.R
        """

rule lda_preparation:
    input:
        "data/clean/article_information.rds"
    output:
        "data/clean/article_search.rds"
    shell:
        """
        cd code
        Rscript 05_prep_lda.R
        """

rule lda:
    input:
        "data/clean/article_search.rds"
    output:
        "data/clean/top_terms.rds"
    shell:
        """
        cd code
        Rscript 06_lda.R
        """

rule visualisation:
    input:
        "data/clean/top_terms.rds"
    output:
        "results/therapy_wordcloud.png"
    shell:
        """
        cd code
        Rscript 07_data_visualisation.R
        """

rule clean:
    shell: """
    if [ -d results ]; then
        rm -r results  
    else
        echo directory results does not exist
    fi
    if [ -d data/clean ]; then
        rm -r data/clean 
    else
        echo directory clean does not exist
    fi
    if [ -d data/raw ]; then
        rm -r data/raw
    else
        echo directory raw does not exist 
    fi
    if [ -d logs ]; then
        rm -r logs
    else
        echo directory logs does not exist
    fi
    """


