test_that("map_mwi returns a leaflet htmlwidget", {
  data("wastd_data")
  themap <- map_mwi(wastd_data$animals, sites = wastd_data$sites)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_mwi tolerates NULL data", {
  data("wastd_data")
  themap <- map_mwi(NULL, sites = wastd_data$sites)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# use_r("map_mwi")
