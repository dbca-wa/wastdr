#' Send a POST request to WAStD's API
#'
#'
#' \lifecycle{stable}
#'
#' @param data (JSON) A list of lists (JSON) to post to WAStD.
#' @template param-serializer
#' @param query (list) A list of POST parameters,
#'   default: `list(format="json")`.
#' @param encode The parameter `encode` for `\link{httr::POST}`,
#'   default: "json".
#'   Other options: `c("multipart", "form", "json", "raw")`.
#' @template param-auth
#' @template param-verbose
#' @template return-wastd-api-response
#' @export
#' @family api
#' @examples
#' \dontrun{
#' }
wastd_POST <- function(data,
                       serializer,
                       query = list(format = "json"),
                       encode = "json",
                       api_url = wastdr::get_wastdr_api_url(),
                       api_token = wastdr::get_wastdr_api_token(),
                       api_un = wastdr::get_wastdr_api_un(),
                       api_pw = wastdr::get_wastdr_api_pw(),
                       verbose = wastdr::get_wastdr_verbose()) {
  ua <- httr::user_agent("http://github.com/dbca-wa/wastdr")
  url_parts <- httr::parse_url(api_url)
  url_parts["path"] <- glue::glue("{url_parts['path']}{serializer}/")
  url <- httr::build_url(url_parts)
  auth <- build_auth(api_token = api_token, api_un = api_un, api_pw = api_pw)

  "[wastd_POST] {url}" %>%
    glue::glue() %>%
    wastdr_msg_info(verbose = verbose)

  res <- httr::POST(url, auth, ua, encode = encode, body = data, query = query)

  handle_http_status(res, verbose = verbose)

  text <- httr::content(res, as = "text", encoding = "UTF-8")

  if (httr::http_type(res) == "application/json") {
    res_parsed <- jsonlite::fromJSON(
      text,
      flatten = FALSE,
      simplifyVector = FALSE
    )
  } else {
    res_parsed <- text
  }

  "[wastd_POST] {res$status}" %>%
    glue::glue() %>%
    wastdr_msg_success(verbose = verbose)

  structure(
    list(
      data = res_parsed,
      serializer = serializer,
      url = res$url,
      date = res$headers$date,
      status_code = res$status_code
    ),
    class = "wastd_api_response"
  )
}

# usethis::use_test("wastd_POST")
