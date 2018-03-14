# Generate animal_encounters ("observed" by author)
library(wastdr)
q <- list(taxon = "Cheloniidae", format = "json", observer = 4)
animal_encounters <- wastd_GET("animal-encounters", query = q)
animals <- parse_animal_encounters(animal_encounters)
devtools::use_data(animal_encounters, overwrite = TRUE)
devtools::use_data(animals, overwrite = TRUE)

# Generate tne, tracks
q <- list(taxon = "Cheloniidae", format = "json", observer = 4)
tne <- wastdr::wastd_GET("turtle-nest-encounters", query = q)
nests <- parse_turtle_nest_encounters(tne)
devtools::use_data(tne, overwrite = TRUE)
devtools::use_data(nests, overwrite = TRUE)

# Generate turtle_nest_encounters
# q <- list(taxon = "Cheloniidae", limit = 100, format = "json", observer = 4)
# turtle_nest_encounters <- wastdr::get_wastd("turtle-nest-encounters", query = q)
# tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
# devtools::use_data(turtle_nest_encounters, overwrite = TRUE)
# devtools::use_data(tracks, overwrite = TRUE)
