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


#' Summarise WAStD disturbance by season and cause
#'
#' @param value The ouput of
#'   \code{
#'   \link{wastdr::wastd_GET}("turtle-nest-disturbance-observations") %>%
#'   \link{wastdr::parse_encounterobservations}()
#'   } or \code{data("wastd_data"); wastd_data$nest_dist}
#'
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' wastd_data$nest_dist %>% disturbance_by_season
disturbance_by_season <- . %>%
  dplyr::group_by(season, disturbance_cause, encounter_encounter_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  dplyr::rename(encounter_type = encounter_encounter_type) %>%
  dplyr::arrange(-season, encounter_type, -n)



#' Summarise nest disturbance by season and cause for ODKC data
#'
#' @param value ODKC tracks_dist
#' @export
#' @family odkc
#' @examples
#' data("odkc_data")
#' odkc_data$tracks_dist %>% nest_disturbance_by_season_odkc()
nest_disturbance_by_season_odkc <- . %>%
  wastdr::sf_as_tbl() %>%
  dplyr::group_by(season, disturbance_cause) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  dplyr::mutate(encounter_type = "nest") %>%
  dplyr::arrange(-season, -n)


#' Summarise general disturbance by season and cause for ODKC data
#'
#' @param value ODKC dist
#' @export
#' @family odkc
#' @examples
#' data("odkc_data")
#' odkc_data$dist %>% general_disturbance_by_season_odkc()
general_disturbance_by_season_odkc <- . %>%
  wastdr::sf_as_tbl() %>%
  dplyr::group_by(season, disturbanceobservation_disturbance_cause) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  dplyr::rename(disturbance_cause = disturbanceobservation_disturbance_cause) %>%
  dplyr::mutate(encounter_type = "other") %>%
  dplyr::arrange(-season, -n)

# usethis::use_test("summarise_dist")
