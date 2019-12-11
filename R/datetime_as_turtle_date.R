#' Calculate the "turtle date" from a given datetime
#'
#' @details Return the actual date for afternoon and evening datetimes
#' (noon to midnight) or the date of the previous day for morning datetimes
#' (midnight to noon).
#' The turtle date keeps observations made between sunset and sunrise,
#' as well as the "morning after" together by assigning the date of the start
#' of observations.
#'
#' In practice, the turtle date is the date component (year, month, day) of the
#' datetime minus 12 hours.
#'
#' This date convention is widely used in the turtle research community.
#' @param datetime (dttm) A datetime
#' @return A POSIXct date
#' @importFrom lubridate hours as_date
#' @import magrittr
#' @export
#' @examples
#' # noon AWST is turtle date "2016-11-20":
#' datetime_as_turtle_date(
#'   httpdate_as_gmt08("2016-11-20T04:00:00Z")
#' )
#'
#' # 1 sec before noon AWST is turtle date "2016-11-19":
#' datetime_as_turtle_date(
#'   httpdate_as_gmt08_turtle_date("2016-11-21T03:59:59Z")
#' )
datetime_as_turtle_date <- function(datetime) {
  datetime %>%
    -lubridate::hours(12) %>%
    lubridate::as_date()
}
