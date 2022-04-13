test_that("map_fanangles returns a leaflet map", {
  data(wastd_data)
  themap <- map_fanangles(wastd_data)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_fanangles gatechecks for missing data", {
  expect_error(map_fanangles(NULL))
})

test_that("map_fanangles works with missing data", {
  data(wastd_data)
  # This area name does not exist, the resulting data has the correct cols but
  # no rows
  x <- wastd_data %>% filter_wastd_turtledata(area_name = "blub")
  testthat::expect_equal(nrow(x$nest_fans), 0)
  testthat::expect_equal(nrow(x$nest_fan_outliers), 0)
  testthat::expect_equal(nrow(x$nest_lightsources), 0)

  # This should not throw any errors
  themap <- map_fanangles(x)

  # map_fanangles should still produce a map, even if empty
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# use_r("map_fanangles")  # nolint
