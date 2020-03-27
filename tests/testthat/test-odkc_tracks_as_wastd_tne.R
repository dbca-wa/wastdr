test_that("odkc_tracks_as_wastd_tne works", {
  # testthat::skip("TODO: use vcr")

  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  # odkc_data$tracks %>%
  #     odkc_tracks_as_wastd_tne() %>%
  #     head(1) %>%
  #     jsonlite::toJSON()

  odkc_names <- odkc_data$tracks %>%
    odkc_tracks_as_wastd_tne() %>%
    names()

  wastd_names <- c(
    wastd_data$tracks %>% names(),
    "reporter_id",
    "observer_id",
    "where",
    "when"
  )

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% wastd_names,
      label = glue::glue("Column \"{n}\" exists in wastd_data$tracks")
    )
  }

  # odkc_data$tracks %>%
  #     odkc_tracks_as_wastd_tne() %>%
  #   wastd_bulk_post("turtle-nest-encounters",
  #   api_url = "http://localhost:8220/api/1/")
})

# usethis::use_r("odkc_tracks_as_wastd_tne")
