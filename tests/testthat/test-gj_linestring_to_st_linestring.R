test_that("gj_linestring_to_st_linestring produces sfg", {
  gj_ls <- paste0(
    "-14.803659 128.403426 10.9 5.9;",
    "-14.803719 128.40326 1.7 1.9;",
    "-14.803756 128.40317 1.9 1.7;",
    "-14.80383 128.402983 1.7 1.6;",
    "-14.803913 128.402786 1.4 1.6;"
  )
  x <- gj_linestring_to_st_linestring(gj_ls)
  # m <- mapview::mapview(x)

  testthat::expect_equal(class(x), c("XYZM", "LINESTRING", "sfg"))
  # testthat::expect_equal(class(m)[[1]], "mapview")
})

# usethis::use_r("gj_linestring_to_st_linestring")
