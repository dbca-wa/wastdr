test_that("map_tracks_odkc returns a leaflet htmlwidget", {
    data("odkc")

    themap <- map_tracks_odkc(
        odkc$tracks,
        sites=odkc$sites,
        cluster=FALSE)

    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

    themap2 <- map_tracks_odkc(
        odkc$tracks,
        sites=odkc$sites,
        cluster=TRUE)
    testthat::expect_equal(class(themap2), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_tracks_odkc")
