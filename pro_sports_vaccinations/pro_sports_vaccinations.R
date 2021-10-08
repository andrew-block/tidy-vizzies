# Clear space 
rm(list=ls())
gc()

library(tidyverse)
# Load data: 
# Pro sports vaccinations
psv <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/data/sep_2021_pro_sports_vaccinations.csv')

# Load {gt}
library(gt)

# Make table with gt()
psv_t<-psv %>%
  # Make table
  gt()

# Load extension
library(gtExtras)
# Apply 'New York Times' theme
psv_t<-psv_t%>%
  gtExtras::gt_theme_nytimes()

psv_t

psv_t<-psv_t %>%
  # Add title and subtitle
  tab_header(
    title = "US Professonal Sports Vaccination Rates",
    # Use markdown syntax with md()
    subtitle = md("September **2021**")
  ) %>%
  # Rename column
  cols_label(
    September_2021_Vaccination_Rate = "Vaccination Rate",
    Unvaccinated_Players = "Unvaccinated Players",
    Unvaccinated_Players_Team = "Unvaccinated PPT"
  ) %>%
  tab_footnote(
    footnote = "PPT = Players Per Team",
    locations = cells_column_labels(
      columns = Unvaccinated_Players_Team
    )
  ) %>%
  data_color(
    columns = September_2021_Vaccination_Rate,
    colors = scales::col_numeric(
      palette = c(
        "red", "orange", "green"),
      domain = c(0.85, 1))
  ) %>%
  # Fomat date without year information
  fmt_percent(
    columns = September_2021_Vaccination_Rate,
    decimals = 0
  ) %>%
  tab_options(
    column_labels.font.weight = "bold"
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = "black"),
      cell_text(color = "white")
    ),
    locations = cells_column_labels(columns = everything())
  )

psv_t