#' Bus routes
#'
#' Returns a list of all bus route variants (patterns). For example, the 10A and
#' 10Av1 are the same route, but may stop at slightly different locations.
#'
#' @format A tibble with 3 variables:
#' \describe{
#'   \item{route}{Unique identifier for a given route variant.}
#'   \item{name}{Descriptive name of the route variant.}
#'   \item{description}{Denotes the route variant’s grouping – lines are a
#'   combination of routes which lie in the same corridor and which have
#'   significant portions of their paths along the same roadways.}
#' }
#' @source <https://api.wmata.com/Bus.svc/json/jRoutes>
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
bus_routes <- function() {
  json <- wmata_api("Bus", "jRoutes")
  df <- jsonlite::fromJSON(json)[[1]]
  names(df) <- c("route", "name", "description")
  tibble::as_tibble(df)
}
