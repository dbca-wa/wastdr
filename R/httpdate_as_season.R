#' Calculate the "turtle season" (FY) from a given UTC HTTP datestring
#'
#' @details Return the earliest year of the season start.
#' E.g. any date in the fiscal year 2017/18 will be season 2017.
#' Care has to be taken to calculate the offset through days rather than months,
#' which can result in invalid dates such as Feb 30 or June 31.
#'
#' @param datestring (character) A UTC HTTP date as character string,
#'   e.g. '2016-11-20T21:46:57.163000Z' with time zone included
#' @return The season as int, e.g. 2017
#' @importFrom lubridate days isoyear
#' @import magrittr
#' @export
#' @family helpers
#' @examples
#' # These datetimes are turtle season 2017:
#' httpdate_as_season("2017-06-30T15:59:59Z") # 2016
#' httpdate_as_season("2017-06-30T16:00:00Z") # 2017
#' httpdate_as_season("2017-08-30T06:38:43Z") # 2017
httpdate_as_season <- function(datestring) {
  datestring %>%
    httpdate_as_gmt08() %>%
    -lubridate::days(180) %>%
    lubridate::isoyear()
}

# usethis::use_test("httpdate_as_season")
