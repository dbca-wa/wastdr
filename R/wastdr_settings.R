#' Get or set wastdr WAStD settings
#'
#' @export
#' @return \code{wastdr_settings} prints your base url and WAStD API key.
#' \code{ckanr_setup} sets your production and test settings, while
#' @seealso \code{\link{wastdr_setup}},
#' \code{\link{get_wastdr_api_url}},
#' \code{\link{get_wastdr_api_token}},
#' \code{\link{get_wastdr_api_un}}, and
#' \code{\link{get_wastdr_api_pw}}.
#' @family wastr settings
wastdr_settings <- function() {
  ops <- list(
    api_url = Sys.getenv("WASTDR_API_URL", ""),
    api_token = Sys.getenv("WASTDR_API_TOKEN", ""),
    api_un = Sys.getenv("WASTDR_API_UN"),
    api_pw = Sys.getenv("WASTDR_API_PW")
  )
  structure(ops, class = "wastdr_settings")
}

#' @export
print.wastdr_settings <- function(x, ...) {
  cat("<wastdr settings>", sep = "\n")
  cat("  API URL: ", x$api_url, "\n")
  cat("  API Token: ", x$api_token, "\n")
  cat("  API Username: ", x$api_un, "\n")
  cat("  API Password: ", x$api_pw, "\n")


  if (is.null(x$api_token) && is.null(x$api_un)) {
    message(paste0(
      "wastdr requires either an API token or a username and ",
      "password to authenticate requests to the WAStD API."
    ))
  }
}

# ------------------------------------------------------------------------------#
# Setters
#
#' Configure default WAStD settings
#'
#' @export
#' @param api_url A WAStD API URL (optional),
#'   default: "https://tsc.dbca.wa.gov.au/api/1/"
#' @param api_token A CKAN API token (character)
#' @param api_un Alternatively, a CKAN API username (character)
#' @param api_pw The password to the CKAN username (character)
#' @details
#' \code{wastdr_setup} sets WAStD API connection details. \code{wastdr}'s
#' functions default to use the default URL, but require an API key to work.
#' @examples
#' # WAStD users with a DBCA account can access their WAStD authentication
#' # token on their profile page on WAStD:
#' wastdr_setup(api_token = "wastd_token")
#'
#' # Non-DBCA users will have been given a WAStD username and password:
#' wastdr_setup(api_un = "wastd_username",
#'              api_pw = "wastd_password")
#'
#' # Not specifying the default WAStD API URL will reset the WAStD URL to its
#' # default "https://tsc.dbca.wa.gov.au/api/1/":
#' wastdr_setup(api_token = "c12345asdfqwer")
wastdr_setup <- function(
                         api_url = get_wastdr_api_url(),
                         api_token = NULL,
                         api_un = get_wastdr_api_un(),
                         api_pw = get_wastdr_api_pw()) {
  Sys.setenv("WASTDR_API_URL" = api_url)

  if (!is.null(api_token)) {
    Sys.setenv("WASTDR_API_TOKEN" = paste("Token", api_token))
  }
  if (!is.null(api_un)) {
    Sys.setenv("WASTDR_API_UN" = api_un)
  }
  if (!is.null(api_pw)) {
    Sys.setenv("WASTDR_API_PW" = api_pw)
  }
}

# ------------------------------------------------------------------------------#
# Getters
#
#' @export
#' @rdname wastdr_settings
get_wastdr_api_url <- function() {
  Sys.getenv("WASTDR_API_URL",
    unset = "https://tsc.dbca.wa.gov.au/api/1/"
  )
}

#' @export
#' @rdname wastdr_settings
get_wastdr_api_token <- function() {
  Sys.getenv("WASTDR_API_TOKEN")
}

#' @export
#' @rdname wastdr_settings
get_wastdr_api_un <- function() {
  Sys.getenv("WASTDR_API_UN")
}

#' @export
#' @rdname wastdr_settings
get_wastdr_api_pw <- function() {
  Sys.getenv("WASTDR_API_PW")
}
