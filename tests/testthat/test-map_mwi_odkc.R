test_that("map_dist_odkc returns a leaflet htmlwidget", {
    library(turtleviewer)
    data("turtledata", package="turtleviewer")

    themap <- map_mwi_odkc(
        turtledata$mwi,
        sites=turtledata$sites)

    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

})

# usethis::use_r("map_mwi_odkc")
