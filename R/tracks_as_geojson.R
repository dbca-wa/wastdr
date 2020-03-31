#' Convert tracks to a GeoJSON string
#'
#' \lifecycle{stable}
#'
#' Turns calendar_date_awst (required) into start and end (start + 1 day) dates,
#' converts dataframe to GeoJSON string.
#' @template param-tracks
#' @export
#' @family helpers
tracks_as_geojson <- function(tracks) {
  tracks %>%
    dplyr::mutate(
      start = calendar_date_awst %>% as.Date(),
      end = start + 1
    ) %>%
    geojsonio::geojson_json(
      lat = "observed_at_latitude",
      lon = "observed_at_longitude"
    )
}

# usethis::use_test("tracks_as_geojson")
