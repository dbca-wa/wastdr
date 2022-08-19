test_that("verify_odkc_turtledata works", {
    data(odkc_data)
    verify_odkc_turtledata(odkc_data)
    testthat::expect_error(verify_odkc_turtledata(NULL))
    testthat::expect_error(verify_odkc_turtledata(c(1, 2, 3)))
})

# use_r("verify_odkc_turtledata")  # nolint
