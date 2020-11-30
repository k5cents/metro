#' Track circuits
#'
#' Returns a list of all track circuits including those on pocket tracks and
#' crossovers. Each track circuit may include references to its right and left
#' neighbors.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @importFrom httr GET content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble as_tibble rownames_to_column
#' @export
track_circuits <- function() {
  request <- httr::add_headers(
    `api_key` = wmata_key(),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )
  response <- httr::GET(
    url = "https://api.wmata.com/TrainPositions/TrackCircuits",
    config = request,
    query = list(contentType = "json")
  )
  json <- httr::content(response, as = "text")
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  names(df$Neighbors) <- seq_along(df$Neighbors)
  y <- do.call(rbind, df$Neighbors)
  y <- tibble::rownames_to_column(y, "id")
  y$id <- extract_rx(y$id, "^\\d+")
  df <- merge2(
    x = tibble::tibble(
      id = seq(nrow(df)),
      df[, 1:2]
    ),
    y = y
  )
  df <- df[, -1]
  names(df) <- c("track", "circuit", "nbr_type", "nbr_id")
  df
}
