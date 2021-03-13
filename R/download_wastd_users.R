#' Download a minimal dataset of turtle observations from WAStD
#' @template param-tokenauth
#' @template param-verbose
#' @return A tibble of user names, roles, and contact details which can be
#'   used to resolve submitted user names to WAStD user IDs
#' @export
#' @family api
download_wastd_users <- function(
                                 api_url = wastdr::get_wastdr_api_url(),
                                 api_token = wastdr::get_wastdr_api_token(),
                                 verbose = wastdr::get_wastdr_verbose()) {
  "users" %>%
    wastd_GET(
      api_url = api_url,
      api_token = api_token,
      verbose = verbose
    ) %>%
    wastd_parse()
}

# usethis::use_test("download_wastd_users") # nolint
