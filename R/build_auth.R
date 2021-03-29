#' Build token or basic authentication based on given credentials
#'
#' @template param-auth
#' @template param-verbose
#' @return httr::authenticate() for Basicauth or httr::add_headers for TokenAuth
#' @export
build_auth <- function(api_token = get_wastdr_api_token(),
                       api_un = get_wastdr_api_un(),
                       api_pw = get_wastdr_api_pw(),
                       api_url = get_wastdr_api_url(),
                       verbose = get_wastdr_verbose()) {
  if (!is.null(api_token)) {
    auth <- httr::add_headers(c(Authorization = api_token))
  } else {
    wastdr_msg_info("No API token found, using BasicAuth.", verbose = verbose)
    if (is.null(api_un)) {
      wastdr_msg_abort("BasicAuth requires an API username.")
    }
    if (is.null(api_pw)) {
      wastdr_msg_abort("BasicAuth requires an API password.")
    }
    auth <- httr::authenticate(api_un, api_pw, type = "basic")
  }
}

# usethis::use_test("build_auth")
