context("urlize")

test_that("urlize returns String object", {
  dd <- urlize("chelonia-mydas")
  testthat::expect_equal(class(dd), "character")
})

test_that("urlize returns url-safe string", {
  testthat::expect_equal(urlize("file name 1"), "file-name-1")
  testthat::expect_equal(urlize("Natator depressus"), "natator-depressus")
})
