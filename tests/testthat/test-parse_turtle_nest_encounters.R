test_that("parse_turtle_nest_encounters parses correctly", {
  data(wastd_tne_raw)
  data(wastd_tne)
  fresh_tracks <- parse_turtle_nest_encounters(wastd_tne_raw)
  expect_equal(length(wastd_tne_raw$data), nrow(wastd_tne))
  expect_equal(nrow(fresh_tracks), nrow(wastd_tne))

  # Compare pickled and fresh animals excluding list columns (like obs)
  expect_equal(fresh_tracks, wastd_tne)
})


# usethis::use_r("parse_turtle_nest_encounters")
