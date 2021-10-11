# Clear space
rm(list=ls())
gc()

library(tidyverse)
library(gtExtras)
library(gt)


# Load data:
# Pro sports vaccinations
psv <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/fcs_power_rankings/data/fcs_rankings_week_7.csv')

# Make table with gt()
psv_gt <- psv %>%
  # Make table
  gt() %>%

  # Apply 'New York Times' theme
  gtExtras::gt_theme_538() %>%

  gtExtras::gt_img_rows(columns = Logo, height = 20) %>%

  # Add title and subtitle
  tab_header(
    title = "FCS Meta Power Ranking",
    # Use markdown syntax with md()
    subtitle = md("Week **7**")
  ) %>%
  tab_footnote(
    footnote = "SOS = Strength of Schedule",
    locations = cells_column_labels(
      columns = SOS
    )
  ) %>%
  tab_options(
    column_labels.font.weight = "bold"
  )

psv_gt