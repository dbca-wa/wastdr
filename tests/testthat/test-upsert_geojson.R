test_that("upsert_geojson works", {
  testthat::skip("TODO: move to tscr")

  expect_message(
    x <- "public:herbie_hbvsupra_public" %>%
      gs_getFeature() %>%
      upsert_geojson(serializer = "supra", verbose = TRUE)
  )
})

# usethis::use_r("upsert_geojson")
