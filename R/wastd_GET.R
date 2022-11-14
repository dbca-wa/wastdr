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
#' @param parse Whether to parse data (TRUE) or not (FALSE, default).
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
                      parse = FALSE,
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
  limit <- ifelse(is.null(max_records),
    chunk_size,
    min(max_records, chunk_size)
  )
  query <- c(query, list(format = format, limit = limit))
  auth <-
    build_auth(
      api_token = api_token,
      api_un = api_un,
      api_pw = api_pw
    )

  # Infer parsing function from serializer name
  if (parse == TRUE) {
    parse_fn <- dplyr::case_when(
      serializer == "area" ~ "parse_area_sf",
      serializer == "surveys" ~ "parse_surveys",
      serializer == "animal-encounters" ~ "parse_animal_encounters",
      serializer == "turtle-nest-encounters" ~ "parse_turtle_nest_encounters",
      serializer %in% c(
        "turtle-morphometrics",
        "turtle-damage-observations",
        "turtle-nest-disturbance-observations",
        "nest-tag-observations",
        "tag-observations",
        "turtle-nest-excavations",
        "turtle-hatchling-morphometrics",
        "turtle-nest-hatchling-emergences",
        "turtle-nest-hatchling-emergence-outliers",
        "turtle-nest-hatchling-emergence-light-sources",
        "logger-observations",
        "track-tally",
        "turtle-nest-disturbance-tally"
      ) ~ "parse_encounterobservations",
      serializer %in% c(
        "encounters-fast",
        "survey-media-attachments"
      ) ~ "wastd_parse",
      TRUE ~ "wastd_parse"
    )
    "Parsing with {parse_fn}" %>%
      glue::glue() %>%
      wastdr::wastdr_msg_info()
  }

  # First batch of results and error handling
  "Fetching {url}" %>%
    glue::glue() %>%
    wastdr_msg_info(verbose = verbose)

  # Polite RETRY parameters: try 10 times, pause 10 secs, increase to 10 mins
  res <- httr::RETRY(
    verb = "GET",
    url,
    auth,
    ua,
    query = query,
    times = 10,
    quiet = FALSE,
    pause_min = 3,
    pause_cap = 60
  )

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
  data_key <- ifelse("features" %in% names(res_parsed), "features", "results")

  if (parse == TRUE) {
    features <- match.fun(parse_fn)(res_parsed, payload = data_key)
    next_url <- res_parsed$`next`
    total_count <- nrow(features)
  } else {
    features <- res_parsed[[data_key]]
    next_url <- res_parsed$`next`
    total_count <- length(features)
  }

  if (!(data_key %in% names(res_parsed))) {
    return(structure(
      list(
        data = features,
        serializer = serializer,
        url = res$url,
        date = res$headers$date,
        status_code = res$status_code,
        parsed = parse
      ),
      class = "wastd_api_response"
    ))
  }

  # Unless we already have reached our desired max_records in the first page
  # of results, loop over paginated response until we either hit the end of
  # the server side data (next_url is Null) or our max_records.
  if (get_more(total_count, max_records) == TRUE) {
    while (!is.null(next_url) &&
      get_more(total_count, max_records) == TRUE) {
      wastdr::wastdr_msg_info(glue::glue("Fetching {next_url}"))

      next_res <-
        httr::RETRY(
          verb = "GET",
          next_url,
          auth,
          ua,
          times = 3,
          times = 10,
          quiet = FALSE,
          pause_min = 3,
          pause_cap = 60
        ) %>%
        httr::warn_for_status(.) %>%
        httr::content(., as = "text", encoding = "UTF-8") %>%
        {
          if (format == "json") {
            jsonlite::fromJSON(.,
              flatten = FALSE,
              simplifyVector = FALSE
            )
          } else {
            .
          }
        }

      data_key <-
        ifelse("features" %in% names(next_res), "features", "results")


      if (parse == TRUE) {
        # Next batch of results, parsed
        next_res_parsed <- match.fun(parse_fn)(next_res, payload = data_key)

        # Rbind tibbles
        features <- dplyr::bind_rows(features, next_res_parsed)

        # Total count of rows in tibble "features"
        total_count <- nrow(features)
      } else {
        # Append new batch of features (list of lists)
        features <- append(features, next_res[[data_key]])

        # Total count of items in list "features"
        total_count <- length(features)
      }

      next_url <- next_res$`next`
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
      status_code = res$status_code,
      parsed = parse
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
      "Data: {ifelse(x$parse, length(x$data), nrow(data))}\n"
    )
  )
  invisible(x)
}

# usethis::use_test("wastd_GET") # nolint
