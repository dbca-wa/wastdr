test_that("odkc_mwi_dmg_as_wastd_turtledmg works", {
  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  odkc_names <- odkc_data$mwi_dmg %>%
    odkc_mwi_dmg_as_wastd_turtledmg() %>%
    dplyr::select(-source, -source_id) %>%
    names()

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% names(wastd_data$turtle_dmg),
      label = glue::glue(
        "Column \"{n}\" exists in wastd_data$turtle_dmg"
      )
    )
  }
})

# usethis::use_r("odkc_mwi_dmg_as_wastd_turtledmg")
