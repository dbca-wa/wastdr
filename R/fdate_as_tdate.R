#' Days since fiscal year start as true date
#'
#' @param value A date
#' @export
fdate_as_tdate <- . %>%
  {
    ddays(.) + lubridate::as_date("2000-07-01")
  } %>%
  format("%d %b")
