test_that("mis_bearing works", {
  # A harmeless angle in the NE sector
  testthat::expect_equal(mis_bearing(10, 50, 40), c(30, 40))
  testthat::expect_equal(mis_bearing(10, 50, 40)[1], 30)
  testthat::expect_equal(mis_bearing(10, 50, 40)[2], 40)

  # This angle includes N
  testthat::expect_equal(mis_bearing(10, 50, 340), c(340, 30))

  # A large angle that is smaller via N
  testthat::expect_equal(mis_bearing(30, 50, 230), c(230, 40))

  # Same large angle but mirrored to be smaller over S
  testthat::expect_equal(mis_bearing(30, 50, 210), c(40, 210))
})

# use_r("mis_bearing")  # nolint
