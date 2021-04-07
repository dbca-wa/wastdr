test_that("download_minimal_wastd_turtledata works", {
  testthat::skip_if(
    Sys.getenv("WASTDR_SKIP_SLOW_TESTS", unset = FALSE) == TRUE,
    message = "Skip slow running tests"
  )

  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  x <- download_minimal_wastd_turtledata(year = 2020)

  testthat::expect_length(x, 6)
  testthat::expect_equal(class(x), "list")
})
