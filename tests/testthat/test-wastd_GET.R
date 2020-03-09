test_that("wastd_GET parses GeoJSON properties", {
  require(magrittr)
  skip_test_if_offline()

  area <- wastdr::wastd_GET("area", max_records = 3) %>%
    wastdr::parse_area()
  expect_true(class(area$area_name) == "character")
  expect_false("properties" %in% names(area))

  com <- wastdr::wastd_GET("community", max_records = 3) %>%
    wastdr::wastd_parse()
  expect_true(class(com$name) == "character")
  expect_false("properties" %in% names(com))
})

test_that("wastd_GET warns and fails with NULL api_token", {
  testthat::expect_warning(res <- wastd_GET("area", api_token = NULL))
})


test_that("wastd_GET warns and fails with incorrect api_token", {
  expect_warning(wastd_GET("area", api_token = "this-is-an-invalid-token"))
})

test_that("wastd_GET returns something", {
  skip_test_if_offline()
  res <- wastd_GET("")
  expect_equal(res$status_code, 200)
  expect_s3_class(res, "wastd_api_response")
})


test_that("wastd_GET fails if HTTP error is returned", {
  expect_warning(
    wastd_GET("", api_url = "http://httpstat.us/401", query = list())
  )
  expect_warning(
    wastd_GET("", api_url = "http://httpstat.us/500", query = list())
  )
  expect_warning(
    wastd_GET("", api_url = "http://httpstat.us/404", query = list())
  )
})

test_that("wastd_GET works with correct API token", {
  skip_test_if_offline()
  ae <- wastd_GET("animal-encounters", max_records = 3)
  capture.output(print(ae))
  expect_equal(ae$status_code, 200)
})

test_that("wastd_GET respects limit", {
  skip_test_if_offline()
  # With geojson
  ae <- wastd_GET("animal-encounters", max_records = 3)
  capture.output(print(ae))
  expect_equal(ae$status_code, 200)
  expect_equal(length(ae$data), 3)

  # With plain json
  x <- wastd_GET("users", max_records = 3)
  capture.output(print(x))
  expect_equal(x$status_code, 200)
  expect_equal(length(x$data), 3)
})

# usethis::use_r("wastd_GET")
