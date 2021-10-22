library(tidyverse)
library(gtExtras)
library(gt)
library(dplyr)
library(ggridges)
library(ggthemes)
library(ggtext)

rm(list = ls())

ag <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_BTCUSD_day.csv')