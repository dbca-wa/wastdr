#' Transform odkc_data$tracks into WAStD TurtleNestObservations (egg counts).
#'
#' @param data A tibble of tracks,  e.g. \code{odkc_data$tracks}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("turtle-nest-excavations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_as_wastd_nestobs(odkc_ex$tracks)
#' x %>% wastd_POST("turtle-nest-excavations", api_url = au, api_token = at)
#' }
odkc_tracks_as_wastd_nestobs <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = id,
      nest_position = nest_habitat,
      no_egg_shells = egg_count_no_egg_shells,
      no_live_hatchlings = egg_count_no_live_hatchlings,
      no_dead_hatchlings = egg_count_no_dead_hatchlings,
      no_undeveloped_eggs = egg_count_no_undeveloped_eggs,
      no_unhatched_eggs = egg_count_no_unhatched_eggs,
      no_unhatched_term = egg_count_no_unhatched_term,
      no_depredated_eggs = egg_count_no_depredated_eggs,
      nest_depth_top = egg_count_nest_depth_top,
      nest_depth_bottom = egg_count_nest_depth_bottom
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_tracks_as_wastd_nestobs")
