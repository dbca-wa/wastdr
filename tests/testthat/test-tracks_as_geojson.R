test_that("tracks_as_geojson produces a geojson geofeaturecollection", {
  testthat::skip_if(Sys.getenv("WASTDR_TALIBAN_TESTS", unset = FALSE) == TRUE,
    message = "This test segfaults on Ubuntu 19.10"
  )

  data(wastd_data)
  nests_gj <- tracks_as_geojson(wastd_data$tracks)

  testthat::expect_equal(
    class(nests_gj),
    c("geofeaturecollection", "geojson", "geo_json", "json")
  )
})

# usethis::use_r("tracks_as_geojson")
