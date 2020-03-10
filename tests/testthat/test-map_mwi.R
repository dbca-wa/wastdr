test_that("map_mwi returns a leaflet htmlwidget", {
    data("wastd_data")
    themap <- map_mwi(wastd_data$mwi, sites = wastd_data$sites)
    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})
