test_that("odkc_tracks_as_tnhe works", {
  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  odkc_names <- odkc_data$tracks %>%
    odkc_tracks_as_tnhe() %>%
    dplyr::select(
      -source, -source_id,
      -cloud_cover_at_emergence,
      -hatchling_emergence_time, # not in test data but in API
      -hatchling_emergence_time_accuracy
    ) %>%
    names()

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% names(wastd_data$nest_fans),
      label = glue::glue(
        "Column \"{n}\" exists in wastd_data$nest_fans"
      )
    )
  }
})

# usethis::use_r("odkc_tracks_as_tnhe")
