# Generate animal_encounters ("observed" by author)
library(wastdr)
q = list(taxon = "Cheloniidae", format = "json", observer=1)
animal_encounters <- get_wastd("animal-encounters", query = q)
animals <- parse_animal_encounters(animal_encounters)
devtools::use_data(animal_encounters, overwrite = TRUE)
devtools::use_data(animals, overwrite = TRUE)

# Generate turtle_nest_encounters
q = list(taxon = "Cheloniidae", format = "json", nest_type = "hatched-nest", observer=1)
turtle_nest_encounters_hatched <- wastdr::get_wastd("turtle-nest-encounters", query = q)
nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
devtools::use_data(turtle_nest_encounters_hatched, overwrite = TRUE)
devtools::use_data(nests, overwrite = TRUE)

# Generate turtle_nest_encounters_hatched
q = list(taxon = "Cheloniidae", limit = 100, format = "json", observer=1)
turtle_nest_encounters <- wastdr::get_wastd("turtle-nest-encounters", query = q)
tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
devtools::use_data(turtle_nest_encounters, overwrite = TRUE)
devtools::use_data(tracks, overwrite = TRUE)
