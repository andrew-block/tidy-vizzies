# Clear space
rm(list=ls())
gc()

library(tidyverse)
library(gtExtras)
library(gt)


# Load data:
# Pro sports vaccinations
psv <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/data/sep_2021_pro_sports_vaccinations.csv')

psv_t <- psv %>%
  mutate(Sports_Logo = Sport, .before = September_2021_Vaccination_Rate) %>%
  mutate(Sports_Logo = case_when(
    str_detect(Sports_Logo,'NHL') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_nhl.png',
    str_detect(Sports_Logo,'NFL') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_nfl.png',
    str_detect(Sports_Logo,'WNBA') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_wnba.png',
    str_detect(Sports_Logo,'NBA') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_nba.png',
    str_detect(Sports_Logo,'MLS') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_mls.png',
    str_detect(Sports_Logo,'MLB') ~ 'https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/pro_sports_vaccinations/images/logo_mlb.png'
  ))


# Make table with gt()
psv_gt <- psv_t %>%
  # Make table
  gt() %>%

  # Apply 'New York Times' theme
  gtExtras::gt_theme_nytimes() %>%

  gtExtras::gt_img_rows(columns = Sports_Logo, height = 20) %>%

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
    Sports_Logo = "  ",
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

psv_gt