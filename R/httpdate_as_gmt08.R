#' Return a UTC HTTP date string as POSIXct object in GMT+08
#'
#' #' \lifecycle{stable}
#'
#' @param datestring (character) A UTC HTTP date as character string,
#'   e.g. '2016-11-20T21:46:57.163000Z' with time zone included
#' @return A POSIXct date object in GMT+08, e.g. '2016-11-21 05:46:57 AWST'
#' @export
#' @family helpers
#' @examples
#' httpdate_as_gmt08("2016-11-20T21:46:57.163000Z")
httpdate_as_gmt08 <- function(datestring) {
  datestring %>%
    lubridate::parse_date_time(orders = c("YmdHMSz", "adbYHMS")) %>%
    lubridate::with_tz(tzone = "Australia/Perth")
}

# usethis::use_test("datetime_as_turtle_date")
