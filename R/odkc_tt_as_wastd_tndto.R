#' Transform odkc_data$track_tally_dist into WAStD
#' TurtleNestDisturbanceTallyObservation.
#'
#' @param data A tibble of track_tally_dist,
#'   e.g. \code{odkc_data$track_tally_dist}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-disturbance-tally")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_data$track_tally_dist %>%
#'   odkc_tt_as_wastd_tndto %>%
#'   wastd_POST("turtle-nest-disturbance-tally", api_url = au, api_token = at)
#' }
odkc_tt_as_wastd_tndto <- function(data) {
    data %>%
        # sf_as_tbl() %>%
        dplyr::transmute(
            source = 2,
            source_id = id,
            encounter_source="odk",
            encounter_source_id = submissions_id,
            disturbance_cause = disturbance_cause,
            no_nests_disturbed = no_nests_disturbed,
            no_tracks_encountered = no_tracks_encountered,
            comments = disturbance_comments
        ) %>%
        dplyr::filter_at(
            dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
            dplyr::any_vars(!is.na(.))
        )
}

# usethis::use_test("odkc_tt_as_wastd_tndto")
