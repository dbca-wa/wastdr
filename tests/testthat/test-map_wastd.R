test_that("map_wastd gatechecks for missing data", {
  expect_error(map_wastd(NULL))
})

test_that("map_wastd returns a leaflet htmlwidget", {
  data("wastd_data")
  themap <- map_wastd(wastd_data)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with filtered data", {
  data("wastd_data")
  x <- wastd_data %>% filter_wastd_turtledata(area_name = "Troughton Island")
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with missing animals", {
  data("wastd_data")
  x <- wastd_data
  x$animals <- NULL
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with missing tracks", {
  data("wastd_data")
  x <- wastd_data
  x$tracks <- NULL
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with missing dist", {
  data("wastd_data")
  x <- wastd_data
  x$dist <- NULL
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with missing sites", {
  data("wastd_data")
  x <- wastd_data
  x$sites <- NULL
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_wastd works with missing data", {
  data("wastd_data")
  x <- wastd_data
  x$animals <- NULL
  x$tracks <- NULL
  x$dist <- NULL
  x$sites <- NULL
  themap <- map_wastd(x)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})
