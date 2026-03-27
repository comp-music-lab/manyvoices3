#This code was used to perform the analyses reported in:
#Jia, Z., Purdy, S., & Savage, P. E. (2026 [In press]). Higher pitch, slower tempo, and greater stability in singing than in conversation among Mandarin speakers in Auckland: A Registered Report replicating Ozaki et al. (2024). Peer Community Journal, 6. https://doi.org/10.24072/pcjournal.698 

#Set working directory
setwd('/Users/psav050/Documents/GitHub/manyvoices3')#NB: You need to set this to your own local working directory to reproduce the analysis

#Install and load packages
packages <- c('tidyverse','dplyr','readr','ggplot2','gridExtra')

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(gridExtra)


source('plot_acoustic features.R')
source('plot_cohend.R')
source('plot_irr.R')
