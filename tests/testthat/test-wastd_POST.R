test_that("wastd_POST returns HTTP 405 on non-existing serializers", {
    x <- wastd_POST("test", "", verbose = TRUE)
    expect_equal(class(x), "wastd_api_response")
    expect_equal(x$status_code, 405)

})

test_that("wastd_POST errors on authentication failure", {
    suppressWarnings(expect_error(
        wastd_POST(
            serializer = "",
            data = list(),
            api_token = "",
            api_un = "",
            verbose = TRUE
        )
    ))
})

# usethis::use_r("wastd_POST")
