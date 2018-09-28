#' Calculate the "turtle season" (FY) from a given datetime
#'
#' @details Return the earliest year of the season start.
#'
#'
#' In practice, the turtle date is the date component (year, month, day) of the
#' datetime minus 12 hours.
#'
#' This date convention is widely used in the turtle research community.
#' @param datestring (character) A UTC HTTP date as character string,
#'   e.g. '2016-11-20T21:46:57.163000Z' with time zone included
#' @return A POSIXct date
#' @importFrom lubridate hours as_date
#' @import magrittr
#' @export
#' @examples
#' # These datetimes are turtle season 2017:
#' httpdate_as_season("2017-06-30T15:59:59Z") == 2016
#' httpdate_as_season("2017-06-30T16:00:00Z") == 2017
httpdate_as_season <- function(datestring) {
  datestring %>%
    httpdate_as_gmt08() %>%
    -months(6) %>%
    lubridate::year()
}
