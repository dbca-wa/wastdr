test_that("download_wastd_sites works", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  x <- download_wastd_sites()
  testthat::expect_s3_class(x, "sf")
  testthat::expect_equal(
    names(x),
    c(
      "site_id",
      "site_name",
      "area_id",
      "area_name",
      "geometry"
    )
  )
})
