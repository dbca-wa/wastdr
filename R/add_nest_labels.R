species_colours <- tibble::tibble(
  species = c(
    "cheloniidae-fam",
    "chelonia-mydas",
    "eretmochelys-imbricata",
    "natator-depressus",
    "corolla-corolla",
    "lepidochelys-olivacea",
    "caretta-caretta"
  ),
  species_colours = c(
    "gray",
    "green",
    "darkblue",
    "beige",
    "pink",
    "darkgreen",
    "orange"
  )
)

nest_type_text <- tibble::tibble(
  nest_type = c(
    "hatched-nest",
    "successful-crawl",
    "track-not-assessed",
    "track-unsure",
    "nest",
    "false-crawl"
  ),
  nest_type_text = c(
    "NH",
    "N",
    "T+?",
    "N?",
    "N",
    "T"
  )
)


#' Add labels for species and nest/track type to parsed
#' \code{turtle-nest-encounters}.
#'
#' \lifecycle{stable}
#'
#' @description Adds two columns, two new columns, \code{species_colours} and
#' \code{nest_type_text}, to parsed \code{turtle-nest-encounters} containing
#' \code{WAStD} \code{species} and \code{nest_type}. The new columns can be used
#' to create \code{leaflet} markers with
#' \code{leaflet::makeAwesomeIcon(
#'   text = ~nest_type_text, markerColor = ~species_colours)}.
#' @param nests (tibble) A dataframe or tibble of parsed
#'   \code{turtle-nest-encounters}.
#' @return The dataframe with two new columns, \code{species_colours} and
#'   \code{nest_type_text}.
#' @family wastd
#' @export
add_nest_labels <- function(nests) {
  nests %>%
    dplyr::left_join(species_colours, by = "species") %>%
    dplyr::left_join(nest_type_text, by = "nest_type")
}

#' Add labels for species and nest/track type to parsed
#' \code{turtle-nest-encounters} from ODK Central.
#'
#' \lifecycle{stable}
#'
#' @description Adds two columns, two new columns, \code{species_colours} and
#' \code{nest_type_text}, to parsed \code{turtle-nest-encounters} containing
#' \code{WAStD} \code{species} and \code{nest_type}. The new columns can be used
#' to create \code{leaflet} markers with
#' \code{leaflet::makeAwesomeIcon(
#'   text = ~nest_type_text, markerColor = ~species_colours)}.
#' @param nests (tibble) A dataframe or tibble of parsed
#'   \code{turtle-nest-encounters}.
#' @return The dataframe with two new columns, \code{species_colours} and
#'   \code{nest_type_text}.
#' @family odkc
#' @export
add_nest_labels_odkc <- function(nests) {
  nests %>%
    dplyr::left_join(species_colours, by = c("details_species" = "species")) %>%
    dplyr::left_join(nest_type_text, by = c("details_nest_type" = "nest_type"))
}
