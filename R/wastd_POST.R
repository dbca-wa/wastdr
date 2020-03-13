#' Send a POST request to WAStD's API
#'
#'
#' \lifecycle{stable}
#'
#' @param data (JSON) A list of lists (JSON) to post to WAStD.
#' @template param-serializer
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
                       api_url = wastdr::get_wastdr_api_url(),
                       api_token = wastdr::get_wastdr_api_token(),
                       api_un = wastdr::get_wastdr_api_un(),
                       api_pw = wastdr::get_wastdr_api_pw(),
                       verbose = wastdr::get_wastdr_verbose()) {
  ua <- httr::user_agent("http://github.com/dbca-wa/wastdr")
  url <- paste0(api_url, serializer, "/")

  if (is.null(api_token)) {
    auth <- httr::authenticate(api_un, api_pw, type = "basic")
  } else {
    auth <- httr::add_headers(c(Authorization = api_token))
  }
  if (is.null(auth)) wastdr_msg_warn("No authentication set!")

  if (verbose == TRUE) wastdr_msg_info(glue::glue("[wastd_POST] {url}"))

  res <- httr::POST(url, auth, ua, encode = "json", body = data) %>%
    httr::warn_for_status(.)

  if (res$status_code == 401) {
    stop(glue::glue(
      "Authorization failed.\n",
      "If you are DBCA staff, run wastdr_setup(api_token='Token XXX').\n",
      "You can find your API token under \"My Profile\" in WAStD.\n",
      "External collaborators run ",
      "wastdr::wastdr_setup(api_un='XXX', api_pw='XXX').\n",
      "See ?wastdr_setup or vignette('setup')."
    ),
    call. = FALSE
    )
  }

  if (httr::http_type(res) != "application/json") {
    wastdr_msg_warn(
      glue::glue("API did not return JSON.\nIs {url} a valid endpoint?")
    )
  }

  text <- httr::content(res, as = "text", encoding = "UTF-8")

  res_parsed <- jsonlite::fromJSON(
    text,
    flatten = FALSE,
    simplifyVector = FALSE
  )

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
