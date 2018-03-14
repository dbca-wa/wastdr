context("data")
suppressMessages(library(dplyr))

testthat::test_that("animal_encounters parses correctly to animals", {
  data(animal_encounters)
  data(animals)
  fresh_animals <- parse_animal_encounters(animal_encounters)
  testthat::expect_equal(nrow(fresh_animals), nrow(animals))
  # Compare pickled and fresh animals excluding list columns (like obs)
  testthat::expect_equal(
    fresh_animals %>% dplyr::select(-obs),
    animals %>% dplyr::select(-obs)
  )
})

testthat::test_that("wastd_api_response prints", {
  data(animal_encounters)
  capture.output(print(animal_encounters))

  data("nests")
  capture.output(print(nests))
})


testthat::test_that("turtle_nest_encounters_hatched parses correctly to nests", {
  data(tne)
  data(nests)
  fresh_nests <- parse_turtle_nest_encounters(tne)
  testthat::expect_equal(nrow(fresh_nests), nrow(nests))
  # Compare pickled and fresh nests excluding list columns (like obs)
  testthat::expect_equal(
    fresh_nests %>% dplyr::select(-obs, -photos),
    nests %>% dplyr::select(-obs, -photos)
  )
})

testthat::test_that("turtle_nest_encounters parses correctly to tracks", {
  data(tne)
  data(nests)
  fresh_tracks <- parse_turtle_nest_encounters(tne)
  testthat::expect_equal(nrow(fresh_tracks), nrow(nests))
  # Compare pickled and fresh nests excluding list columns (like obs)
  testthat::expect_equal(
    fresh_tracks %>% dplyr::select(-obs, -photos),
    nests %>% dplyr::select(-obs, -photos)
  )
})
