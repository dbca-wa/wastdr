#' Emit a specific warning messages depending on HTTP status
#'
#' Status 401: Instruct how to authenticate.
#' Status http_error: warn and show status.
#'
#' @param response An HTTP response.
#' @export
handle_http_status <- function(response) {
  if (response$status_code == 401) {
    wastdr_msg_warn(
      glue::glue(
        "Authorization failed.\n",
        "Run wastdr::wastdr_setup(api_token='Token XXX').\n",
        "with the API token under \"My Profile\" in WAStD.\n",
        "See ?wastdr_setup or vignette('setup', package='wastdr')."
      )
    )
  }

  if (httr::http_error(response)) {
    wastdr::wastdr_msg_warn(glue::glue(
      "WAStD API request failed with [{httr::status_code(response)}]"
    ))
  }


  if (httr::http_type(response) != "application/json") {
    wastdr_msg_warn(
      glue::glue(
        "API did not return JSON.\n",
        "Is {response$url} a valid endpoint?"
      )
    )
  }
}

# usethis::use_test("handle_http_status")
