context("datetime_as_seasonweek")

test_that("datetime_as_isoweek returns numeric", {
    dd <- datetime_as_seasonweek(httpdate_as_gmt08("2017-06-30T15:59:59Z"))
    testthat::expect_equal(class(dd), "numeric")
})

test_that("datetime_as_seasonweek returns correct week at edge cases", {
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T15:59:59Z")), 0)
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2017-07-02T16:00:00Z")), 1)
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2017-08-30T06:38:43Z")), 9)
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2017-11-01T22:00:00Z")), 18)
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2018-11-01T22:00:00Z")), 18)
    testthat::expect_equal(datetime_as_seasonweek(httpdate_as_gmt08("2018-01-01T12:00:00Z")), 27)
})
