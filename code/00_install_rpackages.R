#!/bin/bash

##installing packages not in conda-forge that need to be installed from CRAN 
options(repos = c(CRAN = "https://cloud.r-project.org"))
pkgs <- c("this.path", "ggwordcloud", "topicmodels", "tidylda", "XML")
missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing)) install.packages(missing)
