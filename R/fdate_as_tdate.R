#' Days since fiscal year start as true date
#'
#' \lifecycle{stable}
#'
#' @param value A date
#' @export
#' @family helpers
#' @examples
#' fdate_as_tdate(0) # "01 Jul"
#' fdate_as_tdate(1) # "02 Jul"
#' fdate_as_tdate(55) # "25 Aug"
#' fdate_as_tdate(365) # "01 Jul"
fdate_as_tdate <- . %>%
  {
    lubridate::ddays(.) + lubridate::as_date("2000-07-01")
  } %>%
  format("%d %b")

# usethis::use_test("fdate_as_tdate")
