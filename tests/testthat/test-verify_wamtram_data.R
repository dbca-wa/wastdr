test_that("wamtram_data works", {
  # we don't include wamtram data
  # data(w2_data)
  # verify_wamtram_data(w2_data)
  testthat::expect_error(verify_wamtram_data(NULL))
  testthat::expect_error(verify_wamtram_data(c(1, 2, 3)))
})
