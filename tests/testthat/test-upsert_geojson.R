test_that("upsert_geojson works", {
  expect_message(
    x <- "public:herbie_hbvsupra_public" %>%
      gs_getFeature() %>%
      upsert_geojson(serializer = "supra", verbose = TRUE)
  )
})

# usethis::use_r("upsert_geojson")
