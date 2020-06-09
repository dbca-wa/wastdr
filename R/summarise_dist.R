#' Filter disturbance data to disturbances
#'
#' \lifecycle{stable}
#'
#' @template param-wastd-dist
#' @return The dataframe with rows matching disturbance causes.
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' library(magrittr)
#' wastd_data$nest_dist %>%
#'   filter_disturbance() %>%
#'   head()
#'
#' data("odkc_data")
#' library(sf) # This is important when handling objects of class sfc
#' odkc_data$tracks_dist %>%
#'   filter_disturbance() %>%
#'   head()
#'
#' odkc_data$dist %>%
#'   filter_disturbance() %>%
#'   head()
filter_disturbance <- function(data) {
  flt_col <- dplyr::case_when(
    "disturbanceobservation_disturbance_cause" %in% names(data) ~
    "disturbanceobservation_disturbance_cause",
    TRUE ~ "disturbance_cause"
  )

  flt_vals <- c(
    "human",
    "unknown",
    "tide",
    "turtle",
    "other",
    "vehicle",
    "cyclone"
  )

  data %>% dplyr::filter(!!rlang::sym(flt_col) %in% flt_vals)
}

#' Filter disturbance data to predator presences
#'
#' \lifecycle{stable}
#'
#' @template param-wastd-dist
#' @return The dataframe with rows matching predator presences.
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' wastd_data$nest_dist %>%
#'   filter_predation() %>%
#'   head()
#'
#' data("odkc_data")
#' odkc_data$tracks_dist %>%
#'   filter_predation() %>%
#'   head()
#'
#' odkc_data$dist %>%
#'   filter_predation() %>%
#'   head()
filter_predation <- function(data) {
  flt_col <- dplyr::case_when(
    "disturbanceobservation_disturbance_cause" %in% names(data) ~
    "disturbanceobservation_disturbance_cause",
    TRUE ~ "disturbance_cause"
  )

  flt_vals <- c(
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

  data %>% dplyr::filter(!!rlang::sym(flt_col) %in% flt_vals)
}


#' Tally WAStD disturbances by season, cause, and encounter type
#'
#' \lifecycle{stable}
#'
#' @template param-wastd-dist
#' @return A tibble with columns `season`, `disturbance_cause`,
#'  `encounter_type`, and a tally `n`.
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' library(magrittr)
#' wastd_data$nest_dist %>% wastdr::disturbance_by_season()
#'
#' data("odkc_data")
#' library(sf)
#' odkc_data$tracks_dist %>%
#'   wastdr::sf_as_tbl() %>%
#'   wastdr::disturbance_by_season()
disturbance_by_season <- function(data) {
  flt_col <- dplyr::case_when(
    "disturbanceobservation_disturbance_cause" %in% names(data) ~
    "disturbanceobservation_disturbance_cause",
    TRUE ~ "disturbance_cause"
  )

  data %>%
    {
      if ("encounter_encounter_type" %in% names(data)) {
        # wastd_data$nest_dist
        dplyr::rename(., encounter_type = encounter_encounter_type)
      } else {
        # odkc_data$tracks_dist
        dplyr::mutate(., encounter_type = "nest")
      }
    } %>%
    dplyr::group_by(season, !!rlang::sym(flt_col), encounter_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::arrange(-season, encounter_type, -n)
}

#' Tally ODKC Nest disturbances by season, cause, and encounter type
#'
#' \lifecycle{deprecated}
#'
#' @param data ODKC tracks_dist
#' @export
#' @family odkc
#' @examples
#' data("odkc_data")
#' odkc_data$tracks_dist %>% nest_disturbance_by_season_odkc()
nest_disturbance_by_season_odkc <- function(data) {
  data %>%
    wastdr::sf_as_tbl() %>%
    dplyr::group_by(season, disturbance_cause) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(encounter_type = "nest") %>%
    dplyr::arrange(-season, -n)
}


#' Tally ODKC General disturbances by season, cause, and encounter type
#'
#' \lifecycle{stable}
#'
#' @param data ODKC dist
#' @export
#' @family odkc
#' @examples
#' data("odkc_data")
#' odkc_data$dist %>% general_disturbance_by_season_odkc()
general_disturbance_by_season_odkc <- function(data) {
  data %>%
    wastdr::sf_as_tbl() %>%
    dplyr::group_by(season, disturbanceobservation_disturbance_cause) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::rename(
      disturbance_cause = disturbanceobservation_disturbance_cause
    ) %>%
    dplyr::mutate(encounter_type = "other") %>%
    dplyr::arrange(-season, -n)
}

# usethis::use_test("summarise_dist")
