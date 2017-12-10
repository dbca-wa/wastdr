#' Return GeoJSON features from a WAStD API endpoint as data.table or list
#'
#' @description Call the WAStD API serializer's list view with given GET parameters,
#'   parse the response as text into a GeoJSON FeatureCollection.
#'   Parse the FeatureCollection using jsonlite::fromJSON and return its features
#'   as nested data.frame (simplify=TRUE) or as list of lists (simplify=FALSE).
#'   TODO: use pagination, see the vignette on paging at
#'   \url{https://CRAN.R-project.org/package=jsonlite}.
#' @param serializer (character) WAStD API serializer name (required)
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
#'   (default: list(taxon='Cheloniidae', format='json'))
#' @param api_url (character) The WAStD API URL,
#'   default \code{\link{get_wastdr_api_url}}, see \code{\link{wastdr_setup}}
#' @param api_token (character) The WAStD API token,
#'   default \code{\link{get_wastdr_api_token}}, see \code{\link{wastdr_setup}}
#' @param api_un (character) A WAStD API username,
#'   default \code{\link{get_wastdr_api_un}}, see \code{\link{wastdr_setup}}
#' @param api_pw (character) A WAStD API password,
#'   default \code{\link{get_wastdr_api_pw}}, see \code{\link{wastdr_setup}}
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
#'                        query=list(nest_type='hatched-nest', format='json'))
#' }
get_wastd <- function(serializer,
                      query = list(
                          taxon = "Cheloniidae",
                          format = "json"),
                      api_url = get_wastdr_api_url(),
                      api_token = get_wastdr_api_token(),
                      api_un = get_wastdr_api_un(),
                      api_pw = get_wastdr_api_pw(),
                      simplify = FALSE) {

    . <- NULL # Silence R CMD CHECK warning

    ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")

    url <- paste0(api_url, serializer)

    if (!is.null(api_token)) {
        auth <- httr::add_headers(c(Authorization = api_token))
    } else {
        auth <- httr::authenticate(api_un, api_pw, type = "basic")
    }

    res <- httr::GET(url, auth, ua, query = query)
    message(paste("[wastdr::get_wastd] fetched", res$url))

    if (res$status_code == 401) {
        stop(paste(
            "Authorization failed.\n",
            "If you are DBCA staff, run wastdr_setup(api_token='...').\n",
            "You can find your API token under \"My Profile\" in WAStD.\n",
            "External collaborators run ",
            "wastdr::wastdr_setup(api_un='username', api_pw='password').",
            "See ?wastdr_setup or vignette('setup')."),
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

    res_parsed <- jsonlite::fromJSON(text, flatten = F, simplifyVector = F)
    features <- res_parsed$features
    next_url <- res_parsed$`next`

    if (httr::http_error(res)) {
        stop(sprintf("WAStD API request failed [%s]\n%s\n<%s>",
                     httr::status_code(res),
                     res_parsed$message),
             call. = FALSE)
    }

    # We assume all errors are now handled and remaining requests will work
    while (!is.null(next_url)) {
        message(paste("[wastdr::get_wastd] fetching", next_url, "..."))
        res_parsed <- httr::GET(next_url,auth, ua) %>%
            httr::stop_for_status(.) %>%
            httr::content(., as = "text", encoding = "UTF-8") %>%
            jsonlite::fromJSON(., flatten = F, simplifyVector = F)
        features = append(features, res_parsed$features)
        next_url <- res_parsed$`next`
    }
    message("[wastdr::get_wastd] done fetching all data.")

    structure(
        list(
            features = features,
            serializer = serializer,
            response = res
            ),
        class = "wastd_api_response"
        )

}

#' @title S3 print method for 'wastd_api_response'.
#' @description Prints a short representation of data returned by
#' \code{\link{get_wastd}}.
#' @param x An object of class `wastd_api_response` as returned by
#'   \code{\link{get_wastd}}.
#' @param ... Extra parameters for `print`
#' @importFrom utils str
#' @export
print.wastd_api_response <- function(x, ...) {
    cat("<WAStD API endpoint", x$serializer, ">\n",
        "Retrieved on ", x$response$headers$date, ">\n", sep = "")
    utils::str(utils::head(x$features))
    invisible(x)
}
