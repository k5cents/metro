#' Rail stop search
#'
#' Returns a list of nearby bus stops based on latitude, longitude, and radius.
#' Omit all parameters to retrieve a list of all stops.
#'
#' @format A tibble with 6 variables:
#' \describe{
#'   \item{stop}{Bus stop ID}
#'   \item{name}{Bus stop name}
#'   \item{lon}{Latitude.}
#'   \item{lat}{Longitude.}
#'   \item{distance}{Distance in meters from provided coordinates.}
#'   \item{routes}{Chracter vector of routes services by stop.}
#' }
#' @param lat Center point Latitude.
#' @param lon Center point Longitude
#' @param radius Radius (meters) to include in the search area. If `NULL`, while
#'   `lat` and `lon` are supplied, all stations are returned.
#' @importFrom geodist geodist
#' @importFrom tibble as_tibble add_column
#' @importFrom jsonlite fromJSON
#' @export
bus_stops <- function(lat = NULL, lon = NULL, radius = NULL) {
  coord <- list(Lat = lat, Lon = lon, Radius = radius)
  json <- wmata_api("Bus", "jStops", query = coord)
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(df) == 0) {
    warning("no stops found within your radius, please expand")
    return(empty_stops)
  }
  dist <- if (is.null(lat) || is.null(lon)) {
    NA_real_
  } else {
    as.vector(geodist::geodist(coord, df))
  }
  df <- tibble::add_column(df, .after = "Lat", distance = dist)
  names(df) <- names(empty_stops)
  tibble::as_tibble(df[order(df$distance), ])
}

empty_stops <- data.frame(
  stop = character(),
  name = character(),
  lon = double(),
  lat = double(),
  distance = double(),
  routes = character()
)
