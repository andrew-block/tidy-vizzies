library(gt)
library(gtExtras)
library(tidyverse)

df_tt <- tidytuesdayR::tt_load(2021, "39")

min_data <- df_tt$nominees %>%
  distinct(page, page_id, .keep_all = TRUE)

stream_data <- min_data %>%
  filter(
    year >= 2020,
    distributor %in% c("HBO", "CBS", "NBC", "FX Networks", "ABC","Netflix",
                       "Hulu", "Apple TV+", "Prime Video")
  ) %>%
  count(distributor, type, sort = TRUE) %>%
  pivot_wider(names_from = "type", values_from = "n") %>%
  mutate(Winner = replace_na(Winner, 0)) %>%
  mutate(type = case_when(
    distributor %in% c("Netflix", "Hulu", "Apple TV+", "Prime Video") ~ "wifi",
    distributor %in% c("HBO", "FX Networks", "AMC", "Showtime", "Comedy Central") ~ "video",
    TRUE ~ "tv"
  ),
         .after = distributor
  ) %>%
  mutate(Ratio = Winner/Nominee, .after = type)

stream_table <- stream_data %>%
  gt() %>%
  gt_plt_bullet(column = Nominee, target = Winner,
                color = "#ffb200", target_color = "#00008B") %>%
  gt_fa_column(column = type) %>%
  gt_theme_nytimes() %>%
  fmt_symbol_first(column = Ratio, suffix = "%", decimals = 1, scale_by = 100) %>%
  cols_label(
    Nominee = html(
      "<span style='color:#ffb200;'>Nominations</span> vs <span style='color:#00008B;'>Wins</span>"
    )
  ) %>%
  tab_header(
    title = "Netflix leads Emmy Nominations & Wins: 2020-2021",
    subtitle = md("but **HBO** leads in their Wins to Nominations ratio")
  ) %>%
  gt_highlight_rows(rows = distributor == "HBO", fill = "grey", alpha = 0.4) %>%
  gt_add_divider(type, color = "lightgrey", weight = px(1)) %>%
  tab_source_note(md("**Table**: @thomas_mock | **Data**: Emmys.com")) %>%
  tab_options(
    table.border.bottom.color = "white",
    table.width = px(410)
  )

stream_table