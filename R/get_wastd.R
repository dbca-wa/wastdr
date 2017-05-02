#' Return GeoJSON features from a WAStD API endpoint as data.table or list
#'
#' @description Call the WAStD API serializer's list view with given GET parameters,
#'   parse the response as text into a GeoJSON FeatureCollection.
#'   Parse the FeatureCollection using jsonlite::fromJSON and return its features
#'   as nested data.frame (simplify=TRUE) or as list of lists (simplify=FALSE).
#'   TODO: use pagination, see
#'   \url{https://cran.r-project.org/web/packages/jsonlite/vignettes/json-paging.html}
#' @param serializer (character) WAStD API serializer name (required).
#'   Possible values as per
#'   \code{https://strandings.dpaw.wa.gov.au/api/1/?format=corejson} are:
#'   \itemize{
#'   \item encounters (all encounters, but only core fields)
#'   \item animal-encounters (strandings, tagging)
#'   \item turtle-nest-encounters (tracks and nests)
#'   \item logger-encounters (temp and other loggers)
#'   \item areas (polygons of known areas)
#'   \item media-attachments (photos, data sheets etc)
#'   \item nesttag-observations (sightings of nest tags)
#'   \item tag-observations (tag observations during encounters)
#'   }
#' @param query (list) API query parameters for format, limit, filtering
#'   (default: list(taxon='Cheloniidae', limit=10000, format='json'))
#' @param api_url (character) The WAStD API URL,
#'   default \code{\link{get_wastdr_api_url}}, see \code{\link{wastdr_setup}}
#' @param api_token (character) The WAStD API token,
#'   default \code{\link{get_wastdr_api_token}}, see \code{\link{wastdr_setup}}
#' @param simplify (Boolean) Whether to flatten nested data frames into a single
#'   data frame with repeating unnamed groups as lists (simplify = TRUE), or as
#'   list of lists (default: FALSE)
#' @importFrom httr add_headers http_error http_type status_code user_agent
#' @importFrom jsonlite fromJSON
#'
#' @return An S3 object of class 'wastd_api_response' containing:
#'
#'   content: The retrieved GeoJSON features as data.table or list
#'
#'   serializer: The called serializer, e.g. 'animal-encounters'
#'
#'   response: The API HTTP response with all metadata
#' @export
#'
#' @examples \dontrun{
#' track_records <- get_wastd('turtle-nest-encounters')
#'
#' tag_records <- get_wastd('animal-encounters')
#'
#' nest_json <- get_wastd('turtle-nest-encounters',
#'                        query=list(
#'                          nest_type='hatched-nest',
#'                          limit=10000,
#'                          format='json'))
#' }
get_wastd <- function(serializer,
                      query = list(taxon = "Cheloniidae",
                                   limit = 10000,
                                   format = "json"),
                      api_url = get_wastdr_api_url(),
                      api_token = get_wastdr_api_token(),
    simplify = FALSE) {

    ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")

    url <- paste0(api_url, serializer)

    res <- httr::GET(url,
                     ua,
                     query = query,
                     httr::add_headers(c(Authorization = api_token)))
    # %>% httr::stop_for_status()

    if (res$status_code == 401) {
        stop(paste("Authorization failed.\n",
                   "Set your WAStD API token as system variable with",
                   "Sys.setenv(WASTD_APITOKEN=\"Token MY-WASTD-API-TOKEN\").\n",
                   "You can find your API token under \"My Profile\" in WAStD."),
            call. = FALSE)
    }

    if (httr::http_type(res) != "application/json") {
        stop(paste("API did not return JSON.\nIs", url, "a valid endpoint?"),
             call. = FALSE)
    }

    text <- httr::content(res, as = "text", encoding = "UTF-8")

    if (identical(text, "")) {
        stop("The response did not return any content.", call. = FALSE)
    }

    parsed <- jsonlite::fromJSON(text,
                                 flatten = simplify,
                                 simplifyVector = simplify)$features

    if (httr::http_error(res)) {
        stop(sprintf("WAStD API request failed [%s]\n%s\n<%s>",
                     httr::status_code(res),
                     parsed$message),
             call. = FALSE)
    }

    structure(
        list(
            content = parsed,
            serializer = serializer,
            response = res
            ),
        class = "wastd_api_response"
        )

}

#' @title S3 print method for 'wastd_api_response'.
#' @description Prints a short representation of data returned by \
#'   code{\link{get_wastd}}.
#' @param x An object of class `wastd_api_response` as returned by
#'   \code{\link{get_wastd}}.
#' @param ... Extra parameters for `print`
#' @importFrom utils str
#' @export
print.wastd_api_response <- function(x, ...) {
    cat("<WAStD API endpoint", x$serializer, ">\n",
        "Retrieved on ", x$response$headers$date, ">\n", sep = "")
    utils::str(x$content)
    invisible(x)
}
