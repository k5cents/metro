#' Live train position
#'
#' Returns uniquely identifiable trains in service and what track circuits they
#' currently occupy. Will return an empty set of results when no positions are
#' available. Data is refreshed once every 7-10 seconds.
#'
#' Please refer to [this page](https://developer.wmata.com/TrainPositionsFAQ)
#' for additional details.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
train_positions <- function() {
   request <- httr::add_headers(
     `api_key` = wmata_key(),
     `Content-Type` = "application/json",
     `Accept` = "application/json"
   )
   response <- httr::GET(
     url = "https://api.wmata.com/TrainPositions/TrainPositions",
     config = request,
     query = list(contentType = "json")
   )
   json <- content(response, as = "text")
   df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
   names(df) <- c("id", "number", "cars", "direction", "circuit",
                  "dest", "line", "dwell", "normal")
   df$normal <- df$normal == "Normal"
   df$direction <- c("NS", "EW")[df$direction]
   tibble::as_tibble(df)
}
