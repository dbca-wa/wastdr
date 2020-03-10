test_that("download_wastd_turtledata works", {
  skip_test_if_offline()

  # Bad things will happen if all records have all NULL area or site
  # This can break tests with `max_records = 1`
  # We get 10 records to lower the risk of picking the few with NULL area/sites
  x <- download_wastd_turtledata(max_records = 10)
  expect_equal(class(x), "wastd_data")
  expect_equal(length(x), 13) # This will change if we add more data
  xout <- capture.output(print(x))
  expect_true(stringr::str_detect(xout[[1]], "WAStD Data"))
  expect_true(stringr::str_detect(xout[[2]], "Areas"))
  expect_equal(length(xout), 6) # This will change if we add more data
})

# usethis::use_r("download_wastd_turtledata")
