#' Rail station entrances
#'
#' Returns a list of nearby station entrances based on latitude, longitude, and
#' radius (meters). Omit search parameters to return all station entrances.
#'
#' @param lat Center point Latitude.
#' @param lon Center point Longitude
#' @param radius Radius (meters) to include in the search area. If `NULL`, while
#'   `lat` and `lon` are supplied, all stations are returned.
#' @export
rail_entrance <- function(lat = NULL, lon = NULL, radius = NULL) {
  coord <- list(Lat = lat, Lon = lon, Radius = radius)
  json <- wmata_api("Rail.svc/json/jStationEntrances", query = coord)
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  if (length(df[[1]]) == 0) {
    warning("no entrances found within your radius, please expand")
    return(empty_entrance)
  }
  df <- type.convert(df[[1]][, c(3, 6:7, 5, 2)], na.strings = "", as.is = TRUE)
  dist <- if (is.null(lat) || is.null(lon)) {
    NA_real_
  } else {
    as.vector(geodist::geodist(coord, df))
  }
  df <- tibble::add_column(df, .after = 3, distance = dist)
  names(df) <- names(empty_entrance)
  tibble::as_tibble(df[order(df$distance), ])
}

empty_entrance <- data.frame(
  station = character(),
  lat = double(),
  lon = double(),
  distance = double(),
  description = character(),
  name = character()
)
