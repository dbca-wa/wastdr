#' True date as days since fiscal year start
#'
#' @param x A date
#' @importFrom lubridate %--%
#' @export
#' @family helpers
tdate_as_fdate <- function(x) {
  x %>%
    {
      lubridate::as.duration(
        as_date(
          glue::glue("{wastdr::datetime_as_season(.)}-07-01")
        ) %--% .
      )
    } %>%
    as.numeric("days")
}

# usethis::use_test("tdate_as_fdate")
