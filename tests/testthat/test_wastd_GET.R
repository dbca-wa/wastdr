testthat::context("wastd_GET")

testthat::test_that("wastd_GET won't work unauthenticated", {
  wastdr_setup(api_token = "this-is-an-invalid-token")
  testthat::expect_error(wastd_GET("animal-encounters"))
})


check_wastd_api <- function() {
  ua <- httr::user_agent("http://github.com/dbca-wa/wastdr")
  res <- httr::GET(
    get_wastdr_api_url(),
    ua,
    httr::add_headers(c(Authorization = get_wastdr_api_token()))
  )
  if (res$status_code != 200) skip("API not available")
}

testthat::test_that("wastd_GET returns something", {
  check_wastd_api()
  res <- wastd_GET("", query = list())
  testthat::expect_equal(res$status_code, 200)
  testthat::expect_s3_class(res, "wastd_api_response")
})

# testthat::test_that("wastd_GET fails if no valid JSON is returned", {
#   testthat::expect_error(wastd_GET("", api_url = "http://httpstat.us/200", query = list()))
# })

testthat::test_that("wastd_GET fails if HTTP error is returned", {
  testthat::expect_error(wastd_GET("", api_url = "http://httpstat.us/401", query = list()))
  testthat::expect_error(wastd_GET("", api_url = "http://httpstat.us/500", query = list()))
  testthat::expect_error(wastd_GET("", api_url = "http://httpstat.us/404", query = list()))
})

testthat::test_that("wastd_GET works with correct API token", {
  if (get_wastdr_api_token() == "") skip("Environment variable WASTDR_API_TOKEN not set, skipping...")
  check_wastd_api()
  ae <- wastd_GET("animal-encounters",
    query = list(observer = 4, format = "json"),
    api_token = get_wastdr_api_token()
  )
  capture.output(print(ae))
  testthat::expect_equal(ae$status_code, 200)
})
