test_that("get_more works", {
    testthat::expect_true(get_more(0L, NULL))
    testthat::expect_true(get_more(1000L, NULL))
    testthat::expect_true(get_more(9L, 10))
    testthat::expect_false(get_more(10L, 10))
})

# usethis::use_r("get_more")
