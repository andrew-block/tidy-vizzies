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
  select(combo, logo, record, macro_ranking, change, dr_index, cfp_index, vs_index, sos) %>%
  # Make table
  gt() %>%

  # Apply 'New York Times' theme
  gtExtras::gt_theme_538() %>%

  gtExtras::gt_img_rows(columns = logo, height = 20) %>%

  # Add title and subtitle
  tab_header(
    title = "FCS Meta Power Ranking",
    # Use markdown syntax with md()
    subtitle = md("Week 7")
  ) %>%
  tab_footnote(
    footnote = "Strength of Schedule",
    locations = cells_column_labels(
      columns = sos)
  ) %>%
  cols_align(
    align = "left",
    columns = c(combo)
  ) %>%
  tab_options(
    data_row.padding = px(5),
    heading.title.font.size = px(40),
    heading.title.font.weight = "bolder",
    heading.subtitle.font.size =  px(20),
    footnotes.font.size = px(12)
  ) %>%
  cols_label(
    logo = "  ",
    combo = "Team",
    dr_index = "DR",
    cfp_index = "CFP",
    vs_index = "VS",
    macro_ranking = "Rank"
  ) %>%
  text_transform(
    locations = cells_body(columns = change),
    fn = function(x){

      change <- as.integer(x)

      choose_logo <-function(x){
        if (x == 0){
          gt::html(fontawesome::fa("equals", fill = "#696969"))
        } else if (x > 0){
          gt::html(glue::glue("<span style='color:#191970;font-face:bold;font-size:10px;'>{x}</span>"), fontawesome::fa("arrow-up", fill = "#1134A6"))
        } else if (x < 0) {
          gt::html(glue::glue("<span style='color:#DA2A2A;font-face:bold;font-size:10px;'>{x}</span>"), fontawesome::fa("arrow-down", fill = "#DA2A2A"))
        }
      }

      map(change, choose_logo)

    }
  ) %>%
  gt_highlight_rows(rows = macro_ranking == 1, fill = "yellow", alpha = 0.25) %>%
  tab_spanner(
    label = "Rank Sources",
    columns = c(
      dr_index, cfp_index, vs_index)
  ) %>%
  tab_source_note(
    source_note = html(
      htmltools::tags$a(
        href = "https://www.versussportssimulator.com/FCS/rankings",
        target = "_blank",
        "Versus Sports Simulator"
      ) %>%
        as.character()
    )) %>%
  tab_source_note(
    source_note = html(
      htmltools::tags$a(
        href = "https://www.collegefootballpoll.com/fcs/rankings/",
        target = "_blank",
        "College Football Poll"
      ) %>%
        as.character()
    )) %>%
  tab_source_note(
    source_note = html(
      htmltools::tags$a(
        href = "https://www.dratings.com/sports/ncaa-fcs-football-ratings/",
        target = "_blank",
        "DRatings"
      ) %>%
        as.character()
    )) %>%
  fmt_number(
    columns = vars(dr_index),
    decimals = 2
  ) %>%
  cols_align(
    align = "center",
    columns = c(record, macro_ranking, change, dr_index, cfp_index, vs_index, sos)
  ) %>%
  data_color(
    columns = sos,
    colors = scales::col_numeric(
      c("#084081", "#0868ac", "#2b8cbe",
        "#4eb3d3", "#7bccc4", "#a8ddb5",
        "#ccebc5", "#e0f3db", "#f7fcf0"),
      domain = NULL
    )
    )
  fcs_t