test_that("multiplication works", {
  data("wastd_data")
  themap <- wastd_data$nest_dist %>% map_dist()
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_dist")
