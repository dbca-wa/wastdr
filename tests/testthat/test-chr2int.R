testthat::context("test-chr2int.R")
testthat::test_that("chr2int works", {
  testthat::expect_equal(chr2int("NA,NA"), list())
  testthat::expect_equal(chr2int(list("NA,NA", "NA")), list())

  testthat::expect_equal(
    list(a = "NA,2,234,NA", b = "NA", c = "NA,NA,1") %>% chr2int(),
    list(2, 234, 1)
  )
  testthat::expect_equal(
    list("NA,2,234,NA", "NA", "NA,NA,1") %>% chr2int(),
    list(2, 234, 1)
  )
})
# usethis::use_r("chr2int")
