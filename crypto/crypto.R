library(tidyverse)
library(ggridges)
library(lubridate)
library(scales)

btc_daily_raw <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/crypto/data/gemini_BTCUSD_day.csv')

btc_daily <- btc_daily_raw[order(btc_daily_raw$Symbol, btc_daily_raw$Unix),]
btc_daily$Year <- format(btc_daily$Date, format="%Y")

btc_daily <-
  btc_daily %>%
    group_by(Symbol) %>%
    mutate(
      Daily_Change = (Close - lag(Close)),
      Yesterday = lag(Close),
      Daily_Percent_Change = Daily_Change/Yesterday
    )

btc_monthly <- filter(btc_daily, mday(Date)== 1 & year(Date) >= 2016) %>%
  mutate(
    Monthly_Change = (Close - lag(Close)),
    Monthly_Percent_Change = Monthly_Change/Yesterday,
    Value = case_when(Monthly_Change>=0 ~ "Positive", Monthly_Change<0 ~ "Negative")
  )
ggplot(btc_monthly, aes(x = Monthly_Percent_Change, y = Year, fill = stat(x), point_shape = Value, point_color = Value)) +
  geom_density_ridges_gradient(
    scale = 2.5, rel_min_height = 0.01, jittered_points = TRUE,
    alpha = 0.7, point_size = 1, point_alpha = 1) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, .1)) +
  scale_x_continuous(labels = scales::percent) +
  scale_fill_viridis_c(labels = scales::percent_format(), option = "B") +
  xlab('Monthly Price Movement') +
  labs(fill = "% Change") +
  coord_cartesian(clip = "off") +
  labs(title = 'Bitcoin (BTC) Monthly Price Change 2016 - 2021')