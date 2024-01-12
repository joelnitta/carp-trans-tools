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
  select(source = string, target = ukrainian) %>%
  mutate(source = str_remove_all(source, "'"))

# PO template file comes from running potools::po_create() in {sandpaper}
po_template <- "data/R-uk.po"

# Convert the PO template to CSV so we can join to the translations
temp_csv_from_po <- tempfile(fileext = ".csv")

po2csv(
  po_template,
  temp_csv_from_po
)

# Join the translations, write out as CSV
po_template_df <- read_csv(temp_csv_from_po)

csv_with_trans <-
  po_template_df %>%
  select(-target) %>%
  left_join(csv_to_convert, by = "source")

write_csv(csv_with_trans, temp_csv)

# Convert the joined translations to PO
csv2po(
  temp_csv,
  "results/web_elements_uk.po"
)
