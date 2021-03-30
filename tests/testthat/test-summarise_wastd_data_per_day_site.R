test_that("summarise_wastd_data_per_day_site works", {
  data("wastd_data")
  x <- summarise_wastd_data_per_day_site(wastd_data)
  cols <- c(
    "area_name",
    "site_name",
    "calendar_date_awst",
    "no_surveys",
    "false_crawl",
    "hatched_nest",
    "nest",
    "successful_crawl",
    "track_not_assessed",
    "track_unsure",
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
  x <- wastd_data %>%
    filter_wastd_turtledata(area_name = "Troughton Island") %>%
    summarise_wastd_data_per_day_site()
  testthat::expect_true("area_name" %in% names(x))
  testthat::expect_true("site_name" %in% names(x))
  testthat::expect_true("calendar_date_awst" %in% names(x))

  x <- wastd_data %>%
    filter_wastd_turtledata(area_name = "Eco Beach") %>%
    summarise_wastd_data_per_day_site()
  testthat::expect_true("area_name" %in% names(x))
  testthat::expect_true("site_name" %in% names(x))
  testthat::expect_true("calendar_date_awst" %in% names(x))
})


# usethis::use_r("summarise_wastd_data")  # nolint
