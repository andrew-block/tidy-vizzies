library(tidyverse)

url_data <- "https://www.espn.com/nfl/standings/_/group/league"
table <- url_data %>%
  read_html() %>%
  html_table()
teams <- table[[1]]
data <- table[[2]]
data["TEAM"] <- teams

# clean data
nfl = data %>%
  select(TEAM, W, L, T, PCT, HOME, AWAY, DIV, CONF, PF, PA, DIFF, STRK)
nfl