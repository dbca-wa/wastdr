test_that("add_hatching_emergence_success_odkc works", {
    data("odkc_data")
    x <- odkc_data$tracks %>% add_hatching_emergence_success_odkc()
    testthat::expect_true("emergence_success" %in% names(x))
})
