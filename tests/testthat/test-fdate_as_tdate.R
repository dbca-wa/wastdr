test_that("fdate_as_tdate works", {
  expect_equal(fdate_as_tdate(0), "01 Jul")
  expect_equal(fdate_as_tdate(1), "02 Jul")
  expect_equal(fdate_as_tdate(55), "25 Aug")
  expect_equal(fdate_as_tdate(364), "30 Jun")
  expect_equal(fdate_as_tdate(365), "01 Jul")
  expect_equal(fdate_as_tdate(366), "02 Jul")
})

# usethis::use_r("fdate_as_tdate")
