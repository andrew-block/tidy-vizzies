library(tidyverse)
library(gtExtras)
library(gt)

btc <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_BTCUSD_day.csv')
eth <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_ETHUSD_day.csv')
ltc <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_LTCUSD_day.csv')