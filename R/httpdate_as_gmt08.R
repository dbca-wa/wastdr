#' Return a UTC HTTP date string as POSIXct object in GMT+08
#' @param datestring (character) A UTC HTTP date as character string,
#'   e.g. '2016-11-20T21:46:57.163000Z' with time zone included
#' @importFrom lubridate parse_date_time with_tz
#' @export
#' @return A POSIXct date object in GMT+08, e.g. '2016-11-21 05:46:57 AWST'
#' @examples
#' httpdate_as_gmt08("2016-11-20T21:46:57.163000Z")
httpdate_as_gmt08 <- function(datestring) {
    datestring %>%
        parse_date_time(orders = c("YmdHMSz", "adbYHMS")) %>%
        with_tz(tzone="Australia/Perth")
}
