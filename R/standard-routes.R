#' Standard routes
#'
#' Returns an ordered list of mostly revenue (and some lead) track circuits,
#' arranged by line and track number. This data does not change frequently and
#' should be cached for a reasonable amount of time.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
standard_routes <- function() {
  request <- httr::add_headers(
    `api_key` = wmata_key(),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )
  response <- httr::GET(
    url = "https://api.wmata.com/TrainPositions/StandardRoutes",
    config = request,
    query = list(contentType = "json")
  )
  json <- content(response, as = "text")
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  names(df$TrackCircuits) <- paste(df$LineCode, df$TrackNum)
  df <- do.call(rbind, df$TrackCircuits)
  df <- tibble::rownames_to_column(df, "line.track")
  df <- tibble::add_column(
    .data = df[, 2:4], .before = 1,
    line = substr(df$line.track, 1, 2),
    track = extract_rx(df$line.track, "\\d+")
  )
  names(df)[3:5] <- c("seq", "circuit", "station")
  tibble::as_tibble(df)
}

extract_rx <- function(x, rx) {
  as.integer(regmatches(x, m = regexpr(rx, x)))
}

