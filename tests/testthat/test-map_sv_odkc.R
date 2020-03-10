test_that("map_sv_odkc returns a leaflet htmlwidget", {
    data("odkc_data")
    themap <- map_sv_odkc(
        odkc_data$svs,
        odkc_data$sve,
        sites = odkc_data$sites
    )
    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
    themap
})

# usethis::use_r("map_sv_odkc")
