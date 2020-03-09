library(testthat)
library(wastdr)

if (requireNamespace("xml2")) {
  test_check("wastdr", reporter = MultiReporter$new(reporters = list(JunitReporter$new(file = "test-results.xml"), CheckReporter$new())))
} else {
  test_check("wastdr")
}
