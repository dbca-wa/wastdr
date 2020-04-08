#' Check whether API token is set and WAStD is online
#'
#' \lifecycle{stable}
#' @template param-auth
#'
#' @family helpers
#' @export
wastd_works <- function(api_url = get_wastdr_api_url(),
                        api_token = get_wastdr_api_token(),
                        api_un = get_wastdr_api_un(),
                        api_pw = get_wastdr_api_pw()) {
  # suppressWarnings(
    res <- wastd_GET(
      "",
      max_records = 1,
      api_url = api_url,
      api_token = api_token,
      api_un = api_un,
      api_pw = api_pw,
      verbose = FALSE
    )
  # )

  return(class(res) == "wastd_api_response" && res$status_code == 200)
}

#' Check whether ODKC is online
#'
#' \lifecycle{stable}
#'
#' @param url The ODK URL, default: \code{ruODK::get_default_url}
#' @family helpers
#' @export
odkc_works <- function(url = ruODK::get_default_url()) {
  res <- httr::GET(url)
  return(res$status_code == 200)
}

# usethis::use_test("check_wastd_api")
