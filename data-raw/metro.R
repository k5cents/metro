## code to prepare `metro` datasets goes here
library(metro)

metro_lines <- rail_lines()
usethis::use_data(metro_lines, overwrite = TRUE)

metro_stations <- rail_stations()
usethis::use_data(metro_stations, overwrite = TRUE)

metro_routes <- bus_routes()
usethis::use_data(metro_stations, overwrite = TRUE)

metro_stops <- bus_stops()[, -5]
usethis::use_data(metro_stops, overwrite = TRUE)
