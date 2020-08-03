test_that("odkc_tt_as_wastd_tto works", {


    data("odkc_data", package = "wastdr")
    data("wastd_data", package = "wastdr")

    odkc_names <- odkc_data$track_tally %>%
        odkc_tt_as_wastd_tto() %>%
        dplyr::select(-source, -source_id) %>%
        names()

    # ODKC data transformed into WAStD shape should contain all fields of the
    # WAStD serializer
    for (n in odkc_names) {
        testthat::expect_true(
            n %in% names(wastd_data$track_tally),
            label = glue::glue(
                "Column \"{n}\" exists in wastd_data$track_tally"
            )
        )
    }

})

# usethis::use_r("odkc_tt_as_wastd_tto")
