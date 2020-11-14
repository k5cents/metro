## code to prepare `stations` dataset goes here
stations <- rail_stations()
usethis::use_data(stations, overwrite = TRUE)
