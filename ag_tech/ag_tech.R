library(tidyverse)
library(gtExtras)
library(gt)
library(dplyr)
library(ggridges)
library(ggthemes)
library(ggtext)

ag <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/ag_tech/data/ag_tech_2021.csv')

ag