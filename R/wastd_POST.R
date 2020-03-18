#' Send a POST request to WAStD's API
#'
#'
#' \lifecycle{stable}
#'
#' @param data (JSON) A list of lists (JSON) to post to WAStD.
#' @template param-serializer
#' @param query <list> A list of POST parameters,
#'   default: \code{list(format="json")}.
#' @param encode The parameter \code{encode} for \code{link{httr::POST}},
#'   default: "json".
#'   Other options: \code{c("multipart", "form", "json", "raw")}.
#' @template param-auth
#' @template param-verbose
#' @template return-wastd-api-response
#' @export
#' @family api
#' @examples
#' \dontrun{
#' # One by one
#' gj <- "public:herbie_hbvnames_public" %>% kmi_getFeature()
#' props <- purrr::map(gj[["features"]], "properties")
#' wastd_POST(props[[1]], serializer = "names")
#'
#' # All in batch
#' "public:herbie_hbvnames_public" %>%
#'   kmi_getFeature() %>%
#'   wastd_upsert_geojson(serializer = "names", verbose = T)
#' }
wastd_POST <- function(data,
                       serializer,
                       query = list(format="json"),
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

  if (verbose == TRUE) wastdr_msg_info(glue::glue("[wastd_POST] {url}"))

  res <- httr::POST(url, auth, ua, encode = encode, body = data, query = query)

  handle_http_status(res)

  text <- httr::content(res, as = "text", encoding = "UTF-8")

  if (httr::http_type(res) == "application/json"){
  res_parsed <- jsonlite::fromJSON(
    text,
    flatten = FALSE,
    simplifyVector = FALSE
  )} else res_parsed <- text

  if (verbose == TRUE) {
    wastdr_msg_success(glue::glue("[wastd_POST] {res$status}"))
  }

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
