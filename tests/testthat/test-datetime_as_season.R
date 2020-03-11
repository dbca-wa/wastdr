test_that("datetime_as_season returns numeric", {
  dd <- datetime_as_season(httpdate_as_gmt08("2017-06-30T16:00:00Z"))
  testthat::expect_equal(class(dd), "numeric")
})

test_that("datetime_as_season returns correct year at edge cases", {
  testthat::expect_equal(
    datetime_as_season(httpdate_as_gmt08("2017-06-30T15:59:59Z")),
    2016
  )
  testthat::expect_equal(
    datetime_as_season(httpdate_as_gmt08("2017-06-30T16:00:00Z")),
    2017
  )
  testthat::expect_equal(
    datetime_as_season(httpdate_as_gmt08("2017-08-30T06:38:43Z")),
    2017
  )
})

# usethis::use_r("datetime_as_season")
