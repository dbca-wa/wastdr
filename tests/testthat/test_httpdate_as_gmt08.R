context("httpdate_as_gmt08")

test_that("httpdate_as_gmt08 returns POSIXct", {
  dd <- httpdate_as_gmt08("2016-11-20T21:46:57.163000Z")
  testthat::expect_s3_class(dd, "POSIXct")
})


test_that("httpdate_as_gmt08 returns correct date", {
  dd <- httpdate_as_gmt08("2016-11-20T21:46:57.163000Z")
  # "2016-11-21 05:46:57 AWST"
  testthat::expect_equal(lubridate::year(dd), 2016)
  testthat::expect_equal(lubridate::month(dd), 11)
  testthat::expect_equal(lubridate::day(dd), 21)
  testthat::expect_equal(lubridate::hour(dd), 5)
  testthat::expect_equal(lubridate::minute(dd), 46)
  testthat::expect_equal(lubridate::second(dd), 57.163)

  awst_dt <- as.POSIXct("2016-11-21 05:46:57.163000", tz = "Australia/Perth")
  testthat::expect_equal(dd, awst_dt)

  awst_dd <- as.POSIXct(dd, tz = "Australia/Perth")
  testthat::expect_equal(dd, awst_dd)
})

test_that("httpdate_as_gmt08 returns correct timezone GMT+08", {
  dd <- httpdate_as_gmt08("2016-11-20T21:46:57.163000Z")
  testthat::expect_equal(lubridate::tz(dd), "Australia/Perth")
})
