#' Bus Stop Search
#'
#' Returns a list of nearby bus stops based on latitude, longitude, and radius.
#' Omit all parameters to retrieve a list of all stops.
#'
#' @format A tibble with 1 row per stop and 6 variables:
#' \describe{
#'   \item{StopID}{String array of route variants which provide service at this
#'   stop. Note that these are not date-specific; any route variant which stops
#'   at this stop on any day will be listed.}
#'   \item{Name}{Stop name. May be slightly different from what is spoken or
#'   displayed in the bus.}
#'   \item{Lat}{Latitude.}
#'   \item{Lon}{Longitude.}
#'   \item{Distance}{Distance (meters) of the stop from the provided search
#'   coordinates. Calculated using [geodist::geodist()] and the "cheap ruler"
#'   method.}
#'   \item{Routes}{Character string of route variants which provide service at
#'   this stop. Note that these are not date-specific; any route variant which
#'   stops at this stop on any day will be listed.}
#' }
#' @param Lat Center point Latitude, required if `Longitude` and `Radius` are
#'   specified.
#' @param Lon Center point Longitude, required if `Latitude` and `Radius` are
#'   specified.
#' @param Radius Radius (meters) to include in the search area, required if
#'   `Latitude` and `Longitude` are specified.
#' @examples
#' \dontrun{
#' bus_stops(38.897, -77.036, 500)
#' }
#' @return Data frame containing stop information
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6d>
#' @family Bus Route and Stop Methods
#' @importFrom geodist geodist
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble add_column
#' @export
bus_stops <- function(Lat = NULL, Lon = NULL, Radius = NULL) {
  coord <- list(Lat = Lat, Lon = Lon, Radius = Radius)
  json <- wmata_api(type = "Bus", endpoint = "jStops", query = coord)
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(dat) == 0) {
    warning("no stops found within your Radius, please expand")
    return(empty_stops)
  }
  if (is.null(Lat) || is.null(Lon)) {
    dist <- NA_real_
  } else {
    dist <- as.vector(geodist::geodist(coord, dat))
  }
  dat <- tibble::add_column(dat, .after = "Lat", Distance = dist)
  tibble::as_tibble(dat[order(dat$Distance), ])
}

empty_stops <- data.frame(
  StopID = character(),
  Name = character(),
  Lon = double(),
  Lat = double(),
  Distance = double(),
  Routes = character()
)
