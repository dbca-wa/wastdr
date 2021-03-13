test_that("filter_wastd_turtledata returns a valid wastd_data object", {
  data("wastd_data")
  # Get an area_name that exists in the packaged data
  an <- wastd_data$tracks$area_name[[1]]
  x <- wastd_data %>% filter_wastd_turtledata(area_name = an)
  testthat::expect_s3_class(x, "wastd_data")
})

test_that("filter_wastd_turtledata requires a wastd_data object", {
  nonsense <- list()
  testthat::expect_error(
    nonsense %>% filter_wastd_turtledata()
  )
})

test_that("filter_wastd_turtledata returns all areas by default", {
  data("wastd_data")
  testthat::expect_message(
    x <- wastd_data %>% filter_wastd_turtledata(verbose = TRUE)
  )
})

test_that("filter_wastd_turtledata returns all areas when asked", {
  data("wastd_data")
  testthat::expect_message(
    x <- wastd_data %>%
      filter_wastd_turtledata(area_name = "All turtle programs", verbose = TRUE)
  )
})

test_that("filter_wastd_turtledata returns data outside areas when asked", {
  data("wastd_data")
  testthat::expect_message(
    x <- wastd_data %>%
      filter_wastd_turtledata(area_name = "Other")
  )
  # Data have all areas as NA
  testthat::expect_true(is.na(unique(x$tracks$area_name)))
  testthat::expect_true(is.na(unique(x$animals$area_name)))

})

# usethis::use_r("filter_wastd_turtledata")  # nolint
