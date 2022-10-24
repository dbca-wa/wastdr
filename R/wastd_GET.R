#' Return GeoJSON features from a WAStD API endpoint
#'
#' \lifecycle{stable}
#'
#' @description Call the WAStD API serializer's list view with given GET
#'   parameters, parse the response's features into a nested list.
#'   This function requires the WAStD API to return the results in a key
#'   `features` (if GeoJSON) or `data` (if JSON).
#'
#' @template param-serializer
#' @param query A list of GET parameters, default: list().
#'   The \code{format} is specified in a separate top-level param.
#' @param format The desired API output format, default: "json".
#' @param max_records The maximum number of records retrieved.
#'   If left at default (NULL), all records are returned.
#'   Default: NULL.
#' @param chunk_size The number of records to retrieve in each paginated
#'   response. A specified but smaller \code{limit} will override
#'   \code{chunk_size}.
#'   Adjust \code{chunk_size} down if getting timeouts from the API.
#'   Default: 1000.
#' @template param-auth
#' @template param-verbose
#' @template return-wastd-api-response
#' @export
#' @family api
#' @examples
#' \dontrun{
#' track_records <- wastd_GET("turtle-nest-encounters")
#' tag_records <- wastd_GET("animal-encounters")
#' hatched_nest_records <- wastd_GET("turtle-nest-encounters",
#'   query = list(nest_type = "hatched-nest")
#' )
#' }
wastd_GET <- function(serializer,
                      query = list(),
                      format = "json",
                      max_records = NULL,
                      chunk_size = 1000,
                      api_url = get_wastdr_api_url(),
                      api_token = get_wastdr_api_token(),
                      api_un = get_wastdr_api_un(),
                      api_pw = get_wastdr_api_pw(),
                      verbose = wastdr::get_wastdr_verbose()) {
  # Prep and gate checks
  ua <- httr::user_agent("http://github.com/dbca-wa/wastdr")
  url_parts <- httr::parse_url(api_url)
  url_parts["path"] <- paste0(url_parts["path"], serializer)
  url <- httr::build_url(url_parts)
  limit <- ifelse(
    is.null(max_records),
    chunk_size,
    min(max_records, chunk_size)
  )
  query <- c(query, list(format = format, limit = limit))
  auth <- build_auth(api_token = api_token, api_un = api_un, api_pw = api_pw)

  # First batch of results and error handling
  "Fetching {url}" %>%
    glue::glue() %>%
    wastdr_msg_info(verbose = verbose)
  res <- httr::RETRY(verb = "GET", url, auth, ua, query = query, times = 3)

  handle_http_status(res, verbose = verbose)

  res_parsed <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    {
      if (format == "json") {
        jsonlite::fromJSON(., flatten = FALSE, simplifyVector = FALSE)
      } else {
        .
      }
    }

  # GeoJSON serializer returns records as "features"
  # OffsetLimitPagination serializer returns records as "results"
  data_key <-
    ifelse("features" %in% names(res_parsed), "features", "results")

  if (!(data_key %in% names(res_parsed))) {
    return(
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
    )
  }

  features <- res_parsed[[data_key]]
  next_url <- res_parsed$`next`
  total_count <- length(features)

  # Unless we already have reached our desired max_records in the first page of
  # results, loop over paginated response until we either hit the end of the
  # server side data (next_url is Null) or our max_records.
  if (get_more(total_count, max_records) == TRUE) {
    while (!is.null(next_url) &&
      get_more(total_count, max_records) == TRUE) {
      wastdr::wastdr_msg_info(glue::glue("Fetching {next_url}"))
      next_res <- httr::RETRY(verb = "GET", next_url, auth, ua, times = 3) %>%
        httr::warn_for_status(.) %>%
        httr::content(., as = "text", encoding = "UTF-8") %>%
        {
          if (format == "json") {
            jsonlite::fromJSON(., flatten = FALSE, simplifyVector = FALSE)
          } else {
            .
          }
        }

      features <- append(features, next_res[[data_key]])
      next_url <- next_res$`next`
      total_count <- length(features)
    }
  }

  "Done fetching {res$url}" %>%
    glue::glue() %>%
    wastdr_msg_success(verbose = verbose)

  structure(
    list(
      data = features,
      serializer = serializer,
      url = res$url,
      date = res$headers$date,
      status_code = res$status_code
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
#' @export
#' @family wastd
print.wastd_api_response <- function(x, ...) {
  print(
    glue::glue(
      "<WAStD API response \"{x$serializer}\">\n",
      "URL: {x$url}\n",
      "Date: {x$date}\n",
      "Status: {x$status_code}\n",
      "Data: {length(x$data)}\n"
    )
  )
  invisible(x)
}

# usethis::use_test("wastd_GET") # nolint
