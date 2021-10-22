library(tidyverse)
library(gtExtras)
library(gt)
library(dplyr)
library(ggridges)
library(ggthemes)
library(ggtext)

rm(list = ls())

btc <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_BTCUSD_day.csv')


btc <- btc[order(btc$Symbol, btc$Unix),]
btc$Year <- format(btc$Date, format="%Y")

crypto <-
  btc %>%
    group_by(Symbol) %>%
    mutate(
      Daily_Change = (Close - lag(Close)),
      Change = case_when(
        Daily_Change > 0 ~ "Positive",
        Daily_Change <= 0 ~ "Negative"
      ),
      Color = case_when(
        Daily_Change > 0 ~ "#D50A0A",
        Daily_Change <= 0 ~ "#013369"
      ),
      Yesterday = lag(Close),
      Percent_Change = Daily_Change/Yesterday
    )

crypto <- crypto[crypto$Low != 0, ]



stand_density +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  coord_cartesian(xlim = c(-7500, 8000)) +
  ggtext::geom_richtext(
    data = crypto,
    aes(x = Percent_Change, y = Daily_Change, color = Color),
    fill = "#f0f0f0", label.color = NA, # remove background and outline
    label.padding = grid::unit(rep(0, 4), "pt"), # remove padding
    family = "Chivo", hjust = 0 , fontface = "bold",
    size = 6
  ) +
  theme(panel.grid.major.y = element_blank()) +
  labs(
    x = "Point Differential", y = "",
    title = "Playoff teams typically have a positive point differential",
    subtitle = "Data through week 15 of the 2020 NFL Season",
    caption = "Plot: @thomas_mock | Data: ESPN"
  )

stand_density