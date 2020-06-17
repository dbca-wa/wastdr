#' Generate a TSC user mapping from a given list of ODKC data
#'
#' Extract all unique reporter names from odkc data.
#' Extract relevant user names from TSC users.
#' Map most likely match and export to CSV.
#' External QA: change mapping, possibly update TSC user alias to imporove the
#' user matching process.
#' Return a named list containing the mapping of odkc_reporter and tsc_user_id.
#'
#' @param odkc_data .
#' @param tsc_data .
#' @export
make_user_mapping <- function(odkc_data, tsc_data) {
  odkc_reporters <- unique(c(
      odkc_data$tracks$reporter,
      odkc_data$track_tally$reporter,
      odkc_data$dist$reporter,
      odkc_data$mwi$reporter,
      odkc_data$svs$reporter,
      odkc_data$sve$reporter,
      odkc_data$tsi$reporter))

  tibble::tibble(
      odkc_username = odkc_reporters,
      tsc_user_pk = 4
  )
}
