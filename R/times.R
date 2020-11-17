#' Rail station times
#'
#' Returns opening and scheduled first/last train times based on a given
#' station code. Omit the station to return timing information for all
#' stations.
#'
#' Note that for stations with multiple platforms (e.g.: Metro Center, L'Enfant
#' Plaza, etc.), a distinct call is required for each `station` to retrieve
#' the full set of train times at such stations.
#' @param station Station code, see [stations] or [rail_stations()].
#' @param dates Should daily hours be converted to dates for current week?
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble as_tibble
#' @export
rail_times <- function(station = NULL, dates = TRUE) {
  json <- wmata_api("Rail", "jStationTimes", list(StationCode = station))
  df <- jsonlite::fromJSON(json, simplifyDataFrame = TRUE)[[1]]
  out <- rep(list(NA), 7)
  for (i in 1:7) {
    j <- 1 + 2
    first <- df[[j]]$FirstTrains
    last <- df[[j]]$LastTrains
    c <- rep(list(NA), length(first))
    for (k in seq_along(c)) {
      if (nrow(first[[k]]) == 0 | nrow(last[[k]]) == 0) {
        next
      }
      aa <- tibble::tibble(dest = first[[k]][[2]], first = first[[k]][[1]])
      bb <- tibble::tibble(dest = last[[k]][[2]], last = last[[k]][[1]])
      cc <- merge(aa, bb, all = TRUE)
      c[[k]] <- tibble::tibble(
        station = df$Code[k],
        open = df[[j]][[1]][k],
        dest = cc$dest,
        day = wdays[i],
        cc[2:3]
      )
    }
    out[[i]] <- tibble::as_tibble(do.call(rbind, c))
  }
  out <- do.call(rbind, out)
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
