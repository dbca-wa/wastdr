#' Return a GeoJSON Featurecollection from an OGC WFS 2.0.0 endpoint
#'
#' Defaults to DBCA's KMI GeoServer offering public WACensus views
#' @param layer_name The GeoServer layer name, default: "public:herbie_hbvsupra_public"
#' @param url The GeoServer URL, default: "https://kmi.dbca.wa.gov.au/geoserver/dpaw/ows"
#' @return The httr::content of a GET request to the WFS GetFeature endpoint
#' @importFrom httr content GET user_agent
#' @export
gs_getFeature <- function(
    layer_name = "public:herbie_hbvsupra_public",
    url = "https://kmi.dbca.wa.gov.au/geoserver/dpaw/ows") {
  . <- NULL
  ua <- httr::user_agent("http://github.com/dbca-wa/scarab-scripts")
  url <- "https://kmi.dbca.wa.gov.au/geoserver/public/ows"
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typeName = layer_name,
    outputFormat = "application/json"
  )
  url %>% httr::GET(ua, query = query) %>% httr::content(.)
}
