#' All WMATA rail stations
#'
#' @format A data frame with 95 rows and 10 variables:
#' \describe{
#'   \item{station}{Station code.}
#'   \item{name}{Station name.}
#'   \item{txfer}{For stations with multiple platforms, the additional code.}
#'   \item{lines}{Vector of line codes services by station.}
#'   \item{lat}{Latitude.}
#'   \item{lon}{Longitude.}
#'   \item{street}{Street address (for GPS use).}
#'   \item{city}{City.}
#'   \item{state}{State (abbreviated).}
#'   \item{zip}{Zip code.}
#'   ...
#' }
"metro_stations"

#' All WMATA rail lines
#'
#' @format A data frame with 95 rows and 10 variables:
#' \describe{
#'   \item{line}{Two-letter abbreviation for the line.}
#'   \item{name}{Full name of line color.}
#'   \item{start}{Start station code.}
#'   \item{end}{End station code.}
#'   ...
#' }
"metro_lines"

#' All WMATA bus routes
#'
#' @format A data frame with 325 rows and 3 variables:
#' \describe{
#'   \item{route}{Unique identifier for a given route variant.}
#'   \item{name}{Descriptive name of the route variant.}
#'   \item{description}{Denotes the route variant’s grouping – lines are a
#'   combination of routes which lie in the same corridor and which have
#'   significant portions of their paths along the same roadways.}
#'   ...
#' }
"metro_routes"

#' All WMATA bus stops
#'
#' @format A data frame with 9,074 rows and 5 variables:
#' \describe{
#'   \item{stop}{Bus stop ID}
#'   \item{name}{Bus stop name}
#'   \item{lon}{Latitude.}
#'   \item{lat}{Longitude.}
#'   \item{routes}{Character vector of routes services by stop.}
#'   ...
#' }
"metro_stops"
