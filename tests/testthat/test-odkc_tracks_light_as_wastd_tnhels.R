test_that("odkc_tracks_light_as_wastd_tnhels works", {
  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  odkc_names <- odkc_data$tracks_light %>%
    odkc_tracks_light_as_wastd_tnhels() %>%
    dplyr::select(-source, -source_id) %>%
    names()

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% names(wastd_data$nest_lightsources),
      label = glue::glue(
        "Column \"{n}\" exists in wastd_data$nest_lightsources"
      )
    )
  }
})

# usethis::use_r("odkc_tracks_light_as_wastd_tnhels")
