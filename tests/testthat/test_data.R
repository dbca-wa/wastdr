context("data")
library(dplyr)

testthat::test_that("animal_encounters parses correctly to tags", {
    data(animal_encounters)
    data(tags)
    ta <- parse_animal_encounters(animal_encounters)
    testthat::expect_equal(nrow(ta), nrow(tags))
    # can't compare list columns like obs
    deselect_obs <- . %>% dplyr::select(-obs)
    testthat::expect_equal(ta %>% deselect_obs, tags %>% deselect_obs)
})
