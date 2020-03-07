#' #' Check whether API token is set and WAStD is online, else abort
#' #' @export
#' check_wastd_api <- function() {
#'     res <- wastd_GET("")
#'     if (res$status_code != 200)
#'         wastdr_msg_abort("WAStD is offline or authentication is missing.")
#' }

#' Check whether API token is set and WAStD is online, else skip test
#' @export
skip_test_if_offline <- function(){
    res <- wastd_GET("")
    if (res$status_code != 200)
        testthat::skip("WAStD is offline or authentication is missing.")
}
