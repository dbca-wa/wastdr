context("humanize")

test_that("humanize returns String object", {
  dd <- humanize("chelonia-mydas")
  testthat::expect_equal(class(dd), "character")
})

test_that("humanize returns human readable string", {
  testthat::expect_equal(humanize("natator-depressus"), "Natator Depressus")
  testthat::expect_equal(humanize("successful-crawl"), "Successful Crawl")
})
