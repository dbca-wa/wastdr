test_that("summarise_wastd_data_per_day_site works", {
  data("wastd_data")
  x <- summarise_wastd_data_per_day_site(wastd_data)
  cols <- c(
    "area_name",
    "site_name",
    "turtle_date",
    "turtle_date_awst_text",
    "no_surveys",
    "false_crawl",
    "hatched_nest",
    "nest",
    "successful_crawl",
    "disturbed_nests",
    "general_dist",
    "live_sightings",
    "mortalities",
    "track_tallies"
  )
  testthat::expect_equivalent(names(x), cols)
})


test_that("summarise_wastd_data_per_day_site works with minimal data", {
  data("wastd_data")
  expect_warning(
    x <- wastd_data %>%
      filter_wastd_turtledata(area_name = "Troughton Island") %>%
      summarise_wastd_data_per_day_site()
  )
  testthat::expect_true("area_name" %in% names(x))
  testthat::expect_true("site_name" %in% names(x))
  testthat::expect_true("turtle_date" %in% names(x))

  x <- wastd_data %>%
    filter_wastd_turtledata(area_name = "Eco Beach") %>%
    summarise_wastd_data_per_day_site()
  testthat::expect_true("area_name" %in% names(x))
  testthat::expect_true("site_name" %in% names(x))
  testthat::expect_true("turtle_date" %in% names(x))
})


# usethis::use_r("summarise_wastd_data")  # nolint
