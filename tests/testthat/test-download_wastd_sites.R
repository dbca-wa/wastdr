test_that("download_wastd_sites works", {
  testthat::skip_if_not(wastd_works(), message = "WAStD offline or wrong auth")

  x <- download_wastd_sites()
  testthat::expect_s3_class(x$areas, "sf")
  testthat::expect_s3_class(x$sites, "sf")
  testthat::expect_equal(
    names(x$sites),
    c(
      "site_id",
      "site_name",
      "w2_place_code",
      "area_id",
      "area_name",
      "w2_location_code",
      "geometry"
    )
  )
})
