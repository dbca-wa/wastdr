#' Transform odkc_data$tracks into WAStD NestTagObservations.
#'
#' @param data A tibble of tracks, e.g. \code{odkc_data$tracks}.
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("nest-tag-observations")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' au <- Sys.getenv("WASTDR_API_DEV_URL")
#' at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
#' x <- odkc_tracks_as_wastd_nesttagobs(odkc_ex$tracks)
#' x %>% wastd_POST("nest-tag-observations", api_url = au, api_token = at)
#' }
odkc_tracks_as_wastd_nesttagobs <- function(data) {
  data %>%
    sf_as_tbl() %>%
    dplyr::transmute(
      source = 2,
      source_id = id,
      encounter_source="odk",
      encounter_source_id = id,
      status = nest_tag_status,
      flipper_tag_id = nest_tag_flipper_tag_id,
      tag_label = nest_tag_tag_label,
      date_nest_laid = ifelse(
        is.na(nest_tag_date_nest_laid),
        NA,
        lubridate::format_ISO8601(
          nest_tag_date_nest_laid,
          precision = "ymd"
        )
      ),
      comments = nest_tag_tag_comments
    ) %>%
    dplyr::filter_at(
      dplyr::vars(-source, -source_id, -encounter_source, -encounter_source_id),
      dplyr::any_vars(!is.na(.))
    )
}

# usethis::use_test("odkc_tracks_as_wastd_nesttagobs")
