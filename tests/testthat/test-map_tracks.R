test_that("map_tracks returns a leaflet htmlwidget", {
  data("wastd_data")

  themap <- map_tracks(
    wastd_data$tracks,
    sites = wastd_data$sites,
    cluster = FALSE
  )

  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))

  themap2 <- map_tracks(
    wastd_data$tracks,
    sites = wastd_data$sites,
    cluster = TRUE
  )
  testthat::expect_equal(class(themap2), c("leaflet", "htmlwidget"))


  themap3 <- map_tracks(
    wastd_data$tracks,
    sites = wastd_data$sites,
    ts = TRUE
  )
  testthat::expect_equal(class(themap3), c("leaflet", "htmlwidget"))

  themap4 <- map_tracks(
    wastd_data$tracks,
    sites = wastd_data$sites,
    ts = TRUE,
    cluster = TRUE
  )
  testthat::expect_equal(class(themap4), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_tracks")