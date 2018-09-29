#' Calculate the isoweek from a given datetime
#'
#' @details Return the isoweek of a given datetime.
#'
#' The isoweek is useful as a grouping variable for weekly summaries.
#'
#' @param datetime (dttm) A datetime
#' @return The ISO week as int, e.g. 26
#' @importFrom lubridate days isoweek
#' @import magrittr
#' @export
#' @examples
#' # These datetimes are turtle season 2017:
#' datetime_as_isoweek(httpdate_as_gmt08("2017-06-30T15:59:59Z")) # 26
#' datetime_as_isoweek(httpdate_as_gmt08("2017-06-30T16:00:00Z")) # 26
#' datetime_as_isoweek(httpdate_as_gmt08("2017-08-30T06:38:43Z")) # 35
#' datetime_as_isoweek(httpdate_as_gmt08("2017-11-01T22:00:00Z")) # 44
#' datetime_as_isoweek(httpdate_as_gmt08("2018-11-01T22:00:00Z")) # 44
datetime_as_isoweek <- function(datetime) {
  datetime %>% lubridate::isoweek()
}
