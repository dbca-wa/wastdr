# test_that("chr2int works", {
#   expect_equal(chr2int("NA,NA"), list())
#   expect_equal(chr2int(list("NA,NA", "NA")), list())
#
#   expect_equal(
#     list(a = "NA,2,234,NA", b = "NA", c = "NA,NA,1") %>% chr2int(),
#     list(2, 234, 1)
#   )
#
#   expect_equal(
#     list("NA,2,234,NA", "NA", "NA,NA,1") %>% chr2int(),
#     list(2, 234, 1)
#   )
#
#   expect_equal(
#     list("NA,2,234,NA", "NA", "NA,NA,1") %>% chr2int(),
#     list(2, 234, 1)
#   )
#
#   testdata <- tibble::tribble(
#     ~colA, ~colB, ~crit,
#     "a", 1, "NA",
#     "b", 2, "NA,NA",
#     "c", 3, "NA, 4, 235, NA",
#     "d", 4, "1",
#     "e", 5, "2,3,4"
#   )
#
#   output_col <- purrr::map(testdata$crit, chr2int)
#   reference_col <- list(
#     list(),
#     list(),
#     list(4, 235),
#     list(1),
#     list(2, 3, 4)
#   )
#   # expect_equal(output_col, reference_col)
# })
# # usethis::use_r("chr2int")
