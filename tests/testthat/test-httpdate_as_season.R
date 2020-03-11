context("httpdate_as_season")

test_that("httpdate_as_season returns numeric", {
  dd <- httpdate_as_season("2017-06-30T16:00:00Z")
  testthat::expect_equal(class(dd), "numeric")
})

test_that("httpdate_as_season returns correct year at edge cases", {
  testthat::expect_equal(httpdate_as_season("2017-06-30T15:59:59Z"), 2016)
  testthat::expect_equal(httpdate_as_season("2017-06-30T16:00:00Z"), 2017)
})

# usethis::use_r("httpdate_as_season")
