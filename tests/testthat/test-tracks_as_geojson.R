test_that("tracks_as_geojson produces a geojson geofeaturecollection", {
    data(nests)
    nests_gj <- tracks_as_geojson(nests)

    testthat::expect_equal(
        class(nests_gj),
        c("geofeaturecollection", "geojson", "geo_json", "json")
    )
})
