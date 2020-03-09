test_that("map_tracks_odkc returns a leaflet htmlwidget", {
  data("odkc_data")

  themap <- map_tracks_odkc(
    odkc_data$tracks,
    sites = odkc_data$sites,
    cluster = FALSE
  )

  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

  themap2 <- map_tracks_odkc(
    odkc_data$tracks,
    sites = odkc_data$sites,
    cluster = TRUE
  )
  testthat::expect_equal(class(themap2), c("leaflet", "htmlwidget"))
})

test_that("map_tracks_odkc works without sites", {
  data("odkc_data")

  themap <- map_tracks_odkc(
    odkc_data$tracks,
    sites = NULL,
    cluster = FALSE
  )

  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

  themap2 <- map_tracks_odkc(
    odkc_data$tracks,
    sites = NULL,
    cluster = TRUE
  )
  testthat::expect_equal(class(themap2), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_tracks_odkc")
