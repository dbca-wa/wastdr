test_that("datetime_as_isoweek returns numeric", {
  dd <- datetime_as_isoweek(httpdate_as_gmt08("2017-06-30T15:59:59Z"))
  testthat::expect_equal(class(dd), "numeric")
})

test_that("datetime_as_isoweek returns correct week at edge cases", {
  testthat::expect_equal(datetime_as_isoweek(httpdate_as_gmt08("2017-06-30T15:59:59Z")), 26)
  testthat::expect_equal(datetime_as_isoweek(httpdate_as_gmt08("2017-06-30T16:00:00Z")), 26)
  testthat::expect_equal(datetime_as_isoweek(httpdate_as_gmt08("2017-08-30T06:38:43Z")), 35)
  testthat::expect_equal(datetime_as_isoweek(httpdate_as_gmt08("2017-11-01T22:00:00Z")), 44)
  testthat::expect_equal(datetime_as_isoweek(httpdate_as_gmt08("2018-11-01T22:00:00Z")), 44)
})
