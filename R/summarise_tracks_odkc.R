#' Pivot table of nesting type by season and species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)

#' Pivot table of nesting type by season, track age and species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_age_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    details_species,
    details_nest_age,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)

#' Pivot table of nesting type by area, season, and species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_area_season_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    area_name,
    season,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)

#' Pivot table of nesting type by area, season, track age, and species for
#' ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_area_season_age_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    area_name,
    season,
    details_species,
    details_nest_age,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by site, season, and species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_site_season_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    area_name,
    site_name,
    season,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by site, season, track age, and species for
#' ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_site_season_age_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    area_name,
    site_name,
    season,
    details_species,
    details_nest_age,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by season, season_week, iso_week, and species
#' for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_week_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    season_week,
    iso_week,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by season, season_week, iso_week, track age, and
#' species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_week_age_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    season_week,
    iso_week,
    details_species,
    details_nest_age,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by season, season_week, iso_week, and species
#' for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_week_site_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    season_week,
    iso_week,
    site_name,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)

#' Pivot table of nesting type by season, turtle date. and species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_day_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    turtle_date,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup()


#' Pivot table of nesting type by season, calendardate, and species for
#' ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_calendarday_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    calendar_date_awst,
    details_species,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)


#' Pivot table of nesting type by season, calendardate, and track age, and
#' species for ODKC data
#'
#' @template param-value-odkc-tracks
#' @export
#' @family odkc
nesting_type_by_season_calendarday_age_species_odkc <- . %>%
  # dplyr::filter(details_nest_age == "fresh") %>%
  dplyr::group_by(
    season,
    calendar_date_awst,
    details_species,
    details_nest_age,
    details_nest_type
  ) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(details_nest_type, n, fill = 0)

#' Add calculated egg count, hatching and emergence success to
#' `odkc_data$tracks_egg`.
#'
#'
#' Hatching success as percentage (0..100) after Miller 1999:
#'   Hatching success = 100 * no_egg_shells / (
#'   no_egg_shells + no_undeveloped_eggs + no_unhatched_eggs +
#'   no_unhatched_term + no_depredated_eggs)
#'
#' Emergence success as percentage (0..100) after Miller 1999:
#'   Emergence success = 100 *
#'   (no_egg_shells - no_live_hatchlings - no_dead_hatchlings) / (
#'   no_egg_shells + no_undeveloped_eggs + no_unhatched_eggs +
#'    no_unhatched_term + no_depredated_eggs)
#'
#' @param data ODKC Track or Nest data annotated with egg counts, e.g.
#'   `odkc_data$tracks_egg`.
#' @export
#' @family odkc
add_hatching_emergence_success_odkc <- function(data) {
  data %>%
    dplyr::mutate(
      egg_count_calculated = (
        egg_count_no_egg_shells +
          egg_count_no_undeveloped_eggs +
          egg_count_no_unhatched_eggs +
          egg_count_no_unhatched_term +
          egg_count_no_depredated_eggs
      ),
      hatching_success = ifelse(
        egg_count_calculated == 0,
        0,
        round(100 * egg_count_no_egg_shells / egg_count_calculated, 2)
      ),
      emergence_success = ifelse(
        egg_count_calculated == 0,
        0,
        round(
          100 * (
            egg_count_no_egg_shells -
              egg_count_no_live_hatchlings -
              egg_count_no_dead_hatchlings
          ) / egg_count_calculated,
          2
        )
      )
    )
}


#' Summarize HS and ES for Nest excavations
#'
#' \lifecycle{stable}
#'
#' @param data The output of \code{wastd_data$nest_excavations}
#' @export
#' @family odkc
#' @examples
#' data("odkc_data")
#' odkc_data$tracks_egg %>%
#'   wastdr::sf_as_tbl() %>%
#'   wastdr::add_hatching_emergence_success_odkc() %>%
#'   wastdr::hatching_emergence_success_odkc()
hatching_emergence_success_odkc <- function(data) {
  data %>%
    dplyr::filter(hatching_success >= 0) %>%
    dplyr::group_by(season, details_species) %>%
    summarise_hatching_and_emergence_success(.)
}
