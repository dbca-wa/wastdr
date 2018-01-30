testthat::context("map_chr_hack")

testthat::test_that("map_chr_hack works", {
    data("animal_encounters")
    nn <- map_chr_hack(animal_encounters$features, c("properties", "name"))
    testthat::expect_true(is.na(nn[[1]])) # this depends on animal_encounters first name being NULL
    testthat::expect_equal(nn[[2]], animal_encounters$features[[2]]$properties$name)
})
