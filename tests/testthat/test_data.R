context("data")
library(dplyr)

testthat::test_that("animal_encounters parses correctly to animals", {
    data(animal_encounters)
    data(animals)
    fresh_animals <- parse_animal_encounters(animal_encounters)
    testthat::expect_equal(nrow(fresh_animals), nrow(animals))
    # can't compare list columns like obs
    deselect_obs <- . %>% dplyr::select(-obs)
    testthat::expect_equal(fresh_animals %>% deselect_obs, animals %>% deselect_obs)
})

testthat::test_that("wastd_api_response prints", {
    data(animal_encounters)
    print(animal_encounters)
})
