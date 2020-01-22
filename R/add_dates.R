#' Add turtle dates to a dataframe with datetime col `observation_start_time`.
#'
#' @param data a dataframe with datetime col `observation_start_time`, e.g. the
#' output of ODKC form "turtle track or nest", "predator or disturbance", or
#' "marine wildlife incident".
#'
#' @return The initial dataframe plus new columns
#'
#'   * calendar_date_awst
#'   * turtle_date
#'   * season
#'   * season_week
#'   * iso_week
#' @export
add_dates <- function(data){
    data %>%
        dplyr::mutate(
            datetime = observation_start_time %>%
                lubridate::with_tz("Australia/Perth"),
            calendar_date_awst = datetime %>%
                lubridate::floor_date(unit = "day") %>%
                as.character(),
            turtle_date = datetime %>% datetime_as_turtle_date(),
            season = datetime %>% datetime_as_season(),
            season_week = datetime %>% datetime_as_seasonweek(),
            iso_week = datetime %>% datetime_as_isoweek()
        )
}

#' Add turtle dates to a dataframe with datetime col `survey_start_time`.
#'
#' @param data a dataframe with datetime col `survey_start_time`, e.g. the
#' output of ODKC form "site visit start".
#'
#' @return The initial dataframe plus new columns
#'
#'   * calendar_date_awst
#'   * turtle_date
#'   * season
#'   * season_week
#'   * iso_week
#' @export
add_dates_svs <- function(data){
    survey_start_time <- NULL
    datetime <- NULL
    data %>%
        dplyr::mutate(
            datetime = survey_start_time %>%
                lubridate::with_tz("Australia/Perth"),
            calendar_date_awst = datetime %>%
                lubridate::floor_date(unit = "day") %>%
                as.character(),
            turtle_date = datetime %>% datetime_as_turtle_date(),
            season = datetime %>% datetime_as_season(),
            season_week = datetime %>% datetime_as_seasonweek(),
            iso_week = datetime %>% datetime_as_isoweek()
        )
}

#' Add turtle dates to a dataframe with datetime col `survey_end_time`.
#'
#' @param data a dataframe with datetime col `survey_end_time`, e.g. the
#' output of ODKC form "site visit end".
#'
#' @return The initial dataframe plus new columns
#'
#'   * calendar_date_awst
#'   * turtle_date
#'   * season
#'   * season_week
#'   * iso_week
#' @export
add_dates_sve <- function(data){
    survey_end_time <- NULL
    datetime <- NULL
    data %>%
        dplyr::mutate(
            datetime = survey_end_time %>%
                lubridate::with_tz("Australia/Perth"),
            calendar_date_awst = datetime %>%
                lubridate::floor_date(unit = "day") %>%
                as.character(),
            turtle_date = datetime %>% datetime_as_turtle_date(),
            season = datetime %>% datetime_as_season(),
            season_week = datetime %>% datetime_as_seasonweek(),
            iso_week = datetime %>% datetime_as_isoweek()
        )
}


