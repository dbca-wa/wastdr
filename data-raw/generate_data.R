# Generate animal_encounters ("observed" by author)
q = list(taxon = "Cheloniidae", limit = 10, format = "json", observer = 1)
animal_encounters <- get_wastd("animal-encounters", query = q)
animals <- parse_animal_encounters(animal_encounters)
devtools::use_data(animal_encounters, overwrite = TRUE)
devtools::use_data(animals, overwrite = TRUE)

# Generate turtle_nest_encounters_hatched
q = list(taxon = "Cheloniidae", limit = 10, format = "json", nest_type = "hatched-nest")
turtle_nest_encounters_hatched <- wastdr::get_wastd("turtle-nest-encounters", query = q)
anonymize <- function(dict){
   anon = list(name="Test Name", username="test_name", email="test@email.com", phone = "")
   dict$properties <- dict$properties %>% purrr::update_list(observer = anon, reporter = anon)
   dict}
turtle_nest_encounters_hatched$content <- turtle_nest_encounters_hatched$content %>% map(anonymize)
# listviewer::jsonedit(turtle_nest_encounters_hatched$content)
nests <- parse_turtle_nest_encounters(turtle_nest_encounters_hatched)
# DT::datatable(nests)
devtools::use_data(turtle_nest_encounters_hatched, overwrite = TRUE)
devtools::use_data(nests, overwrite = TRUE)

# Generate turtle_nest_encounters_hatched
q = list(taxon = "Cheloniidae", limit = 100, format = "json")
turtle_nest_encounters <- wastdr::get_wastd("turtle-nest-encounters", query = q)
anonymize <- function(dict){
    dummy = list(name = "Test Name",
             username = "test_name",
             email = "test@email.com",
             phone = "")
    dict$properties <- dict$properties %>%
        purrr::update_list(observer = dummy, reporter = dummy)
    dict
}
turtle_nest_encounters$content <- turtle_nest_encounters$content %>% map(anonymize)
# listviewer::jsonedit(turtle_nest_encounters$content)
tracks <- parse_turtle_nest_encounters(turtle_nest_encounters)
# DT::datatable(tracks)
devtools::use_data(turtle_nest_encounters, overwrite = TRUE)
devtools::use_data(tracks, overwrite = TRUE)
}
