test_that("wastd_POST works", {
    suppressWarnings(expect_error(wastd_POST("test", "")))
})

# usethis::use_r("wastd_POST")
