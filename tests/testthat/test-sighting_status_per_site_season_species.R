test_that("sighting_status_per_site_season_species works", {
  data(wastd_data)
  x <- sighting_status_per_site_season_species(wastd_data)
  cols <- c(
    # group cols
    "Site name", "Season", "Species",
    # summary cols
    "Na", "Remigrant", "Resighting", "New"
  )
  purrr::map(
    names(x),
    ~ testthat::expect_true(
      . %in% cols,
      label = glue::glue("{.} is an expected column")
    )
  )
})

test_that("sighting_status_per_site_season_species works with limited data", {
  data(wastd_data)
  first_found_area <- wastd_data$animals$area_name[1]
  x <- wastd_data %>%
    wastdr::filter_wastd_turtledata(area_name = first_found_area) %>%
    sighting_status_per_site_season_species()

  testthat::expect_s3_class(x, "tbl_df")
  x
})

# use_r("summarise_wastd_data")  # nolint
