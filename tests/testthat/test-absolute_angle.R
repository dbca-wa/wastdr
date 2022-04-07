test_that("absolute_angle works", {
    testthat::expect_equal(absolute_angle(NA, 10), NA)
    testthat::expect_equal(absolute_angle(10, NA), NA)
    testthat::expect_equal(absolute_angle(0, 20), 20)
    testthat::expect_equal(absolute_angle(20, 0), -20)
    testthat::expect_equal(absolute_angle(10, 0), -10)
    testthat::expect_equal(absolute_angle(20, 60), 40)
    testthat::expect_equal(absolute_angle(350, 10), 20)
    testthat::expect_equal(absolute_angle(10, 350), -20)
})

# use_r("absolute_angle")  # nolint
