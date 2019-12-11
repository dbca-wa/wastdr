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
