#' Bus Path Details
#'
#' For a given date, returns the set of ordered latitude/longitude points along
#' a route variant along with the list of stops served.
#'
#' @format A list with 4 elements:
#' \describe{
#'   \item{RouteID}{Bus route variant.}
#'   \item{Name}{Descriptive name for the route.}
#'   \item{ShapePoint}{The coordinate path of the line in both directions.}
#'   \item{Stops}{The coordinates of stops on a given line.}
#' }
#' @param RouteID Bus route variant, e.g.: 70, 10A, 10Av1.
#' @param Date Date for which to retrieve route and stop information. Uses
#'   today's date if `NULL` (default).
#' @examples
#' \dontrun{
#' bus_path("10A")
#' }
#' @return A list with (1) set of ordered latitude/longitude points along a
#'   route variant along with (2) the list of stops served.
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d69?>
#' @family Bus Route and Stop Methods
#' @importFrom jsonlite fromJSON
#' @importFrom tibble add_column as_tibble
#' @export
bus_path <- function(RouteID = NULL, Date = NULL) {
  Date <- try(as.POSIXct(Date))
  stopifnot(!inherits(Date, "try-error"), inherits(Date, "POSIXct"))
  json <- wmata_api(
    type = "Bus", endpoint = "jRouteDetails",
    query = list(RouteID = RouteID, Date = Date)
  )
  dat <- jsonlite::fromJSON(json, flatten = TRUE)
  x <- rbind(dat$Direction0$Shape, dat$Direction1$Shape)
  d <- c(rep(0, nrow(dat$Direction0$Shape)), rep(1, nrow(dat$Direction1$Shape)))
  x <- tibble::add_column(x, direction = factor(d), .before = 1)
  y <- rbind(dat$Direction0$Stops, dat$Direction1$Stops)
  d <- c(rep(0, nrow(dat$Direction0$Stops)), rep(1, nrow(dat$Direction1$Stops)))
  y <- tibble::add_column(y, direction = factor(d), .before = 1)
  list(
    RouteID = dat$RouteID,
    Name = dat$Name,
    ShapePoint = tibble::as_tibble(x),
    Stops = tibble::as_tibble(y)
  )
}
