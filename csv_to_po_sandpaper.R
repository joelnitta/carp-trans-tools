# Convert a CSV file of translations of
# [Sandpaper translation variables](https://carpentries.github.io/sandpaper/articles/translations.html#list-of-translation-variables)
# to PO

library(tidyverse)
library(fs)

source("R/functions.R")

temp_csv <- tempfile(fileext = ".csv")

# Input CSV should have one column for 'string' and one column for the
# translation of the string for the terms listed in
# https://carpentries.github.io/sandpaper/articles/translations.html#list-of-translation-variables

csv_to_convert <-
  read_csv("data/web_elements_uk.csv") %>%
  mutate(location = 1:nrow(.)) %>%
  select(location, source = string, target = ukrainian)

write_csv(csv_to_convert, temp_csv)

csv2po(
  temp_csv,
  "results/web_elements_uk.po"
)
