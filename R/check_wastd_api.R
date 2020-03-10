#' Check whether API token is set and WAStD is online, else skip test
#' @export
skip_test_if_offline <- function() {
  res <- wastd_GET("", verbose = FALSE)
  if (res$status_code != 200) {
    testthat::skip("WAStD is offline or authentication is missing.")
  }
}
