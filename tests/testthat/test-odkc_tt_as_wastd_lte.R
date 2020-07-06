test_that("odkc_tt_as_wastd_lte works", {
    # testthat::skip("TODO: use vcr")

    data("odkc_data", package = "wastdr")
    data("wastd_data", package = "wastdr")

    user_mapping <- tibble::tibble(
        odkc_username = "test",
        pk = 1
    )

    odkc_names <- odkc_data$track_tally %>%
        odkc_tt_as_wastd_lte(user_mapping) %>%
        names()

    wastd_names <- c(
        wastd_data$track_tally %>% names(),
        "source",
        "source_id",
        "location_accuracy",
        "location_accuracy_m",
        "reporter_id",
        "observer_id",
        "where",
        "when",
        "transect"
    )

    # ODKC data transformed into TSC shape should contain all fields of the
    # WAStD serializer
    for (n in odkc_names) {
        testthat::expect_true(
            n %in% wastd_names,
            label = glue::glue("Column \"{n}\" exists in wastd_data$track_tally")
        )
    }
})

# usethis::use_r("odkc_tt_as_wastd_lte")
