# Clear space
rm(list=ls())
gc()

library(tidyverse)
library(gtExtras)
library(gt)

# function to incorporate player name + conference
combine_word <- function(name, conference){
  glue::glue(
    "<div style='line-height:10px'><span style='font-weight:bold;font-variant:small-caps;font-size:14px'>{name}</div>
    <div style='line-height:12px'><span style ='font-weight:bold;color:grey;font-size:10px'>{conference}</span></div>"
  )
}

# Load fcs data
fcs <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/fcs_power_rankings/data/fcs_rankings_week_7.csv')

fcs_t <- fcs %>%
  select(team,logo,conference,record,macro_ranking,change,dr_index,cfp_index,vs_index,sos) %>%
  mutate(
    combo = combine_word(team, conference),
    combo = map(combo, gt::html)
  ) %>%
  select(combo, logo, record, macro_ranking,
         dr_index, cfp_index, vs_index,change, sos) %>%
  # Make table
  gt() %>%

  # Apply 'New York Times' theme
  gtExtras::gt_theme_538() %>%

  gtExtras::gt_img_rows(columns = logo, height = 20) %>%

  # Add title and subtitle
  tab_header(
    title = "FCS Meta Power Ranking",
    # Use markdown syntax with md()
    subtitle = md("Week **7**")
  ) %>%
  tab_footnote(
    footnote = "SOS = Strength of Schedule",
    locations = cells_column_labels(
      columns = sos)
    ) %>%
  tab_footnote(
    footnote = "DRating",
    locations = cells_column_labels(
      columns = dr_index)
  ) %>%
  tab_footnote(
    footnote = "College Football Poll",
    locations = cells_column_labels(
      columns = cfp_index)
  ) %>%
  tab_footnote(
    footnote = "Versus Sports Simulator",
    locations = cells_column_labels(
      columns = vs_index)
  ) %>%
  cols_align(
    align = "left",
    columns = vars(combo)
  ) %>%
  tab_options(
    data_row.padding = px(5)
  ) %>%
  cols_label(
    logo = "  ",
    combo = "Team",
    dr_index = "DR",
    cfp_index = "CFP",
    vs_index = "VS",
    macro_ranking = "Rank"
  ) %>%
  data_color(
    columns = vars(change),
    colors = scales::col_numeric(
      palette = c("red", "green"),
      domain = NULL
    )
  ) %>%
  tab_source_note(
    source_note = "Meta ranking aggregated using several different websites (Rank Sources)"
  ) %>%
  tab_spanner(
    label = "Rank Sources",
    columns = c(
      dr_index, cfp_index, vs_index)
  )
fcs_t