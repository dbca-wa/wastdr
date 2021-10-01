test_that("tracks_ts works", {
  # testthat::skip("ggalt requires libproj.so.19")
  # ggalt vs libproj mudfight fixed currently by
  # https://github.com/hrbrmstr/ggalt/issues/22#issuecomment-722078387
  data("wastd_data")
  t <- tempdir()
  fs::dir_ls(t) %>% fs::file_delete()


  x <- tracks_ts(
    wastd_data$tracks,
    wastd_data$surveys,
    local_dir = t,
    placename = "PLACE",
    prefix = "TEST",
    export = TRUE
  )
  expect_equal(class(x), c("gg", "ggplot"))
  expect_true(fs::file_exists(fs::path(t, "TEST_track_abundance_place.png")))
})

# usethis::use_r("tracks_ts")
