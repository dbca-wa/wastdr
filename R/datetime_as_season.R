#' Calculate the "turtle season" (FY) from a given datetime
#'
#' \lifecycle{stable}
#'
#' @details Return the earliest year of the season start.
#'
#' In practice, the turtle date is the date component (year, month, day) of the
#' datetime minus 12 hours.
#'
#' @param datetime (dttm) A datetime
#' @return The season as int, e.g. 2017
#' @importFrom lubridate days isoyear
#' @import magrittr
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
