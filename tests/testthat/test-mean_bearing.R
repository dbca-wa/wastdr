test_that("mean_bearing works", {
  testthat::expect_equal(mean_bearing(NA, 10), NA)
  testthat::expect_equal(mean_bearing(10, NA), NA)
  testthat::expect_equal(mean_bearing(0, 20), 10)
  testthat::expect_equal(mean_bearing(20, 60), 40)
  testthat::expect_equal(mean_bearing(60, 0), 210)
})

# use_r("mean_bearing")  # nolint
