test_that("parse_area parses to tibble with correct column classes", {
  data("wastd_area_raw")
  areas <- wastd_area_raw %>% parse_area()
  testthat::expect_equal(class(areas), c("tbl_df", "tbl", "data.frame"))
  testthat::expect_true(is.integer(areas$area_id))
  testthat::expect_true(is.character(areas$area_name))
  testthat::expect_true(is.numeric(areas$northern_extent))
  testthat::expect_true(is.numeric(areas$length_surveyed_m))
  testthat::expect_true(is.numeric(areas$length_survey_roundtrip_m))
})

# usethis::use_r("parse_area")
