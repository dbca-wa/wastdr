#' Turtle Nesting Census data from ODK Centrail
#' First 6 records of each dataset, all sites.
#' @family included
"odkc_data"

#' Turtle Nesting Census data from WAStD
#'
#' The output of \code{\link{download_wastd_turtledata}}, but
#' observer and reporter names are hidden, tibbles are filtered down to the
#' first 100 records, however all areas and sites are included.
#' @family included
"wastd_data"

#' WAStD AnimalEncounters, unparsed, test data captured by author
#' @family included
"wastd_ae_raw"

#' WAStD AnimalEncounters, parsed, test data captured by author
#' @family included
"wastd_ae"

#' WAStD TurtleNestEncounters, unparsed, test data captured by author
#' @family included
"wastd_tne_raw"

#' WAStD TurtleNestEncounters, parsed, test data captured by author
#' @family included
"wastd_tne"

#' WAStD Areas, unparsed
#' @family included
"wastd_area_raw"

#' WAStD Surveys, unparsed, test data captured by author
#' @family included
"wastd_surveys_raw"

#' TSC data, parsed, first ten records each
#' @family included
"tsc_data"

# usethis::use_test("data")
