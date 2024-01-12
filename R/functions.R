
#' Segment a PO file
#'
#' Splits up a PO file into finer segments. This generally improves performance
#' of translation memory. Uses the
#' [posegment](http://docs.translatehouse.org/projects/translate-toolkit/en/latest/commands/posegment.html)
#' tool from the Translate Toolkit.
#'
#' Requires docker to be installed and running.
#'
#' @param po_file Path to input PO file.
#' @param po_file_seg Path to write segmented PO file
#' @param other_args Vector of additional arguments to pass to `posegment`.
#'   For details on how to format this, see `babelwhale::run()`.
#'
#' @return Path to the segmented PO file
segment_po <- function(po_file, po_file_seg, other_args = NULL) {
  babelwhale::run_auto_mount(
  "joelnitta/translation-tools:latest",
  "posegment",
  args = c(
    file = po_file,
    file = po_file_seg,
    other_args
  )
  )
  po_file_seg
}


#' Convert a PO file to a CSV file
#'
#' Uses the
#' [po2csv](http://docs.translatehouse.org/projects/translate-toolkit/en/latest/commands/csv2po.html)
#' tool from the Translate Toolkit.
#'
#' @param po_file Path to input PO file.
#' @param csv_file Path to write converted CSV file.
#' @param other_args Vector of additional arguments to pass to `po2csv`.
#'   For details on how to format this, see `babelwhale::run()`.
#'
#' @return Path to the converted CSV file.
po2csv <- function(po_file, csv_file, other_args = NULL) {
  babelwhale::run_auto_mount(
  "joelnitta/translation-tools:latest",
  "po2csv",
  args = c(
    file = po_file,
    file = csv_file,
    other_args
  )
  )
  csv_file
}


#' Clean up text
#'
#' Particularly meant for removing formatting in text that has been converted
#' from PO to CSV, starting from old-style Carpentries lessons.
#'
#' @param source Original string.
#'
#' @return Cleaned string
clean_lines <- function(source) {
  source |>
    stringr::str_replace_all(">", " ") |>
    stringr::str_replace_all(stringr::fixed("\n"), " ") |>
    stringr::str_replace_all(stringr::fixed("*"), " ") |>
    stringr::str_squish() |>
    stringr::str_remove_all("^#+ ")
}