test_that("tracks_ts works", {
  testthat::skip("ggalt requires libproj.so.19")
  data("wastd_data")
  x <- tracks_ts(
    wastd_data$tracks,
    wastd_data$surveys,
    local_dir = tempdir(),
    placename = "Placename",
    prefix = "ABC"
  )
  expect_equal(class(x), c("gg", "ggplot"))
})

# usethis::use_r("tracks_ts")
