library(tidyverse)
library(gtExtras)
library(gt)
library(dplyr)
library(ggridges)
library(ggthemes)
library(ggtext)

ag <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/ag_tech/data/ag_tech_2021.csv')

ggplot(data.frame(funding = ag$Total_Funding_Amount), aes(x = funding)) +
  geom_histogram(color = "black", fill = "#1FA187") +
  labs(title = "Total Funding by Top AgTech Companies",
       x =  NULL) +
  theme_minimal() +
  scale_x_continuous(labels= label_number(scale = 1e-6, prefix = "$", suffix = "M", accuracy = 6))