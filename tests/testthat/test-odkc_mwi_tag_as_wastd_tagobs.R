test_that("odkc_mwi_tag_as_wastd_tagobs works", {
  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")
  user_mapping <- tibble::tibble(odkc_username = "test", pk = 1)

  odkc_names <- odkc_data$mwi_tag %>%
    odkc_mwi_tag_as_wastd_tagobs(user_mapping = user_mapping) %>%
    dplyr::select(-source, -source_id, -handler_id, -recorder_id) %>%
    names()

  # ODKC data transformed into TSC shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% names(wastd_data$turtle_tags),
      label = glue::glue(
        "Column \"{n}\" exists in wastd_data$turtle_tags"
      )
    )
  }
})

# usethis::use_r("odkc_mwi_tag_as_wastd_tagobs")
