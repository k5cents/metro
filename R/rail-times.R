#' Rail station times
#'
#' Returns opening and scheduled first/last train times based on a given
#' station code. Omit the station to return timing information for all
#' stations.
#'
#' Note that for stations with multiple platforms (e.g.: Metro Center, L'Enfant
#' Plaza, etc.), a distinct call is required for each `station` to retrieve
#' the full set of train times at such stations.
#' @param station Station code, see [metro_stations] or [rail_stations()].
#' @param dates Should daily hours be converted to dates for current week?
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble as_tibble add_column rownames_to_column
#' @export
rail_times <- function(station = NULL, dates = TRUE) {
  json <- wmata_api("Rail", "jStationTimes", list(StationCode = station))
  df <- jsonlite::fromJSON(json, simplifyDataFrame = TRUE)[[1]]
  out <- rep(list(NA), 7)
  for (i in 1:7) {
    j <- i + 2
    f <- day_times(df[[j]]$FirstTrains, df$Code, "first", df[[j]]$OpeningTime)
    l <- day_times(df[[j]]$LastTrains,  df$Code, "last",  df[[j]]$OpeningTime)
    fl <- merge(x = f, y = l, all = TRUE)
    out[[i]] <- tibble::add_column(fl, day = wdays[i], .after = "dest")
  }
  out <- tibble::as_tibble(do.call(rbind, out))
  if (dates) {
    offset <- as.Date(1 - 4, origin = "1970-01-01")
    last_mon <- 7 * floor(as.numeric(Sys.Date() - 1 + 4) / 7) + offset
    ds <- rep(last_mon + 0:6, each = 2)
    out[c(2, 5:6)] <- lapply(
      X = out[c(2, 5:6)],
      FUN = function(t) {
        as.POSIXct(paste(ds, t))
      }
    )
  }
  return(out)
}

wdays <- factor(
  x = 1:7,
  labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
  ordered = TRUE
)

day_times <- function(b, rname, type = c("first", "last"), open = NULL) {
  names(b) <- rname
  o <- data.frame(station = rname, open = open, stringsAsFactors = FALSE)
  f <- tibble::rownames_to_column(do.call(rbind, b), var = "station")
  f$station <- gsub("\\.\\d+", "",  f$station)
  f <- merge(f, o, sort = FALSE)
  names(f)[2:3] <- c(type, "dest")
  f[, c(1, 4, 3, 2)]
}
