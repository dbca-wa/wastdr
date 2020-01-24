test_that("map_dist_odkc returns a leaflet htmlwidget", {
    data("odkc")

    themap <- map_dist_odkc(
      odkc$dist,
      tracks=odkc$tracks_dist,
      sites=odkc$sites)

    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

})

# usethis::use_r("map_dist_odkc")
