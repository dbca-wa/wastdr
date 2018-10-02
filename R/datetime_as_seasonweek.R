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
#' datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T15:59:59Z")) # 0
#' datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T16:00:00Z")) # 1
#' datetime_as_seasonweek(httpdate_as_gmt08("2017-08-30T06:38:43Z")) # 9
#' datetime_as_seasonweek(httpdate_as_gmt08("2017-11-01T22:00:00Z")) # 18
#' datetime_as_seasonweek(httpdate_as_gmt08("2018-11-01T22:00:00Z")) # 18
datetime_as_seasonweek <- function(datetime) {
     (lubridate::isoweek(datetime) + 26) %% 52
}
