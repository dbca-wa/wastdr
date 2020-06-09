test_that("map_tracks_odkc returns a leaflet htmlwidget", {
  # testthat::skip_if(Sys.getenv("WASTDR_TALIBAN_TESTS", unset = FALSE) == TRUE,
  #   message = "This test segfaults on Ubuntu 19.10"
  # )

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

  # testthat::skip_if(
  #   Sys.getenv("WASTDR_TALIBAN_TESTS", unset = FALSE) == TRUE
  # )

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

test_that("map_tracks_odkc renders a timeline", {
  data("odkc_data")

  # testthat::skip_if(
  #   Sys.getenv("WASTDR_TALIBAN_TESTS", unset = FALSE) == TRUE
  # )

  themap <- map_tracks_odkc(
    odkc_data$tracks,
    sites = odkc_data$sites,
    cluster = FALSE,
    ts = TRUE
  )

  testthat::expect_equal(class(themap), c("leaflet", "htmlwidget"))
})

# usethis::use_r("map_tracks_odkc")
