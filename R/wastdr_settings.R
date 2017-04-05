#' Get or set wastdr WAStD settings
#'
#' @export
#' @return \code{wastdr_settings} prints your base url and WAStD API key.
#' \code{ckanr_setup} sets your production and test settings, while
#' @seealso \code{\link{wastdr_setup}},
#' \code{\link{get_wastdr_api_url}}, \code{\link{get_wastdr_api_token}}.
#' @family wastr settings
#' @examples
#' wastdr_settings()
wastdr_settings <- function() {
    ops <- list(api_url = Sys.getenv("WASTDR_API_URL", ""),
                api_token = Sys.getenv("WASTDR_API_TOKEN", ""))
    structure(ops, class = "wastdr_settings")
}

#' @export
print.wastdr_settings <- function(x, ...) {
    cat("<wastdr settings>", sep = "\n")
    cat("  API URL: ", x$api_url, "\n")
    cat("  API Token: ", x$api_token, "\n")
}

#------------------------------------------------------------------------------#
# Setters
#
#' Configure default WAStD settings
#'
#' @export
#' @param api_url A WAStD API URL (optional),
#'   default: "https://strandings.dpaw.wa.gov.au/api/1/"
#' @param api_token A CKAN API token (required, character)
#' @details
#' \code{wastdr_setup} sets WAStD API connection details. \code{wastdr}'s
#' functions default to use the default URL, but require an API key to work.
#' @examples
#' # WAStD users can run:
#' wastdr_setup(api_url = "https://strandings.dpaw.wa.gov.au/api/1/",
#'              api_token = "c12345asdfqwer")
#'
#' # Not specifying the default WAStD API URL will reset the WAStD URL to its
#' # default "https://strandings.dpaw.wa.gov.au/api/1/":
#' wastdr_setup(api_token = "c12345asdfqwer")
wastdr_setup <- function(
    api_url = "https://strandings.dpaw.wa.gov.au/api/1/",
    api_token = NULL) {

    Sys.setenv("WASTDR_API_URL" = api_url)
    if (!is.null(api_token)) {
        Sys.setenv("WASTDR_API_TOKEN" = paste("Token", api_token))
    }
}

#------------------------------------------------------------------------------#
# Getters
#
#' @export
#' @rdname wastdr_settings
get_wastdr_api_url <- function(){ Sys.getenv("WASTDR_API_URL") }

#' @export
#' @rdname wastdr_settings
get_wastdr_api_token <- function(){ Sys.getenv("WASTDR_API_TOKEN") }
