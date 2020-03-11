context("httpdate_as_gmt08_turtle_date")

test_that("httpdate_as_gmt08_turtle_date returns Date object", {
  dd <- httpdate_as_gmt08_turtle_date("2016-11-20T21:46:57.163000Z")
  testthat::expect_s3_class(dd, "Date")
})


test_that("httpdate_as_gmt08_turtle_date returns correct date", {
  da <- httpdate_as_gmt08_turtle_date("2016-11-20T21:46:57.163000Z")
  nov20 <- lubridate::as_date("2016-11-20")

  # These datetimes are turtle date 2016-11-20:
  noon_awst <- httpdate_as_gmt08_turtle_date("2016-11-20T04:00:00Z")
  soon_noon_awst <- httpdate_as_gmt08_turtle_date("2016-11-21T03:59:59Z")

  testthat::expect_equal(da, nov20)
  testthat::expect_equal(noon_awst, nov20)
  testthat::expect_equal(soon_noon_awst, nov20)
})

# usethis::use_r("httpdate_as_gmt08_turtle_date")
