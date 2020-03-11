#' Calculate the "turtle date" from a given datetime
#'
#' \lifecycle{stable}
#'
#' @details Return the actual date for afternoon and evening datetimes
#' (noon to midnight) or the date of the previous day for morning datetimes
#' (midnight to noon).
#' The turtle date keeps observations made between sunset and sunrise,
#' as well as on the "morning after" together by assigning the date of the start
#' of observations.
#'
#' In practice, the turtle date is the date component (year, month, day) of the
#' datetime minus 12 hours.
#'
#' This date convention is widely used in the turtle research community.
#' @param datestring (character) A UTC HTTP date as character string,
#'   e.g. '2016-11-20T21:46:57.163000Z' with time zone included
#' @return A POSIXct date
#' @export
#' @family helpers
#' @examples
#' # These datetimes are turtle date 2016-11-20:
#' httpdate_as_gmt08_turtle_date("2016-11-20T04:00:00Z") # noon AWST
#' httpdate_as_gmt08_turtle_date("2016-11-21T03:59:59Z") # noon AWST - 1 sec
httpdate_as_gmt08_turtle_date <- function(datestring) {
  datestring %>%
    httpdate_as_gmt08() %>%
    -lubridate::hours(12) %>%
    lubridate::as_date()
}

# usethis::use_test("httpdate_as_gmt08_turtle_date")
