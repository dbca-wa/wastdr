#' Exclude records with \code{species} "corolla-corolla".
#'
#' @param value The output of \code{parse_disturbance_observations()}.
#' @export
exclude_training_species <- . %>% dplyr::filter(species != "corolla-corolla")

#' Exclude ODKC records with \code{species} "corolla-corolla".
#'
#' @param value The output of \code{parse_disturbance_observations()}.
#' @export
#' @family odkc
exclude_training_species_odkc <- . %>% dplyr::filter(details_species != "corolla-corolla")

#' Filter records with missing \code{survey_id}
#'
#' @param value The output of \code{\link{parse_surveys}}
#' @export
filter_missing_survey <- . %>% dplyr::filter(is.na(survey_id))

#' Filter records with missing \code{site_id}
#' @param value The output of \code{parse_turtle_nest_encounters}
#' @export
filter_missing_site <- . %>% dplyr::filter(is.na(site_id))

#' Exclude training surveys.
#'
#' @param value The output of \code{parse_surveys}
#' @export
exclude_training_surveys <- . %>% dplyr::filter(is_production == TRUE)

#' Filter surveys with "NEEDS QA" in \code{start_comments} or
#' \code{end_comments}.
#'
#' @param value The output of \code{parse_surveys}
#' @export
filter_surveys_requiring_qa <- . %>%
  dplyr::filter(
    grepl("NEEDS QA", start_comments) | grepl("NEEDS QA", end_comments)
  ) %>%
  dplyr::select(
    change_url, turtle_date, site_name, reporter, reporter_username,
    start_comments, end_comments
  )

#' Filter surveys with a missing \code{end_source_id}.
#'
#' @param value The output of \code{parse_surveys}
#' @export
filter_surveys_missing_end <- . %>%
  dplyr::filter(is.na(end_source_id)) %>%
  dplyr::select(
    change_url, turtle_date, site_name, reporter, season,
    start_time, end_time, start_comments, end_comments
  )

filter_nosite <- . %>% dplyr::filter(is.na(site_id))
filter_nosurvey <- . %>% dplyr::filter(is.na(survey_id))
filter_realspecies <- . %>% dplyr::filter(species != "corolla-corolla")
filter_realsurveys <- . %>% dplyr::filter(is_production == TRUE)

#' Filter a dataframe of tracks, disturbance, incidents, or surveys to season
#'
#' @param data A dataframe of tracks, disturbance, incidents, or surveys
#'  containing a column "season" (int) with the season start year, e.g. 2019.
#' @param season_start_year The desired season's start year, e.g. 2019.
#' @return The dataframe filtered to rows from the desired season.
filter_wastd_season <- function(data, season_start_year){
  dplyr::filter(data, season == season_start_year)
}
