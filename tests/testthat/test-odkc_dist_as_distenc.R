test_that("odkc_dist_as_distenc works", {
  # testthat::skip("TODO: use vcr")

  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  user_mapping <- tibble(
    odkc_username = "test",
    pk = 1
  )

  odkc_names <- odkc_data$dist %>%
    odkc_dist_as_distenc(user_mapping) %>%
    names()

  wastd_names <- c(
    wastd_data$loggers %>% names(),
    "reporter_id",
    "observer_id",
    "where",
    "when",
    "location_accuracy_m" # no non-NULL values exist yet,
    # so wastd_parse collapses this column
  )

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% wastd_names,
      label = glue::glue("Column \"{n}\" exists in wastd_data$dist")
    )
  }
})

# usethis::use_r("odkc_dist_as_distenc")
