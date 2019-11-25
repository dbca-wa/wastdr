testthat::context("wastd_GET")

check_wastd_api <- function() {
  if (get_wastdr_api_token() == "") {
    skip("Environment variable WASTDR_API_TOKEN not set, skipping...")
  }

  res <- wastd_GET("")
  if (res$status_code != 200) skip("API not available")
}

testthat::test_that("wastd_GET parses GeoJSON properties", {
  require(magrittr)
  check_wastd_api()

  area <- wastdr::wastd_GET("area", query = list(offset = 100)) %>%
    wastdr::wastd_parse()
  testthat::expect_true(class(area$geometry) == "list")
  testthat::expect_false("properties" %in% names(area))

  com <- wastdr::wastd_GET("community", query = list(offset = 500)) %>%
    wastdr::wastd_parse()
  testthat::expect_true(class(area$geometry) == "list")
  testthat::expect_false("properties" %in% names(com))
})

testthat::test_that("wastd_GET won't work unauthenticated", {
  at <- Sys.getenv("WASTDR_API_TOKEN")
  wastdr_setup(api_token = "this-is-an-invalid-token")
  testthat::expect_error(wastd_GET("area"))
  wastdr_setup(api_token = at)
})

testthat::test_that("wastd_GET returns something", {
  check_wastd_api()
  res <- wastd_GET("", query = list())
  testthat::expect_equal(res$status_code, 200)
  testthat::expect_s3_class(res, "wastd_api_response")
})


testthat::test_that("wastd_GET fails if HTTP error is returned", {
  testthat::expect_error(
    wastd_GET("", api_url = "http://httpstat.us/401", query = list())
  )
  testthat::expect_error(
    wastd_GET("", api_url = "http://httpstat.us/500", query = list())
  )
  testthat::expect_error(
    wastd_GET("", api_url = "http://httpstat.us/404", query = list())
  )
})

testthat::test_that("wastd_GET works with correct API token", {
  check_wastd_api()
  ae <- wastd_GET("animal-encounters", query = list(observer = 4))
  capture.output(print(ae))
  testthat::expect_equal(ae$status_code, 200)
})
