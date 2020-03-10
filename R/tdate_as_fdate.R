#' True date as days since fiscal year start
#'
#' @param value A date
#' @importFrom lubridate %--%
#' @export
tdate_as_fdate <- . %>%
  {
    lubridate::as.duration(
      as_date(
        glue::glue("{wastdr::datetime_as_season(.)}-07-01")
      ) %--% .
    )
  } %>%
  as.numeric("days")
