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
