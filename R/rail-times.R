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
#' @param StationCode Station code. Use the [rail_stations()] function to return
#'   a list of all station codes. Use `NULL` (default) to return times for all
#'   stations.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_times("A01")
#' }
#' @return A _tidy_ data frame of station schedules. Combined from a nested list
#'   of weekday times.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312>
#' @family Rail Station Information
#' @importFrom tibble as_tibble rownames_to_column
#' @export
rail_times <- function(StationCode = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Rail.svc/json/jStationTimes",
    query = list(StationCode = StationCode),
    level = 1,
    api_key = api_key
  )
  stn_codes <- dat$Code
  stn_names <- dat$StationName
  dat <- dat[, 3:9]
  out <- rep(list(rep(list(NA), length(dat$Monday$FirstTrains))), 7)
  for (i in seq_along(dat)) {
    for (k in seq_along(dat[[i]]$FirstTrains)) {
      if (nrow(dat[[i]]$FirstTrains[[k]]) < 1) {
        next
      } else {
        out[[i]][[k]] <- tibble::tibble(
          StationCode = stn_codes[k],
          StationName = stn_names[k],
          Weekday = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")[i],
          OpeningTime = dat[[i]]$OpeningTime[k],
          merge(
            x = dat[[i]]$FirstTrains[[k]],
            y = dat[[i]]$LastTrains[[k]],
            by = "DestinationStation",
            all = TRUE,
            suffixes = c("First","Last")
          )
        )
      }
    }
  }
  out <- do.call(
    what = rbind,
    args = lapply(
      X = out,
      FUN = function(dat) {
        do.call(rbind, dat)
      }
    )
  )
  names(out)[6:7] <- c("FirstTime", "LastTime")
  out[!is.na(out$StationCode), c(1:2, 5, 4, 6:7)]
}
