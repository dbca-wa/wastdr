#' Download a minimal dataset of turtle observations from TSC
#' @template param-auth
#' @template param-verbose
#' @return A tibble of user names, roles, and contact details which can be
#'   used to resolve submitted user names to TSC user IDs
#' @export
download_tsc_users <- function(
                               api_url = wastdr::get_wastdr_api_url(),
                               api_token = wastdr::get_wastdr_api_token(),
                               api_un = wastdr::get_wastdr_api_un(),
                               api_pw = wastdr::get_wastdr_api_pw(),
                               verbose = wastdr::get_wastdr_verbose()) {
  "users" %>%
    wastd_GET(
      api_url = api_url,
      api_token = api_token,
      api_un = api_un,
      api_pw = api_pw,
      verbose = verbose
    ) %>%
    wastd_parse()
}
