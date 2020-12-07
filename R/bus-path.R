#' Bus path details
#'
#' For a given date, returns the set of ordered latitude/longitude points along
#' a route variant along with the list of stops served. Useful for creating
#' maps.
#'
#' @format A list with 4 elements:
#' \describe{
#'   \item{route}{The route code.}
#'   \item{name}{The route name.}
#'   \item{shape}{The coordinate path of the line in both directions.}
#'   \item{stops}{The coordinates of stops on a given line.}
#' }
#' @param route Bus route variant, e.g.: 70, 10A, 10Av1.
#' @param date Date for which to retrieve route and stop information.
#' @export
bus_path <- function(route = NULL, date = NULL) {
  json <- wmata_api(
    type = "Bus", endpoint = "jRouteDetails",
    query = list(RouteId = route, Date = date)
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  x <- rbind(df$Direction0$Shape, df$Direction1$Shape)
  d <- c(rep(0, nrow(df$Direction0$Shape)), rep(1, nrow(df$Direction1$Shape)))
  names(x) <- c("lat", "lon", "seq")
  x <- tibble::add_column(x, direction = factor(d), .before = 1)
  y <- rbind(df$Direction0$Stops, df$Direction1$Stops)
  d <- c(rep(0, nrow(df$Direction0$Stops)), rep(1, nrow(df$Direction1$Stops)))
  names(y) <- tolower(names(y))
  names(y)[1] <- "stop"
  y <- tibble::add_column(y, direction = factor(d), .before = 1)
  list(
    route = df$RouteID,
    name = df$Name,
    shape = as_tibble(x),
    stops = as_tibble(y)
  )
}
