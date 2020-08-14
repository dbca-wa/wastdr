#' Generate a WAStD user mapping from a given list of ODKC data.
#'
#' The matching is done by
#' [`fuzzyjoin::stringdist_left_join`](http://varianceexplained.org/fuzzyjoin/reference/stringdist_join.html)
#' using the Jaro-Winker distance between the ODKC username and the individual
#' WAStD `name`, `username` and `aliases`.
#'
#' The field `aliases` is where the magic happens. `make_user_mapping` matches
#' against each alias after separating the aliases by comma.
#' This way, we can add the exact misspelling of an ODK Collect username as
#' a new alias, and get a 100% match for it.
#'
#' Extract all unique reporter names from odkc data.
#' Extract relevant user names from WAStD users.
#' Map most likely match and export to CSV.
#' External QA: review mapping, update WAStD user aliases to improve the
#' user matching process. Re-run until optimized, edit CSV to improve match.
#' Return a named list containing the mapping of odkc_reporter and wastd_user_id.
#'
#' @param odkc_data The output of `wastdr::download_all_odkc_turtledata_2019`.
#' @param wastd_users A tibble of WAStD users
#' @export
make_user_mapping <- function(odkc_data, wastd_users) {
  odkc_reporters <- unique(c(
    odkc_data$tracks$reporter,
    odkc_data$track_tally$reporter,
    odkc_data$dist$reporter,
    odkc_data$mwi$reporter,
    odkc_data$svs$reporter,
    odkc_data$sve$reporter,
    odkc_data$tsi$reporter
  ))

  wastd_users <- wastd_users %>%
    dplyr::mutate(
      wastd_usernames = paste(username, name, aliases, sep=",") %>%
          stringr::str_remove_all(",$|,,$")
    )%>%
    tidyr::separate_rows(wastd_usernames, sep=",")

  tibble::tibble(
    odkc_username = odkc_reporters,
    odkc_un_trim = stringr::str_squish(odkc_reporters)
  ) %>%
    fuzzyjoin::stringdist_left_join(
      wastd_users,
      by = c(odkc_un_trim = "wastd_usernames"),
      ignore_case = TRUE,
      method = "jw",
      max_dist = 1000,
      distance_col = "dist"
    ) %>%
    dplyr::group_by(odkc_username) %>%
    dplyr::top_n(1, -dist) %>%
    dplyr::arrange(odkc_username) %>%
    dplyr::ungroup() %>%
    dplyr::select(-odkc_un_trim)
}
