test_that("export_wastd_turtledata works", {
  data("wastd_data", package = "wastdr")

  destdir <- fs::path(tempdir(), "wastd")
  if (fs::dir_exists(destdir)) fs::dir_delete(destdir)

  wastd_data %>%
    export_wastd_turtledata(outdir = destdir, filename = "test")
  testthat::expect_true(length(fs::dir_ls(destdir)) > 0)
})

test_that("export_wastd_turtledata requires a wastd_data object", {
  nonsense <- list()
  testthat::expect_error(
    nonsense %>% export_wastd_turtledata()
  )
})
