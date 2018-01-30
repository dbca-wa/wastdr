context("data")
suppressMessages(library(dplyr))

testthat::test_that("animal_encounters parses correctly to animals", {
    data(animal_encounters)
    data(animals)
    fresh_animals <- parse_animal_encounters(animal_encounters)
    testthat::expect_equal(nrow(fresh_animals), nrow(animals))
    # Compare pickled and fresh animals excluding list columns (like obs)
    testthat::expect_equal(fresh_animals %>% dplyr::select(-obs),
                           animals %>% dplyr::select(-obs))
})

testthat::test_that("wastd_api_response prints", {
    data(animal_encounters)
    capture.output(print(animal_encounters))

    data("turtle_nest_encounters_hatched")
    capture.output(print(turtle_nest_encounters_hatched))
})


testthat::test_that("turtle_nest_encounters_hatched parses correctly to nests", {
    data(turtle_nest_encounters_hatched)
    data(nests)
    fresh_nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
    testthat::expect_equal(nrow(fresh_nests), nrow(nests))
    # Compare pickled and fresh nests excluding list columns (like obs)
    testthat::expect_equal(fresh_nests %>% dplyr::select(-obs, -photos),
                           nests %>% dplyr::select(-obs, -photos))
})

testthat::test_that("turtle_nest_encounters parses correctly to tracks", {
    data(turtle_nest_encounters)
    data(tracks)
    fresh_tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
    testthat::expect_equal(nrow(fresh_tracks), nrow(tracks))
    # Compare pickled and fresh nests excluding list columns (like obs)
    testthat::expect_equal(fresh_tracks %>% dplyr::select(-obs, -photos),
                           tracks %>% dplyr::select(-obs, -photos))
})


