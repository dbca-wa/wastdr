test_that("download_wastd_turtledata works", {
  testthat::skip_if(Sys.getenv("WASTDR_SKIP_SLOW_TESTS", unset = FALSE) == TRUE,
    message = "Skip slow running tests"
  )

  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  # Bad things will happen if all records have all NULL area or site
  # This can break tests with `max_records = 1`
  # We get 10 records to lower the risk of picking the few with NULL area/sites
  x <- suppressWarnings(download_wastd_turtledata(max_records = 100, min_year = 2021))

  expect_equal(class(x), "wastd_data")
  expect_equal(length(x), 22) # This will change if we add more data

  xout <- capture.output(print(x))
  expect_true(stringr::str_detect(xout[[1]], "WAStD Data"))
  expect_true(stringr::str_detect(xout[[2]], "Areas"))
  expect_equal(length(xout), 20) # This will change if we print more stats
})

test_that("download_wastd_turtledata emits verbose messages", {
  testthat::skip_if(Sys.getenv("WASTDR_SKIP_SLOW_TESTS", unset = FALSE) == TRUE,
    message = "Skip slow running tests"
  )

  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  verbose <- wastdr::get_wastdr_verbose()
  Sys.setenv(WASTDR_VERBOSE=TRUE)
  testthat::expect_message(download_wastd_turtledata(max_records = 100, min_year = 2021))
  Sys.setenv(WASTDR_VERBOSE=verbose)
})

# usethis::use_r("download_wastd_turtledata")
