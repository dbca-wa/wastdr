#' Turtle Nesting Census data from ODK Central.
#'
#' This dataset contains the truncated output from
#' \code{\link{download_odkc_turtledata_2020}}.
#' All WAStD sites and areas are included, while all other tables are truncated
#' with \code{head()}.
#' @family included
"odkc_data"

#' Turtle Nesting Census data from WAStD
#'
#' This dataset contains the truncated output from
#' \code{\link{download_wastd_turtledata}}.
#' Names of observer and reporter are hidden.
#' All WAStD sites and areas are included, while all other tables are truncated
#' with \code{head()}.
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
