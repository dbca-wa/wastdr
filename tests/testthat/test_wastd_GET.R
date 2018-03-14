context("wastd_GET")

testthat::test_that("wastd_GET won't work unauthenticated", {
  wastdr_setup(api_token = "this-is-an-invalid-token")
  testthat::expect_error(wastd_GET("animal-encounters"))
})


wastd_api_works <- function() {
  ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")
  res <- httr::GET(
    get_wastdr_api_url(), ua,
    httr::add_headers(
      c(Authorization = get_wastdr_api_token())
    )
  )
  res$status_code == 200
}

testthat::test_that("wastd_GET returns something", {
  res <- wastd_GET("", api_url = "http://echo.jsontest.com/", query = list())
  testthat::expect_equal(res$response$status_code, 200)
  testthat::expect_s3_class(res, "wastd_api_response")
})

testthat::test_that("wastd_GET fails if no valid JSON is returned", {
  testthat::expect_error(
    wastd_GET("", api_url = "http://httpstat.us/200", query = list())
  )
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
  # API token available?
  token <- Sys.getenv("WASTDR_API_TOKEN")
  if (token == "") {
    skip(
      "Environment variable WASTDR_API_TOKEN not set, skipping..."
    )
  }
  wastdr_setup(api_token = token)

  # API accessible?
  if (wastd_api_works() == FALSE) {
    skip(
      "WAStD API is not accessible from here, skipping..."
    )
  }

  ae <- wastd_GET("animal-encounters",
    query = list(limit = 3, format = "json")
  )
  capture.output(print(ae))
  testthat::expect_equal(ae$response$status_code, 200)
})
