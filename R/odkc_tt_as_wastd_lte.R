#' Transform odkc_data$track_tally into WAStD LineTransectEncounters.
#'
#' @param data A tibble of parsed ODKC Track Tallies,
#'   e.g. \code{odkc_data$track_tally}.
#' @param user_mapping .
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("line-transect-encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#'
#' odkc_data$track_tally %>%
#'   odkc_tt_as_wastd_lte(user_mapping) %>%
#'   head(1) %>%
#'   jsonlite::toJSON()
#' }
odkc_tt_as_wastd_lte <- function(data, user_mapping) {
    wastd_reporters <- user_mapping %>%
        dplyr::transmute(reporter = odkc_username, reporter_id = pk)

    wastd_observers <- user_mapping %>%
        dplyr::transmute(observer = odkc_username, observer_id = pk)

    data %>%
        dplyr::mutate(transect = sf::st_as_text(tx)) %>%
        sf_as_tbl() %>%
        dplyr::transmute(
            source = "odk", # wastd.observations.models.SOURCE_CHOICES
            source_id = id,
            reporter = reporter,
            observer = reporter,
            where = glue::glue(
                "POINT ({overview_location_longitude}",
                " {overview_location_latitude})"
            ),
            location_accuracy = "10",
            # ODKC v0.6 returns ODK linestring > wastdr > ST linestring w/o acc
            # location_accuracy_m = details_observed_at_accuracy,
            when = lubridate::format_ISO8601(observation_start_time, usetz = TRUE),
            transect = transect
        ) %>%
        dplyr::left_join(wastd_reporters, by = "reporter") %>% # TSC User PK
        dplyr::left_join(wastd_observers, by = "observer") %>% # TSC User PK
        dplyr::select(-reporter, -observer) # drop odkc_username
}

# usethis::use_test("odkc_tt_as_wastd_lte")
