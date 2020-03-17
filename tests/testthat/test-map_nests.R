test_that("map_nests works", {
  data("wastd_data")
  themap <- wastd_data$nest_tags %>% map_nests()
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_nests")
