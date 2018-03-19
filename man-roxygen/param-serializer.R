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
#'   \item taxa (WACensus taxa)
#'   }
