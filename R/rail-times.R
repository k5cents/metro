#' Rail Station Timings
#'
#' Returns opening and scheduled first/last train times based on a given
#' `StationCode`. Omit the `StationCode` to return timing information for all
#' stations.
#'
#' Note that for stations with multiple platforms (e.g.: Metro Center, L'Enfant
#' Plaza, etc.), a distinct call is required for each `StationCode` to retrieve
#' the full set of train times at such stations.
#'
#' @format A tibble 1 row per train with 8 variables:
#' \describe{
#'   \item{StationCode}{Station code for this station. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{StationName}{Full name of the station.}
#'   \item{Weekday}{Abbreviated day of the week.}
#'   \item{OpeningTime}{Station opening time (EST). Format is HH:mm.}
#'   \item{FirstStation}{Station code for the train's destination. Use this
#'   value in other rail-related APIs to retrieve data about a station.}
#'   \item{FirstTime}{First train leaves the station at this time (EST). Format
#'   is HH:mm.}
#'   \item{LastStation}{Station code for the train's destination. Use this value
#'   in other rail-related APIs to retrieve data about a station.}
#'   \item{LastTime}{Last train leaves the station at this time (EST). Format is
#'   HH:mm. Note that when the time is AM, it signifies the next day. For
#'   example, a value of 02:30 under a Saturday element means the last train
#'   leaves on Sunday at 2:30 AM.}
#' }
#'
#' @param StationCode Station code. Use the [rail_stations()] to return a list
#'   of all station codes.
#' @examples
#' \dontrun{
#' rail_times("A01")
#' }
#' @return A _tidy_ data frame of station schedules. Combined from a nested list
#'   of weekday times.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312>
#' @family Rail Station Information
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble rownames_to_column
#' @export
rail_times <- function(StationCode = NULL) {
  json <- wmata_api(
    type = "Rail",
    endpoint = "jStationTimes",
    query = list(
      StationCode = StationCode
    )
  )
  dat <- jsonlite::fromJSON(json, flatten = FALSE)[[1]]
  dat <- tibble::as_tibble(dat)
  days <- as_tibble(do.call(rbind, dat[3:9]))
  # add opening time to each day
  for (i in seq_along(days$FirstTrains)) {
    days$FirstTrains[[i]] <- tibble::add_column(
      days$FirstTrains[[i]],
      OpeningTime = rep(days$OpeningTime[i], each = nrow(days$FirstTrains[[i]]))
    )
    days$LastTrains[[i]] <- tibble::add_column(
      days$LastTrains[[i]],
      OpeningTime = rep(days$OpeningTime[i], each = nrow(days$LastTrains[[i]]))
    )
  }
  # unnest all weekday times
  first_trains <- days$FirstTrains
  names(first_trains) <- wdays
  first_trains <- rows_bind(first_trains)[, 3:1]
  names(first_trains)[2:3] <- c("FirstStation", "FirstTime")
  first_trains <- tibble::rownames_to_column(first_trains, "Weekday")
  first_trains$Weekday <- gsub("\\.\\d$", "", first_trains$Weekday)
  # repeat for last trains
  last_trains <- days$LastTrains
  names(last_trains) <- wdays
  last_trains <- rows_bind(last_trains)[, 3:1]
  names(last_trains)[2:3] <- c("LastStation", "LastTime")
  last_trains <- tibble::rownames_to_column(last_trains, "Weekday")
  last_trains$Weekday <- gsub("\\.\\d$", "", last_trains$Weekday)
  # combine and add station info
  tibble::add_column(
    merge2(first_trains, last_trains),
    .before = 1,
    StationCode = dat$Code,
    StationName = dat$StationName
  )
}

wdays <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
