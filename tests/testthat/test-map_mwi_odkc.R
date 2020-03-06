test_that("map_dist_odkc returns a leaflet htmlwidget", {
    data("odkc_data")

    themap <- map_mwi_odkc(
        odkc_data$mwi,
        sites=odkc_data$sites)

    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

})

# usethis::use_r("map_mwi_odkc")
