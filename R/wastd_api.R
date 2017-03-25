#' Return GeoJSON features from a WAStD API endpoint as data.table or list
#'
#' @param serializer (character) WAStD API serializer name (required)
#' @param base_url (character) Name of the new resource
#'   (default: 'https://strandings.dpaw.wa.gov.au/api/1/')
#' @param query (list) API query parameters for format, limit, filtering
#'   (default: list(taxon='Cheloniidae', limit=10000, format='json'))
#' @param wastd_api_token (character) The WAStD API token
#'   (default: Sys.getenv('WASTD_APITOKEN'))
#' @param simplify (Boolean) Whether to flatten nested data frames into a single
#'   data frame with repeating unnamed groups as lists (default: TRUE), or as
#'   list of lists (simplify=FALSE)
#' @details Call the WAStD API serializer's list view with given GET parameters,
#' parse the response as text into a GeoJSON FeatureCollection.
#' Parse the FeatureCollection using jsonlite::fromJSON and return its features
#' as nested data.frame (simplify=TRUE) or as list of lists (simplify=FALSE).
#' TODO: use pagination, see
#' https://cran.r-project.org/web/packages/jsonlite/vignettes/json-paging.html
#' @importFrom httr add_headers http_error http_type status_code user_agent
#' @importFrom jsonlite fromJSON
#'
#' @return An S3 object of class 'wastd_api' containing:
#'   content: The retrieved GeoJSON features as data.table or list
#'   serializer: The called serializer, e.g. 'animal-encounters'
#'   response: The API HTTP response with all metadata
#' @export
#'
#' @examples \dontrun{
#' track_records <- wastd_api('turtle-nest-encounters')
#'
#' tag_records <- wastd_api('animal-encounters')
#'
#' nest_json <- wastd_api('turtle-nest-encounters',
#'                        query=list(
#'                          nest_type='hatched-nest',
#'                          limit=10000,
#'                          format='json'),
#'                        simplify=FALSE)
#' }
wastd_api <- function(serializer, base_url = "https://strandings.dpaw.wa.gov.au/api/1/", query = list(taxon = "Cheloniidae", limit = 10000, format = "json"), 
    wastd_api_token = Sys.getenv("WASTD_APITOKEN"), simplify = TRUE) {
    
    ua <- httr::user_agent("http://github.com/parksandwildlife/turtle-scripts")
    
    url <- paste0(base_url, serializer)
    
    res <- httr::GET(url, ua, query = query, httr::add_headers(c(Authorization = wastd_api_token)))
    # %>% httr::stop_for_status()
    
    if (res$status_code == 401) {
        stop(paste("Authorization failed. \n", "Set your WAStD API token as system variable with", "Sys.setenv(WASTD_APITOKEN=\"Token MY-WASTD-API-TOKEN\").", 
            "You can find your API token under \"My Profile\" in WAStD."), call. = FALSE)
    }
    
    if (httr::http_type(res) != "application/json") {
        stop(paste("API did not return JSON.\nIs", url, "a valid endpoint?"), call. = FALSE)
    }
    
    text <- httr::content(res, as = "text", encoding = "UTF-8")
    
    if (identical(text, "")) {
        stop("The response did not return any content.", call. = FALSE)
    }
    
    parsed <- jsonlite::fromJSON(text, flatten = simplify, simplifyVector = simplify)$features
    
    if (httr::http_error(res)) {
        stop(sprintf("WAStD API request failed [%s]\n%s\n<%s>", httr::status_code(res), parsed$message), call. = FALSE)
    }
    
    
    structure(list(content = parsed, serializer = serializer, response = res), class = "wastd_api")
    
}

#' @title S3 print method for 'wastd_api'.
#' @description Prints a short representation of data returned by `wastd_api`.
#' @param x An object of class `wastd_api` as returned by `wastd_api`.
#' @param ... Extra parameters for `print`
#' @importFrom utils str
#' @export
print.wastd_api <- function(x, ...) {
    cat("<WAStD API endpoint", x$serializer, ">\n", "Retrieved on ", x$response$headers$date, ">\n", sep = "")
    utils::str(x$content)
    invisible(x)
}
