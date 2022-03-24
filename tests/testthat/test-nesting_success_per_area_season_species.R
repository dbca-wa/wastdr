test_that("nesting_success_per_area_season_species works", {
  data(wastd_data)
  x <- nesting_success_per_area_season_species(wastd_data)
  cols <- c(
    # group cols
    "area_name", "season", "species",

    # data cols
    # "false-crawl", "hatched-nest", "nest",
    # "successful-crawl", "track-not-assessed", "track-unsure",
    # "absent", "na", "nest-unsure-of-eggs",
    # "nest-with-eggs", "no-nest", "unsure-if-nest",

    # summary cols
    "emergences",
    "nesting_present",
    "nesting_unsure",
    "nesting_absent",
    "nesting_success_optimistic",
    "nesting_success_pessimistic"
  )
  testthat::expect_equivalent(names(x), cols)
})

test_that("nesting_success_per_area_season_species works with limited data", {
  data(wastd_data)
  first_found_area <- wastd_data$tracks$area_name[1]
  x <- wastd_data %>%
    wastdr::filter_wastd_turtledata(area_name = first_found_area) %>%
    nesting_success_per_area_season_species()

  testthat::expect_s3_class(x, "tbl_df")
  x
})
