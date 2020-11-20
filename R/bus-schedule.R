#' Bus route and stop methods
#'
#' Returns schedules for a given route variant for a given date.
#'
#' @format A tibble with 10 variables:
#' \describe{
#'   \item{route_id}{The bus route ID}
#'   \item{direction}{General route direction}
#'   \item{trip_head}{Destination of the bus.}
#'   \item{trip_id}{Trip identifier.}
#'   \item{start_time}{Scheduled start date and time (EST) for this trip.}
#'   \item{end_time}{Scheduled end date and time (EST) for this trip.}
#'   \item{stop_seq}{Order of the stop in the sequence of StopTimes.}
#'   \item{stop_id}{7-digit regional ID. If unavailable, 0 or NULL.}
#'   \item{stop_name}{Stop name. May be different from what is displayed.}
#'   \item{stop_time}{Scheduled departure date and time (EST) from this stop.}
#' }
#' @source <https://api.wmata.com/Bus.svc/json/jRouteSchedule>
#' @param route Bus route variant, e.g.: 70, 10A, 10Av1, etc.
#' @param date Date for which to retrieve route and stop information.
#' @param variants Should variations of `route` be included?. For example, if
#'   B30 is specified and `TRUE` (default), data for all variations of B30 such
#'   as B30v1, B30v2, etc. will be returned.
#' @export
bus_schedule <- function(route = NULL, variants = TRUE, date = NULL) {
  json <- wmata_api(
    type = "Bus", endpoint = "jRouteSchedule",
    query = list(
      RouteID = route, Date = date,
      IncludingVariations = variants
    )
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  dir0_stops <- df$Direction0$StopTimes
  names(dir0_stops) <- df$Direction0$TripID
  dir0_stops <- do.call(rbind, dir0_stops)
  dir0_stops <- tibble::add_column(
    .data = dir0_stops, .before = 1,
    TripID = gsub("\\.\\d+", "", rownames(dir0_stops))
  )
  df$Direction0 <- merge2(df$Direction0[, -7], dir0_stops)
  if (!is.null(df$Direction1)) {
    dir1_stops <- df$Direction1$StopTimes
    names(dir1_stops) <- df$Direction1$TripID
    dir1_stops <- do.call(rbind, dir1_stops)
    dir1_stops <- tibble::add_column(
      .data = dir1_stops, .before = 1,
      TripID = gsub("\\.\\d+", "", rownames(dir1_stops))
    )
    df$Direction1 <- merge2(df$Direction1[, -7], dir0_stops)
    df <- rbind(df$Direction0, df$Direction1)
  } else {
    df <- df$Direction0
  }
  df[, c(5:6, 11)] <- lapply(df[, c(5:6, 11)], api_time)
  df <- df[, c(1, 3:4, 7, 5:6, 10, 8:9, 11)]
  names(df) <- snake_case(names(df))
  names(df)[c(2:3, 10)] <- c("direction", "trip_head", "stop_time")
  return(df)
}

merge2 <- function (x, y, ...) {
  out <- merge(x, y, sort = FALSE, ...)[, union(names(x), names(y))]
  tibble::as_tibble(out)
}

snake_case <- function(x) {
  # from https://github.com/OuhscBbmc/OuhscMunge/blob/master/R/snake-case.R
  s <- gsub("\\.", "_", x)
  s <- gsub("(.)([A-Z][a-z]+)", "\\1_\\2", s)
  s <- tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", s))
  s <- gsub(" ", "_", s)
  s <- gsub("__", "_", s)
  return(s)
}
