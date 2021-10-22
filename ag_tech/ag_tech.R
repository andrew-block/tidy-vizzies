library(tidyverse)
library(gtExtras)
library(gt)
library(dplyr)
library(ggridges)
library(ggthemes)
library(ggtext)
library(stringr)

ag <- readr::read_csv('https://raw.githubusercontent.com/andrew-block/tidy-vizzies/main/ag_tech/data/ag_tech_2021.csv')

ag$Location <- str_c(ag$City, ', ', ag$State)

stack_word <- function(word_1, word_2){
  glue::glue(
    "<div style='line-height:10px'><span style='font-weight:bold;font-variant:small-caps;font-size:14px'>{word_1}</div>
    <div style='line-height:12px'><span style ='font-weight:bold;color:grey;font-size:10px'>{word_2}</span></div>"
  )
}

agt <- ag %>%
  arrange(desc(Last_Funding_Amount)) %>%
  mutate(
    Organization = stack_word(Company, Location),
    Organization = map(Organization, gt::html)
  ) %>%
  select(Organization, Logo, Total_Employees, Funding_Rounds,
         Last_Funding_Date, Last_Funding_Amount, Last_Funding_Type) %>%
  gt() %>%
  gtExtras::gt_theme_nytimes() %>%
  gtExtras::gt_img_rows(columns = Logo, height = 20) %>%
  tab_header(
    title = "AgTech Leaders",
    # Use markdown syntax with md()
    subtitle = md("2021")
  ) %>%
  cols_label(
    Organization = "Company",
    Logo = "",
    Total_Employees = "Employees",
    Funding_Rounds = "Rounds",
    Last_Funding_Date = "Last Round",
    Last_Funding_Amount = "Last Amount",
    Last_Funding_Type = "Last Type"
  ) %>%
  cols_width(
    vars(Organization) ~ px(20),
    vars(Logo) ~ px(6),
    vars(Total_Employees) ~ px(13),
    vars(Funding_Rounds) ~ px(6),
    vars(Last_Funding_Date) ~ px(13),
    vars(Last_Funding_Amount) ~ px(14),
    vars(Last_Funding_Type) ~ px(17),
  ) %>%
  tab_options(
    table.width = px(850),
    data_row.padding = px(4)
  ) %>%
  cols_align(
    align = "center",
    columns = c(Funding_Rounds)
  ) %>%
  cols_align(
    align = "right",
    columns = c(Last_Funding_Date)
  ) %>%
  cols_align(
    align = "left",
    columns = c(Organization)
  ) %>%
  tab_options(
    heading.title.font.size = px(40),
    heading.title.font.weight = "bolder",
    heading.align = "left",
    heading.subtitle.font.size =  px(20),
    footnotes.font.size = px(12)
  )
agt

h <- ggplot(data.frame(funding = ag$Total_Funding_Amount), aes(x = funding)) +
  geom_histogram(color = "black", fill = "#1FA187") +
  labs(title = "Total Funding by Top AgTech Companies",
       x =  NULL) +
  theme_minimal() +
  scale_x_continuous(labels= label_number(scale = 1e-6, prefix = "$", suffix = "M", accuracy = 6))