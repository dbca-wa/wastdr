#' Pivot table of nesting type by season and species
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
nesting_type_by_season_species <- . %>%
  # dplyr::filter(nest_age == "fresh") %>%
  dplyr::group_by(season, species, nest_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(nest_type, n, fill = 0)

#' Pivot table of nesting type by area, season and species
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
nesting_type_by_area_season_species <- . %>%
  # dplyr::filter(nest_age == "fresh") %>%
  dplyr::group_by(area_name, season, species, nest_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(nest_type, n, fill = 0)

#' Pivot table of nesting type by site, season and species
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
nesting_type_by_site_season_species <- . %>%
  # dplyr::filter(nest_age == "fresh") %>%
  dplyr::group_by(area_name, site_name, season, species, nest_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(nest_type, n, fill = 0)


#' Pivot table of nesting type by season, season_week, iso_week, and species
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
nesting_type_by_season_week_species <- . %>%
  dplyr::filter(nest_age == "fresh") %>%
  dplyr::group_by(season, season_week, iso_week, species, nest_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup() %>%
  tidyr::spread(nest_type, n, fill = 0)

#' Pivot table of nesting type by season, turtle date and species
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
nesting_type_by_season_day_species <- . %>%
  # dplyr::filter(nest_age == "fresh") %>%
  dplyr::group_by(season, turtle_date, species, nest_type) %>%
  dplyr::tally() %>%
  dplyr::ungroup()

#------------------------------------------------------------------------------#
# Nesting success - tracks with nest vs tracks without and rest
#

#' Calculate nesting success as number of tracks with nests vs other tracks
#' @template param-tracks
#' @export
track_success <- function(tracks) {
  nest_type <- NULL
  season <- NULL
  turtle_date <- NULL
  species <- NULL
  n <- NULL
  successful <- NULL

  all_tracks_by_date <- tracks %>%
    dplyr::filter(nest_type %in% c(
      "successful-crawl",
      "false-crawl",
      "track-unsure",
      "track-not-assessed"
    )) %>%
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
    dplyr::left_join(successful_tracks_by_date, by = c("turtle_date", "species", "season")) %>%
    dplyr::mutate(
      successful = ifelse(is.na(successful), 0, successful),
      track_success = 100 * successful / all
    )
}

#' The nesting success grouped by season and species
#'
#' @param track_success The output of \code{\link{track_success}}
#' @export
track_success_by_species <- function(track_success) {
  season <- NULL
  species <- NULL

  track_success %>%
    group_by(season, species) %>%
    dplyr::summarise(
      mean_nesting_success = mean(track_success) %>% round(digits = 2),
      sd_nesting_success = stats::sd(track_success) %>% round(digits = 2)
    )
}


#' Plot the track success (absolute numbers) of a given species as time series
#'
#' @param data The output of \code{\link{track_success}}
#' @param speciesname The species name, e.g. "natator-depressus"
#' @template param-placename
#' @template param-prefix
#' @export
ggplot_track_success_by_date <- function(
                                         data,
                                         speciesname,
                                         placename = "",
                                         prefix = "") {
  . <- NULL
  species <- NULL
  aes <- NULL
  turtle_date <- NULL
  vars <- NULL
  season <- NULL
  successful <- NULL

  data %>%
    dplyr::filter(species == speciesname) %>%
    ggplot2::ggplot(aes(x = tdate_as_fdate(turtle_date))) +
    ggplot2::facet_grid(rows = vars(season), scales = "free_x") +
    ggplot2::geom_bar(aes(y = all), stat = "identity", color = "black", fill = "grey") +
    ggplot2::geom_bar(aes(y = successful), stat = "identity", color = "black", fill = "green") +
    ggplot2::ggtitle(paste("Nesting effort of", speciesname %>% humanize()),
      subtitle = "Number of all (grey) and successful (green) tracks"
    ) +
    ggplot2::labs(x = "Date", y = "Number of all and successful tracks") +
    ggplot2::scale_x_continuous(labels = function(x) fdate_as_tdate(x)) +
    ggplot2::scale_y_continuous(limits = c(0, NA)) +
    ggplot2::theme_classic() +
    ggplot2::ggsave(glue::glue("{prefix}_track_effort_{wastdr::urlize(placename)}_{speciesname}.png"), width = 10, height = 6)
}

#' Plot the track success rate (relative numbers) of a given species as time series
#'
#' @param data The output of \code{parse_turtle_nest_encounters()}
#' @param speciesname The species name, e.g. "natator-depressus"
#' @template param-placename
#' @template param-prefix
#' @export
ggplot_track_successrate_by_date <- function(
                                             data,
                                             speciesname,
                                             placename = "",
                                             prefix = "") {
  . <- NULL
  species <- NULL
  aes <- NULL
  turtle_date <- NULL
  vars <- NULL
  season <- NULL

  data %>%
    dplyr::filter(species == speciesname) %>%
    ggplot2::ggplot(aes(x = tdate_as_fdate(turtle_date))) +
    ggplot2::facet_grid(rows = vars(season), scales = "free_x") +
    ggplot2::geom_bar(aes(y = track_success), stat = "identity", color = "black", fill = "grey") +
    ggplot2::ggtitle(paste("Nesting success of", speciesname %>% humanize()),
      subtitle = "Fraction of successful over total nesting crawls"
    ) +
    ggplot2::labs(x = "Date", y = "Fraction of tracks with nest") +
    ggplot2::scale_x_continuous(labels = function(x) fdate_as_tdate(x)) +
    ggplot2::scale_y_continuous(limits = c(0, NA)) +
    ggplot2::theme_classic() +
    ggplot2::ggsave(glue::glue("{prefix}_track_success_{wastdr::urlize(placename)}_{speciesname}.png"), width = 10, height = 6)
}

#------------------------------------------------------------------------------#
# Hatching and emergence success - from nest excavations
#
#' Utility to summarise a tibble of tracks with nest excavtion data.
#'
#' Calculates:
#' \itemize{
#' \item count The count of nests
#' \item clutch_size_fresh Mean observed clutch size during nesting event (if given)
#' \item clutch_size_mean Mean of reconstructed clutch size
#' \item clutch_size_sd SD of reconstructed clutch size
#' \item clutch_size_min Min of reconstructed clutch size
#' \item clutch_size_maz Max of reconstructed clutch size
#' \item hatching_success_{mean, sd, min, max} Hatching success stats
#' \item emergence_success_{mean, sd, min, max} Emergence success stats
#' }
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
summarise_hatching_and_emergence_success <- . %>%
  dplyr::summarize(
    "count" = n(),
    "clutch_size_fresh" = mean(clutch_size_fresh) %>% round(digits = 2),
    "clutch_size_mean" = mean(clutch_size) %>% round(digits = 2),
    "clutch_size_sd" = sd(clutch_size) %>% round(digits = 2),
    "clutch_size_min" = min(clutch_size),
    "clutch_size_max" = max(clutch_size),
    "hatching_success_mean" = mean(hatching_success) %>% round(digits = 2),
    "hatching_success_sd" = sd(hatching_success) %>% round(digits = 2),
    "hatching_success_min" = min(hatching_success),
    "hatching_success_max" = max(hatching_success),
    "emergence_success_mean" = mean(emergence_success) %>% round(digits = 2),
    "emergence_success_sd" = sd(emergence_success) %>% round(digits = 2),
    "emergence_success_min" = min(emergence_success),
    "emergence_success_max" = max(emergence_success)
  )


#' Sumarizes HS and ES for tracks of type `hatched-nest`.
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
hatching_emergence_success <- . %>%
  dplyr::filter(nest_type == "hatched-nest") %>%
  dplyr::filter(hatching_success >= 0) %>%
  dplyr::group_by(season, species) %>%
  summarise_hatching_and_emergence_success(.)

#' Sumarizes HS and ES for tracks of type `hatched-nest`, grouped by `area_name`.
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
hatching_emergence_success_area <- . %>%
  dplyr::filter(nest_type == "hatched-nest") %>%
  dplyr::filter(hatching_success >= 0) %>%
  dplyr::group_by(area_name, season, species) %>%
  summarise_hatching_and_emergence_success(.)

#' Sumarizes HS and ES for tracks of type `hatched-nest`, grouped by `site_name`.
#'
#' @param value The output of \code{parse_turtle_nest_encounters()}
#' @export
hatching_emergence_success_site <- . %>%
  dplyr::filter(nest_type == "hatched-nest") %>%
  dplyr::filter(hatching_success >= 0) %>%
  dplyr::group_by(site_name, season, species) %>%
  summarise_hatching_and_emergence_success(.)
