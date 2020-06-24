#' Generate a TSC user mapping from a given list of ODKC data
#'
#' Extract all unique reporter names from odkc data.
#' Extract relevant user names from TSC users.
#' Map most likely match and export to CSV.
#' External QA: review mapping, update TSC user aliases to improve the
#' user matching process. Re-run until optimsed, edit CSV to improve match.
#' Return a named list containing the mapping of odkc_reporter and tsc_user_id.
#'
#' @param odkc_data The output of `wastdr::download_all_odkc_turtledata_2019`.
#' @param tsc_users A tibble of TSC users
#' @export
make_user_mapping <- function(odkc_data, tsc_users) {
  odkc_reporters <- unique(c(
      odkc_data$tracks$reporter,
      odkc_data$track_tally$reporter,
      odkc_data$dist$reporter,
      odkc_data$mwi$reporter,
      odkc_data$svs$reporter,
      odkc_data$sve$reporter,
      odkc_data$tsi$reporter))

  tsc_users <- tsc_users %>%
    dplyr::mutate(tsc_usernames = paste(name, aliases, nickname, username))

  tibble::tibble(odkc_username = odkc_reporters) %>%
    fuzzyjoin::stringdist_join(
      tsc_users,
      by = c(odkc_username = "tsc_usernames"),
      ignore_case = TRUE,
      method = "jw",
      max_dist = 99,
      distance_col = "dist"
    ) %>%
    dplyr::group_by(odkc_username) %>%
    dplyr::top_n(1, -dist) %>%
    dplyr::arrange(odkc_username) %>%
    dplyr::ungroup()
}
