#' Return GeoJSON features from a WAStD API endpoint as data.table or list
#'
#' @description Call the WAStD API serializer's list view with given GET
#'   parameters, parse the response's features into a nested list.
#'   This function requires the WAStD API to return the results in a key
#'   `features` as is the standard for a GeoJSON FeatureCollection.
#' @template param-serializer
#' @param query (list) A list of GET parameters, default: list().
#' @param format (chr) The desired API output format, default: "json".
#' @template param-auth
#' @template return-wastd-api-response
#' @importFrom httr add_headers http_error http_type status_code user_agent
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' track_records <- wastd_GET("turtle-nest-encounters")
#' tag_records <- wastd_GET("animal-encounters")
#' hatched_nest_records <- wastd_GET("turtle-nest-encounters",
#'                        query = list(nest_type = "hatched-nest"))
#' }
wastd_GET <- function(serializer,
                      query = list(),
                      format = "json",
                      api_url = get_wastdr_api_url(),
                      api_token = get_wastdr_api_token(),
                      api_un = get_wastdr_api_un(),
                      api_pw = get_wastdr_api_pw()) {
  . <- NULL

  ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")

  url <- glue::glue(api_url, serializer)

  query <- c(query, list(format = format))

  if (!is.null(api_token)) {
    auth <- httr::add_headers(c(Authorization = api_token))
  } else {
    auth <- httr::authenticate(api_un, api_pw, type = "basic")
  }

  res <- httr::GET(url, auth, ua, query = query)
  message(glue::glue("[wastdr::get_wastd] fetched {res$url}"))

  if (res$status_code == 401) {
    stop(glue::glue(
      "Authorization failed.\n",
      "If you are DBCA staff, run wastdr_setup(api_token='...').\n",
      "You can find your API token under \"My Profile\" in WAStD.\n",
      "External collaborators run ",
      "wastdr::wastdr_setup(api_un='username', api_pw='password').",
      "See ?wastdr_setup or vignette('setup')."
    ),
    call. = FALSE
    )
  }

  if (httr::http_type(res) != "application/json") {
    stop(glue::glue("API did not return JSON.\nIs {url} a valid endpoint?"),
         call. = FALSE
    )
  }

  text <- httr::content(res, as = "text", encoding = "UTF-8")

  if (identical(text, "")) {
    stop("The response did not return any content.", call. = FALSE)
  }

  res_parsed <- jsonlite::fromJSON(text, flatten = F, simplifyVector = F)
  features <- res_parsed$features
  next_url <- res_parsed$`next`

  if (httr::http_error(res)) {
    stop(
      glue::glue(
        "WAStD API request failed [{httr::status_code(res)}]\n",
        "{res_parsed$message",
      ),
      call. = FALSE
    )
  }

  # We assume all errors are now handled and remaining requests will work
  while (!is.null(next_url)) {
    message(glue::glue("[wastdr::get_wastd] fetching {next_url}..."))
    res_parsed <- httr::GET(next_url, auth, ua) %>%
      httr::stop_for_status(.) %>%
      httr::content(., as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(., flatten = F, simplifyVector = F)
    features <- append(features, res_parsed$features)
    next_url <- res_parsed$`next`
  }
  message("[wastdr::get_wastd] done fetching all data.")

  structure(
    list(
      features = features,
      serializer = serializer,
      url = res_parsed$url,
      date = x$res_parsed$headers$date,
      status_code = x$res_parsed$status_code
    ),
    class = "wastd_api_response"
  )
}

#' @title S3 print method for 'wastd_api_response'.
#' @description Prints a short representation of data returned by
#' \code{\link{wastd_GET}}.
#' @param x An object of class `wastd_api_response` as returned by
#'   \code{\link{wastd_GET}}.
#' @param ... Extra parameters for `print`
#' @importFrom utils str
#' @export
print.wastd_api_response <- function(x, ...) {
  glue::glue(
    "<WAStD API response {x$serializer}>\n",
    "URL {x$url}\n",
    "Date {x$date}\n",
    "Status {x$status_code}\n"
  )
  # utils::str(utils::head(x$features))
  invisible(x)
}
