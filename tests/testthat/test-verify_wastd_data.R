test_that("verify_wastd_data works", {
  data(wastd_data)
  verify_wastd_data(wastd_data)
  testthat::expect_error(verify_wastd_data(NULL))
  testthat::expect_error(verify_wastd_data(c(1, 2, 3)))
})

# use_r("verify_wastd_data")  # nolint
