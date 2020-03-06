test_that("map_dist_odkc returns a leaflet htmlwidget", {
    data(odkc_data)
    themap <- map_dist_odkc(
      odkc_data$dist, tracks=odkc_data$tracks_dist, sites=odkc_data$sites
    )
    testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

test_that("map_dist_odkc works without sites", {
  data(odkc_data)
  themap <- map_dist_odkc(odkc_data$dist, tracks=odkc_data$tracks_dist)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})


test_that("map_dist_odkc works without tracks", {
  data(odkc_data)
  themap <- map_dist_odkc(odkc_data$dist)
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})


test_that("map_dist_odkc returns a leaflet htmlwidget", {
  data(odkc_data)
  themap <- map_dist_odkc(
   NULL, tracks=odkc_data$tracks_dist, sites=odkc_data$sites
  )
  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_dist_odkc")
