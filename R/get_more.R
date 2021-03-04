#' Decide whether the given download limit has been reached
#'
#' \lifecycle{stable}
#'
#' @param total_count (int) The total count of downloaded records
#' @param limit (int) or NULL The max count of records to download
#' @return (lgl) TRUE if limit has not been reached or limit is NULL, else FALSE
#' @export
#' @family helpers
#' @examples
#' testthat::expect_true(get_more(0L, NULL))
#' testthat::expect_true(get_more(1000L, NULL))
#' testthat::expect_true(get_more(9L, 10))
#' testthat::expect_false(get_more(10L, 10))
get_more <- function(total_count, limit) {
  if (is.null(limit)) {
    return(TRUE)
  }
  if (total_count < limit) {
    return(TRUE)
  }
  return(FALSE)
}

# usethis::use_test("get_more")
