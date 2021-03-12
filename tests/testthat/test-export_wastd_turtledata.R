test_that("export_wastd_turtledata works", {
    data("wastd_data", package = "wastdr")
    t <- tempdir()
    wastd_data %>%
      export_wastd_turtledata(outdir = t, filename = "test")
    testthat::expect_true(length(fs::dir_ls(t)) > 0)
})
