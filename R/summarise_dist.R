#' Filter disturbance data to disturbances
#'
#' @param data A dataframe with column "disturbance_cause".
#'
#' @return The dataframe with rows matching disturbance causes.
#' @export
filter_disturbance <- function(data) {
  data %>%
    dplyr::filter(
      disturbance_cause %in% c(
        "human",
        "unknown",
        "tide",
        "turtle",
        "other",
        "vehicle",
        "cyclone"
      )
    )
}

#' Filter disturbance data to disturbances for ODKC data
#'
#' @param data A dataframe with column "disturbance_cause".
#'
#' @return The dataframe with rows matching disturbance causes.
#' @export
#' @family odkc
filter_disturbance_odkc <- function(data) {
  data %>%
    dplyr::filter(
      disturbanceobservation_disturbance_cause %in% c(
        "human",
        "unknown",
        "tide",
        "turtle",
        "other",
        "vehicle",
        "cyclone"
      )
    )
}

#' Filter disturbance data to predator presences
#'
#' @param data A dataframe with column "disturbance_cause".
#'
#' @return The dataframe with rows matching predator presences.
#' @export
filter_predation <-
  function(data) {
    data %>%
      dplyr::filter(
        disturbance_cause %in% c(
          "bandicoot",
          "bird",
          "cat",
          "crab",
          "croc",
          "dingo",
          "dog",
          "fox",
          "goanna",
          "pig"
        )
      )
  }

#' Filter disturbance data to predator presences for ODKC data
#'
#' @param data A dataframe with column "disturbance_cause".
#'
#' @return The dataframe with rows matching predator presences.
#' @export
#' @family odkc
filter_predation_odkc <-
  function(data) {
    data %>%
      dplyr::filter(
        disturbanceobservation_disturbance_cause %in% c(
          "bandicoot",
          "bird",
          "cat",
          "crab",
          "croc",
          "dingo",
          "dog",
          "fox",
          "goanna",
          "pig"
        )
      )
  }


#' Summarise disturbance by season and cause
#'
#' @param value The ouput of \code{wastd_GET("disturbance-observations") %>%
#'   parse_disturbance_observations()}
#' @export
disturbance_by_season <- . %>%
  dplyr::group_by(season, disturbance_cause) %>%
  dplyr::tally() %>%
  dplyr::arrange(-season, -n)



#' Summarise disturbance by season and cause for ODKC data
#'
#' @param value The ouput of \code{wastd_GET("disturbance-observations") %>%
#'   parse_disturbance_observations()}
#' @export
#' @family odkc
disturbance_by_season_odkc <- . %>%
  dplyr::group_by(season, disturbanceobservation_disturbance_cause) %>%
  dplyr::tally() %>%
  dplyr::arrange(-season, -n)
