#' Post a list of records to a WAStD or TSC API endpoint
#'
#' \lifecycle{maturing}
#'
#' @param data A tibble of a data with columns equal to the serializer's
#'   fields.
#' @template param-serializer
#' @param encode The parameter \code{encode} for \code{link{httr::POST}},
#'   default: "json".
#'   Other options: \code{c("multipart", "form", "json", "raw")}.
#' @template param-auth
#' @template param-verbose
#' @return The list of \code{wastd_api_response}s from \code{\link{wastd_POST}}
#' @family("api")
#' @export
#' @examples
#' \dontrun{
#' odkc_data$tracks %>%
#'   odkc_tracks_as_wastd_tne() %>%
#'   wastd_bulk_post("turtle-nest-encounters")
#' }
wastd_bulk_post <- function(data,
                            serializer,
                            encode = "json",
                            api_url = wastdr::get_wastdr_api_url(),
                            api_token = wastdr::get_wastdr_api_token(),
                            api_un = wastdr::get_wastdr_api_un(),
                            api_pw = wastdr::get_wastdr_api_pw(),
                            verbose = FALSE) {
  apply(data,
    1,
    wastd_post_one,
    serializer = serializer,
    encode = encode,
    api_url = api_url,
    api_token = api_token,
    api_un = api_un,
    api_pw = api_pw,
    verbose = verbose
  )
}

# usethis::use_test("wastd_bulk_post")
