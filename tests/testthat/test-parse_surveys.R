test_that("parse_surveys parses to tibble with correct column classes", {
  data("wastd_surveys_raw")
  surveys <- wastd_surveys_raw %>% parse_surveys()
  testthat::expect_equal(class(surveys), c("tbl_df", "tbl", "data.frame"))
  testthat::expect_true(is.integer(surveys$area_id))
  testthat::expect_true(is.integer(surveys$site_id))
  testthat::expect_true(is.character(surveys$site_name))

  # calendar_date_awst is cast to character to prevent auto tz conversion
  testthat::expect_true(is.character(surveys$calendar_date_awst))

  # start time is an actual time with local tz
  testthat::expect_equal(lubridate::tz(surveys$start_time), "Australia/Perth")
})

# usethis::use_r("parse_surveys")
