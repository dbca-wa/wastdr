#' Calculate the "turtle season" (FY) from a given datetime
#'
#' \lifecycle{stable}
#'
#' @details Return the start year of the fiscal year of a given date.
#'
#' The "turtle season" is calculated as the calendar year 180 days prior to
#' the given date.
#'
#' Note the fiscal year is often labelled as the end year of the FY,
#' so that FY 2020 referes to FY 2019-20.
#' We use the start year (e.g. 2019 for a date in July-Dec 2019), as most
#' turtle monitoring is done in the first half of the FY, where the
#' "turtle season" year is equal to the calendar year.
#'
#' @param datetime (dttm) A datetime
#' @return The season as int, e.g. 2017
#' @importFrom lubridate days isoyear
#' @export
#' @family helpers
#' @examples
#' # These datetimes are turtle season 2017:
#' datetime_as_season(httpdate_as_gmt08("2017-06-30T15:59:59Z")) # 2016
#' datetime_as_season(httpdate_as_gmt08("2017-06-30T16:00:00Z")) # 2017
#' datetime_as_season(httpdate_as_gmt08("2017-08-30T06:38:43Z")) # 2017
datetime_as_season <- function(datetime) {
  datetime %>%
    -lubridate::days(180) %>%
    lubridate::isoyear()
}

# usethis::use_test("datetime_as_season")
