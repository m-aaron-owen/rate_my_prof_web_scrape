library(shiny)
library(ggplot2)
library(dplyr)

library(tm)
library(wordcloud)
library(memoise)

profs = read.csv("profs_cleaned.csv", stringsAsFactors = F)
grouped_profs = read.csv("grouped_profs.csv", stringsAsFactors = F)
grouped_profs = grouped_profs %>% select(-X)
