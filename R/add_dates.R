#' Add turtle dates to a dataframe with datetime col `observation_start_time`.
#'
#' \lifecycle{stable}
#'
#' @param data a dataframe with datetime col `observation_start_time`, e.g. the
#' output of ODKC form "turtle track or nest", "predator or disturbance", or
#' "marine wildlife incident". If the date_col is plain text, it will be turned
#' into a tz-aware datetime, else it is expected to be POSIXct / POSIXt.
#' @param date_col (chr) The column name of the datetime to annotate.
#'   Default: \code{"observation_start_time"}.
#' @param parse_date (lgl) Whether the date_col needs to be parsed from character
#'   into a date format (TRUE, default) or already comes as a POSIXct/POSIXt.
#' @return The initial dataframe plus new columns
#' \itemize{
#'   \item calendar_date_awst (chr) The calendar date in GMT+08 (AWST)
#'   \item turtle_date (POSIXct) The turtle date,
#'     see \code{\link{datetime_as_turtle_date}}.
#'   \item season (int) The season, see \code{\link{datetime_as_season}}.
#'   \item season_week (int) The season week,
#'     see \code{\link{datetime_as_seasonweek}}.
#'   \item iso_week (int) The season week,
#'     see \code{\link{datetime_as_isoweek}}.
#' }
#' @family helpers
#' @export
add_dates <-
  function(data,
           date_col = "observation_start_time",
           parse_date = TRUE) {
    data %>%
      {
        if (parse_date == TRUE) {
          dplyr::mutate(
            .,
            datetime = !!rlang::sym(date_col) %>%
              httpdate_as_gmt08() %>%
              lubridate::with_tz("Australia/Perth")
          )
        } else {
          dplyr::mutate(., datetime = !!rlang::sym(date_col))
        }
      } %>%
      dplyr::mutate(
        calendar_date_awst = datetime %>%
          lubridate::floor_date(unit = "day") %>%
          as.character(),
        turtle_date = datetime %>% datetime_as_turtle_date(),
        season = datetime %>% datetime_as_season(),
        season_week = datetime %>% datetime_as_seasonweek(),
        iso_week = datetime %>% datetime_as_isoweek()
      )
  }
