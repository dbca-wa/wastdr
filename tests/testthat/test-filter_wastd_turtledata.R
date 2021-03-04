test_that("filter_wastd_turtledata returns a valid wastd_data object", {
  data("wastd_data")
  # Get an area_name that exists in the packaged data
  an <- wastd_data$tracks$area_name[[1]]

  # Filter
  x <- wastd_data %>% filter_wastd_turtledata(area_name = an)

  testthat::expect_s3_class(x, "wastd_data")
})
