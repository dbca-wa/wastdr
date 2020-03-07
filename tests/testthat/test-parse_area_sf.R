test_that("parse_area_sf parses all records to sf", {
    data("wastd_area_raw")
    areas_sf <- wastd_area_raw %>% parse_area_sf()

    areas <- areas_sf %>%
        dplyr::filter(area_type == "Locality") %>%
        dplyr::transmute(area_id = pk, area_name = name)

    sites <- areas_sf %>%
        dplyr::filter(area_type == "Site") %>%
        dplyr::transmute(site_id = pk, site_name = name) %>%
        sf::st_join(areas)

    # Test that parse_area_sf does not lose records
    testthat::expect_equal(length(wastd_area_raw$data), nrow(areas_sf))

    # Test that parse_area_sf generates a sf object
    testthat::expect_equal(class(areas_sf), c("sf", "data.frame"))
    testthat::expect_equal(class(areas), c("sf", "data.frame"))
    testthat::expect_equal(class(sites), c("sf", "data.frame"))
})

# usethis::use_r("parse_area_sf")
