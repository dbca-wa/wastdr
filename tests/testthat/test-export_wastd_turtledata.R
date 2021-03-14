test_that("export_wastd_turtledata works", {
    data("wastd_data", package = "wastdr")
    t <- tempdir()
    wastd_data %>%
      export_wastd_turtledata(outdir = t, filename = "test")
    testthat::expect_true(length(fs::dir_ls(t)) > 0)
})

test_that("export_wastd_turtledata requires a wastd_data object", {
  nonsense <- list()
  testthat::expect_error(
    nonsense %>% export_wastd_turtledata()
  )
})
