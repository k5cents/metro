#' Bus Routes
#'
#' Returns a list of all bus route variants (patterns). For example, the 10A and
#' 10Av1 are the same route, but may stop at slightly different locations.
#'
#' @format A tibble with 3 variables and one row per route variant:
#' \describe{
#'   \item{RouteID}{Unique identifier for a given route variant. Can be used in
#'   various other bus-related methods.}
#'   \item{Name}{Descriptive name of the route variant.}
#'   \item{LineDescription}{Denotes the route variant's grouping - lines are a
#'   combination of routes which lie in the same corridor and which have
#'   significant portions of their paths along the same roadways.}
#' }
#'
#' @inheritParams wmata_api
#' @examples
#' \dontrun{
#' bus_routes()
#' }
#' @return Data frame containing route variant information
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6a>
#' @family Bus Route and Stop Methods
#' @importFrom tibble as_tibble
#' @export
bus_routes <- function(api_key = wmata_key()) {
  dat <- wmata_api("/Bus.svc/json/jRoutes", level = 1, api_key = api_key)
  tibble::as_tibble(dat)
}
