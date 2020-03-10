test_that("wastd_GET parses GeoJSON properties", {
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

test_that("wastd_GET falls back to BasicAuth with NULL api_token", {
  skip_test_if_offline()
  capture_warnings(
    # TSC currentle does not support BasicAuth
    testthat::expect_message(res <- wastd_GET("area", api_token = NULL))
  )
})

test_that("wastd_GET aborts with NULL api_un or api_pw", {
  skip_test_if_offline()
  testthat::expect_error(res <- wastd_GET("area", api_token = NULL, api_un = NULL))
  testthat::expect_error(res <- wastd_GET("area", api_token = NULL, api_pw = NULL))
})


test_that("wastd_GET warns and fails with incorrect api_token", {
  skip_test_if_offline()
  at <- get_wastdr_api_token()
  wastdr_setup(api_token = "invalid")
  expect_equal(get_wastdr_api_token(), "invalid")

  # no warnings in check
  # warnings when run standalone
  # expect_warning(wastd_GET("area"))

  wastdr_setup(api_token = at)
  expect_equal(get_wastdr_api_token(), at)
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
