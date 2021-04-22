#' Convert a SimpleFeatures object to a non-spatial dataframe
#'
#' @param sf_obj A SimpleFeatures object
#'
#' @return The SimpleFeatures object with geometry set to NULL.
#' @export
#' @family helpers
#' @examples
#' data("wastd_data")
#' sf_as_tbl(wastd_data$sites)
sf_as_tbl <- function(sf_obj) {
  sf::st_geometry(sf_obj) <- NULL
  tibble::as_tibble(sf_obj)
}


#' Pivot table of nesting type by season and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_species(wastd_data$tracks)
nesting_type_by_season_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(season, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by season, track age and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_age_species(wastd_data$tracks)
nesting_type_by_season_age_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(season, species, nest_age, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}

#' Pivot table of nesting type by area, season, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_area_season_species(wastd_data$tracks)
nesting_type_by_area_season_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(area_name, season, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}

#' Pivot table of nesting type by area, season, track age, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_area_season_age_species(wastd_data$tracks)
nesting_type_by_area_season_age_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(area_name, season, species, nest_age, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by site, season, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_site_season_species(wastd_data$tracks)
nesting_type_by_site_season_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(area_name, site_name, season, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by site, season, track age, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_site_season_age_species(wastd_data$tracks)
nesting_type_by_site_season_age_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(
      area_name,
      site_name,
      season,
      species,
      nest_age,
      nest_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by season, season_week, iso_week, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_site_season_age_species(wastd_data$tracks)
nesting_type_by_season_week_species <- function(tracks) {
  tracks %>%
    dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(
      season,
      season_week,
      iso_week,
      species,
      nest_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by season, season_week, iso_week, track age,
#' and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_week_age_species(wastd_data$tracks)
nesting_type_by_season_week_age_species <- function(tracks) {
  tracks %>%
    dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(
      season,
      season_week,
      iso_week,
      species,
      nest_age,
      nest_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by season, season_week, iso_week, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_week_site_species(wastd_data$tracks)
nesting_type_by_season_week_site_species <- function(tracks) {
  tracks %>%
    dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(
      season,
      season_week,
      iso_week,
      site_name,
      species,
      nest_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}


#' Pivot table of nesting type by season, turtle date. and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_day_species(wastd_data$tracks)
nesting_type_by_season_day_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(season, turtle_date, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup()
}

#' Pivot table of nesting type by season, calendardate, and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_calendarday_species(wastd_data$tracks)
nesting_type_by_season_calendarday_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(season, calendar_date_awst, species, nest_type) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}

#' Pivot table of nesting type by season, calendardate, and track age,
#' and species
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' nesting_type_by_season_calendarday_age_species(wastd_data$tracks)
nesting_type_by_season_calendarday_age_species <- function(tracks) {
  tracks %>%
    # dplyr::filter(nest_age == "fresh") %>%
    dplyr::group_by(
      season, calendar_date_awst, species, nest_age, nest_type
    ) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    tidyr::spread(nest_type, n, fill = 0)
}

#------------------------------------------------------------------------------#
# Nesting success - tracks with nest vs tracks without and rest
#

#' Calculate nesting success as number of tracks with nests vs other tracks
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' track_success(wastd_data$tracks)
track_success <- function(tracks) {
  all_tracks_by_date <- tracks %>%
    dplyr::filter(
      nest_type %in% c(
        "successful-crawl",
        "false-crawl",
        "track-unsure",
        "track-not-assessed"
      )
    ) %>%
    dplyr::group_by(season, turtle_date, species) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::rename(all = n)

  successful_tracks_by_date <- tracks %>%
    dplyr::filter(nest_type == "successful-crawl") %>%
    dplyr::group_by(season, turtle_date, species) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%
    dplyr::rename(successful = n)

  all_tracks_by_date %>%
    dplyr::left_join(successful_tracks_by_date,
      by = c("turtle_date", "species", "season")
    ) %>%
    dplyr::mutate(
      successful = ifelse(is.na(successful), 0, successful),
      track_success = 100 * successful / all
    )
}

#' The nesting success grouped by season and species
#'
#' \lifecycle{stable}
#'
#' @param track_success The output of \code{\link{track_success}}
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' track_success(wastd_data$tracks) %>% track_success_by_species()
track_success_by_species <- function(track_success) {
  track_success %>%
    dplyr::group_by(season, species) %>%
    dplyr::summarise(
      mean_nesting_success = mean(track_success) %>% round(digits = 2),
      sd_nesting_success = stats::sd(track_success) %>% round(digits = 2)
    ) %>%
    dplyr::ungroup()
}


#' Plot the track success (absolute numbers) of a given species as time series
#'
#' \lifecycle{stable}
#'
#' @param data The output of \code{\link{track_success}}
#' @param speciesname The species name, e.g. "natator-depressus"
#' @template param-placename
#' @template param-prefix
#' @param local_dir The dir to save the plot to as PNG,
#'   default: \code{here::here()}
#' @param export Whether to export the figure as a file, default: FALSE
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' sp <- wastd_data$tracks$species[[1]]
#' track_success(wastd_data$tracks) %>% ggplot_track_success_by_date(sp)
ggplot_track_success_by_date <- function(data,
                                         speciesname,
                                         placename = "",
                                         prefix = "",
                                         local_dir = here::here(),
                                         export = FALSE) {
  data %>%
    dplyr::filter(species == speciesname) %>%
    ggplot2::ggplot(ggplot2::aes(x = tdate_as_fdate(turtle_date))) +
    ggplot2::facet_grid(rows = ggplot2::vars(season), scales = "free_x") +
    ggplot2::geom_bar(
      ggplot2::aes(y = all),
      stat = "identity",
      color = "black",
      fill = "grey"
    ) +
    ggplot2::geom_bar(
      ggplot2::aes(y = successful),
      stat = "identity",
      color = "black",
      fill = "green"
    ) +
    ggplot2::ggtitle(glue::glue("Nesting effort of {humanize(speciesname)}"),
      subtitle = "Number of all (grey) and successful (green) tracks"
    ) +
    ggplot2::labs(x = "Date", y = "Number of all and successful tracks") +
    ggplot2::scale_x_continuous(
      labels = function(x) {
        fdate_as_tdate(x)
      }
    ) +
    ggplot2::scale_y_continuous(limits = c(0, NA)) +
    ggplot2::theme_classic() +
    {
      if (export == TRUE) {
        ggplot2::ggsave(fs::path(
          local_dir,
          glue::glue(
            "{prefix}_track_effort_",
            "{wastdr::urlize(placename)}_{speciesname}.png"
          )
        ),
        width = 10,
        height = 6
        )
      }
    } +
    NULL
}

#' Plot the track success rate (relative numbers) of a given species as time
#' series
#'
#' \lifecycle{stable}
#'
#' @template param-tracks
#' @param speciesname The species name, e.g. "natator-depressus"
#' @template param-placename
#' @template param-prefix
#' @param local_dir The dir to save the plot to as PNG,
#'   default: \code{here::here()}
#' @param export Whether to export the figure as a file, default: FALSE
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' sp <- wastd_data$tracks$species[[1]]
#' track_success(wastd_data$tracks) %>% ggplot_track_successrate_by_date(sp)
ggplot_track_successrate_by_date <- function(tracks,
                                             speciesname,
                                             placename = "",
                                             prefix = "",
                                             local_dir = here::here(),
                                             export = FALSE) {
  tracks %>%
    dplyr::filter(species == speciesname) %>%
    ggplot2::ggplot(ggplot2::aes(x = tdate_as_fdate(turtle_date))) +
    ggplot2::facet_grid(rows = ggplot2::vars(season), scales = "free_x") +
    ggplot2::geom_bar(
      ggplot2::aes(y = track_success),
      stat = "identity",
      color = "black",
      fill = "grey"
    ) +
    ggplot2::ggtitle(glue::glue("Nesting success of {humanize(speciesname)}"),
      subtitle = "Fraction of successful over total nesting crawls"
    ) +
    ggplot2::labs(x = "Date", y = "Fraction of tracks with nest") +
    ggplot2::scale_x_continuous(
      labels = function(x) {
        fdate_as_tdate(x)
      }
    ) +
    ggplot2::scale_y_continuous(limits = c(0, NA)) +
    ggplot2::theme_classic() +
    {
      if (export == TRUE) {
        ggplot2::ggsave(fs::path(
          local_dir,
          glue::glue(
            "{prefix}_track_success_",
            "{wastdr::urlize(placename)}_{speciesname}.png"
          )
        ),
        width = 10,
        height = 6
        )
      }
    } +
    NULL
}

#------------------------------------------------------------------------------#
# Hatching and emergence success - from nest excavations
#
#' \lifecycle{stable}
#'
#' Utility to summarise a tibble of tracks with nest excavation data.
#' If the dataset does not contain variables \code{egg_count} or
#' \code{egg_count_calculated}, they will be added and set to
#' \code{NA_integer_}. This can happen if the subset of data retrieved from
#' WAStD happens to contain all NA in either of these variables, as
#' \code{\link{parse_encounterobservations}} drops columns with all NA.
#'
#' Calculates:
#' \itemize{
#' \item count The count of nests
#' \item clutch_size_fresh Mean observed clutch size during nesting event
#' \item clutch_size_{mean, sd, min, max}  Reconstructed clutch size stats
#' \item hatching_success_{mean, sd, min, max} Hatching success stats
#' \item emergence_success_{mean, sd, min, max} Emergence success stats
#' }
#'
#' @param data The output of \code{wastd_data$nest_excavations}
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' summarise_hatching_and_emergence_success(wastd_data$nest_excavations)
summarise_hatching_and_emergence_success <- function(data) {
  data %>%
    {
      if (!("egg_count" %in% names(.))) {
        dplyr::mutate(., egg_count = NA_integer_)
      } else {
        .
      }
    } %>%
    {
      if (!("egg_count_calculated" %in% names(.))) {
        dplyr::mutate(., egg_count_calculated = NA_integer_)
      } else {
        .
      }
    } %>%
    # TODO need to filter tracks without nests? will these bias HS/ES?
    # dplyr::filter(is.na(egg_count)) %>%
    dplyr::summarize(
      "count" = dplyr::n(),
      "clutch_size_fresh" = mean(egg_count) %>% round(digits = 2),
      "clutch_size_mean" = mean(egg_count_calculated) %>% round(digits = 2),
      "clutch_size_sd" = stats::sd(egg_count_calculated) %>% round(digits = 2),
      "clutch_size_min" = min(egg_count_calculated),
      "clutch_size_max" = max(egg_count_calculated),
      "hatching_success_mean" = mean(hatching_success) %>% round(digits = 2),
      "hatching_success_sd" = stats::sd(hatching_success) %>% round(digits = 2),
      "hatching_success_min" = min(hatching_success),
      "hatching_success_max" = max(hatching_success),
      "emergence_success_mean" = mean(emergence_success) %>% round(digits = 2),
      "emergence_success_sd" = stats::sd(emergence_success) %>%
        round(digits = 2),
      "emergence_success_min" = min(emergence_success),
      "emergence_success_max" = max(emergence_success)
    )
}

#' Summarize HS and ES for Nest excavations
#'
#' \lifecycle{stable}
#'
#' @param data The output of \code{wastd_data$nest_excavations}
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' hatching_emergence_success(wastd_data$nest_excavations)
hatching_emergence_success <- function(data) {
  data %>%
    dplyr::filter(hatching_success >= 0) %>%
    dplyr::group_by(season, species) %>%
    summarise_hatching_and_emergence_success(.)
}

#' Summarize HS and ES for excavations of hatched nests grouped by `area_name`
#'
#' \lifecycle{stable}
#'
#' @param data The output of \code{wastd_data$nest_excavations}
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' hatching_emergence_success_area(wastd_data$nest_excavations)
hatching_emergence_success_area <- function(data) {
  data %>%
    dplyr::filter(hatching_success >= 0) %>%
    dplyr::group_by(encounter_area_name, season, species) %>%
    summarise_hatching_and_emergence_success(.)
}

#' Summarize HS and ES for excavations of hatched nests grouped by `site_name`
#'
#' \lifecycle{stable}
#'
#' @param data The output of \code{wastd_data$nest_excavations}
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' hatching_emergence_success_site(wastd_data$nest_excavations)
hatching_emergence_success_site <- function(data) {
  data %>%
    dplyr::filter(hatching_success >= 0) %>%
    dplyr::group_by(encounter_site_name, season, species) %>%
    summarise_hatching_and_emergence_success(.)
}
# usethis::use_test("summarise_tracks")
