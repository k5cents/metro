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
#'   \item{DestinationStation}{Station code for the train's destination. Use
#'   this value in other rail-related APIs to retrieve data about a station.}
#'   \item{Weekday}{Day of the week abbreviation. From list element names.}
#'   \item{OpeningTime}{Station opening time. Converted to `hms` class with
#'   [hms::parse_hm()], representing seconds since midnight of that `Weekday`.}
#'   \item{FirstTime}{First train leaves the station at this time (ET).
#'   Converted to `hms` class with [hms::parse_hm()], representing seconds since
#'   midnight of that `Weekday`.}
#'   \item{LastTime}{Last train leaves the station at this time (ET). Converted
#'   to `hms` class with [hms::parse_hm()], representing seconds since midnight
#'   of that `Weekday`. For times that were in the AM of the _next_ `Weekday`,
#'   time is greater than 24 hours.}
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
#' @importFrom hms parse_hm
#' @importFrom tibble as_tibble rownames_to_column
#' @export
rail_times <- function(StationCode = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Rail.svc/json/jStationTimes",
    query = list(StationCode = StationCode),
    level = 1,
    api_key = api_key
  )
  if (length(dat$Monday$FirstTrains[[1]]) == 0) {
    warning("Using example data until issue is resolved: ",
             "https://github.com/kiernann/metro/issues/15")
    example_file <- system.file("jStationTimes.json", package = "metro")
    dat <- jsonlite::fromJSON(example_file)[[1]]
  }
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
  out <- out[!is.na(out$StationCode), c(1:2, 5, 3:4, 6:7)]
  out[, 5:7] <- lapply(out[, 5:7], hms::parse_hm)
  # AM time originally means next day, convert to >24 hour time
  am_last <- which(out$LastTime < 43200) # under 12 hours of seconds
  out$LastTime[am_last] <- hms::as_hms(out$LastTime[am_last] + 86400)
  out
}
