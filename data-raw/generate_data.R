# Generate animal_encounters ("observed" by author)
library(wastdr)
q <- list(taxon = "Cheloniidae", area_id = 17, observer = 4)
animal_encounters <- wastd_GET("animal-encounters", query = q)
animals <- parse_animal_encounters(animal_encounters)
usethis::use_data(animal_encounters, compress = "xz", overwrite = TRUE)
usethis::use_data(animals, compress = "xz", overwrite = TRUE)

# Generate tne, tracks
q <- list(taxon = "Cheloniidae", area_id = 17, observer = 4)
tne <- wastdr::wastd_GET("turtle-nest-encounters", query = q)
nests <- parse_turtle_nest_encounters(tne)
usethis::use_data(tne, compress = "xz", overwrite = TRUE)
usethis::use_data(nests, compress = "xz", overwrite = TRUE)

# TODO generate odkc data
library(turtleviewer)
turtledata <- data(turtledata, package="turtleviewer")
odkc <- list(
    tracks = head(turtledata$tracks),
    tracks_dist = head(turtledata$tracks_dist),
    tracks_egg = head(turtledata$tracks_egg),
    tracks_log = head(turtledata$tracks_log),
    tracks_hatch = head(turtledata$tracks_hatch),
    tracks_fan_outlier = head(turtledata$tracks_fan_outlier),
    dist = head(turtledata$dist),
    mwi = head(turtledata$mwi),
    mwi_dmg = head(turtledata$mwi_dmg),
    mwi_tag = head(turtledata$mwi_tag),
    svs = head(turtledata$svs),
    sve = head(turtledata$sve),
    sites = turtledata$sites,
    areas = turtledata$areas
)
usethis::use_data(odkc, compress="xz", overwrite=TRUE)

