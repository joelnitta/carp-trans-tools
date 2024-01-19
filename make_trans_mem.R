# Make a translation memory file from a set of PO files

# Transifex doesn't allow exporting translation memory without a paid account.
# So do it here using PO files that we can download from a standard project.

library(tidyverse)
library(fs)

source("R/functions.R")

# Set up file paths
# - original PO files (each downloaded from a single Transifex PO file)
fs::dir_create("data/po")
po_orig <- dir_ls("data/po")
# - segmented PO files (to write)
po_seg <- path_file(po_orig) %>%
  path("data/po_segmented", .)
# - CSV files converted from segmented PO files (to write)
csv_files <- path_file(po_seg) %>%
  path("data/csv", .) %>%
  path_ext_set(".csv")

# Segment PO files
fs::dir_create("data/po_segmented")
walk2(po_orig, po_seg, segment_po)

# Convert segmented PO files to CSV files
fs::dir_create("data/csv")
walk2(po_seg, csv_files, po2csv)

# Combine CSV files and clean text
csv_combined <- csv_files %>%
  map_df(read_csv) %>%
  select(source, target) %>%
  unique() %>%
  mutate(
    source = clean_lines(source),
    target = clean_lines(target)
  )

# This is the final CSV file to use as translation memory
fs::dir_create("results")
write_csv(csv_combined, "results/combined.csv")
