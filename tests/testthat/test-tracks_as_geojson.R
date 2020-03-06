test_that("tracks_as_geojson produces a geojson geofeaturecollection", {
    data(wastd_data)
    nests_gj <- tracks_as_geojson(wastd_data$tracks)

    testthat::expect_equal(
        class(nests_gj),
        c("geofeaturecollection", "geojson", "geo_json", "json")
    )
})
