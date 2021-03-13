test_that("download_wastd_sites works", {
  x <- download_wastd_sites()
  testthat::expect_s3_class(x, "sf")
  testthat::expect_equal(
      names(x),
      c("site_id",
        "site_name",
        "area_id",
        "area_name",
        "geometry"
      )
  )
})
