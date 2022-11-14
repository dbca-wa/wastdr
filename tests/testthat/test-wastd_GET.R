test_that("wastd_GET parses GeoJSON properties", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  area <-
    wastdr::wastd_GET("area", max_records = 3, verbose = T) %>%
    wastdr::parse_area()
  expect_true(class(area$area_name) == "character")
  expect_false("properties" %in% names(area))

  # com <- wastdr::wastd_GET("community", max_records = 3) %>%
  #   wastdr::wastd_parse()
  # expect_true(class(com$name) == "character")
  # expect_false("properties" %in% names(com))
})


test_that("wastd_GET aborts with NULL api_un or api_pw", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  testthat::expect_error(res <-
    wastd_GET("area", api_token = NULL, api_un = NULL))
  testthat::expect_error(res <-
    wastd_GET("area", api_token = NULL, api_pw = NULL))
})


test_that("wastd_GET warns and fails with incorrect api_token", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  at <- get_wastdr_api_token()
  wastdr_setup(api_token = "invalid")
  expect_equal(get_wastdr_api_token(), "Token invalid")

  # no warnings in check
  # warnings when run standalone
  # expect_warning(wastd_GET("area"))

  wastdr_setup(api_token = at)
  expect_equal(get_wastdr_api_token(), at)
})

test_that("wastd_GET returns something", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  res <- wastd_GET("")
  expect_equal(res$status_code, 200)
  expect_s3_class(res, "wastd_api_response")
})


test_that("wastd_GET fails if HTTP error is returned", {
  expect_warning(wastd_GET(
    "",
    api_url = "http://httpstat.us/401",
    query = list(),
    verbose = TRUE
  ))
  expect_warning(wastd_GET(
    "",
    api_url = "http://httpstat.us/500",
    query = list(),
    verbose = TRUE
  ))
  expect_warning(wastd_GET(
    "",
    api_url = "http://httpstat.us/404",
    query = list(),
    verbose = TRUE
  ))
})

test_that("wastd_GET works with correct API token", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  ae <- wastd_GET("animal-encounters", max_records = 3)
  capture.output(print(ae))
  expect_equal(ae$status_code, 200)
})

test_that("wastd_GET respects limit", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

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


test_that("wastd_GET combines pagination", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")
  # With geojson
  ae <-
    wastd_GET("animal-encounters",
      max_records = 21,
      chunk_size = 5
    )
  capture.output(print(ae))
  expect_equal(ae$status_code, 200)
  expect_true(length(ae$data) >= 21)

  # With plain json
  x <- wastd_GET("users", max_records = 21, chunk_size = 5)
  capture.output(print(x))
  expect_equal(x$status_code, 200)
  expect_true(length(x$data) >= 21)
})

test_that("wastd_GET parses anima-encounters", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")
  # With geojson
  ae <- wastdr::wastd_GET("animal-encounters",
    max_records = 20,
    chunk_size = 5,
    parse = TRUE
  )
  capture.output(print(ae))
  expect_equal(ae$status_code, 200)
  expect_true(length(ae$data) >= 82)
  expect_s3_class(ae$data, "tbl_df")
  expect_true("encounter_type" %in% names(ae$data))
  expect_true("turtle_date" %in% names(ae$data))
})

# usethis::use_r("wastd_GET")
