#' Find a WMATA API key
#'
#' @description
#' All calls to the WMATA API must be accompanied by a personal API key. A free
#' key can be obtained by subscribing to the default tier. See
#' [browse_wmata_key()] for more information on getting a key and storing on
#' your system.
#'
#' The WMATA also provides a demonstration key. This key should **never** be
#' used in production applications, it is rate limited and subject to change at
#' _any_ time. The key can be found on
#' [this page](https://developer.wmata.com/products/5475f236031f590f380924ff).
#' If the user has the "rvest" package installed, the [wmata_demo()] function
#' can be used to try scrape said page and look for the key automatically.
#'
#' @details
#' Default tier sufficient for most casual developers. Rate limited to 10
#' calls/second and 50,000 calls per day. This product contains 8 APIs:
#' * Bus Route and Stop Methods
#' * GTFS
#' * Incidents
#' * Misc Methods
#' * Rail Station Information
#' * Real-Time Bus Predictions
#' * Real-Time Rail Predictions
#' * Train Positions
#'
#' @export
wmata_key <- function() {
  key <- Sys.getenv("WMATA_KEY", "")
  if (!nzchar(key)) {
    if (is_installed("usethis")) {
      usethis::ui_oops("no WMATA key found, see \\
                       {usethis::ui_code('browse_wmata_key()')}")
    } else {
      stop("no WMATA key found, see `browse_wmata_key()`")
    }
  }
  return(key)
}

#' @rdname wmata_key
#' @export
wmata_demo <- function() {
  if (is_installed("rvest")) {
    a <- "https://developer.wmata.com/products/5475f236031f590f380924ff"
    tryCatch(
      error = function(e) {
        message("no key scraped")
        return("")
      },
      expr = {
        b <- httr::content(httr::GET(a))
        rvest::html_text(rvest::html_nodes(b, ".bg-primary"))
      }
    )
  } else {
    stop("The \"rvest\" package needed to scrape demo key", call. = FALSE)
  }
}

#' @rdname wmata_key
#' @export
browse_wmata_key <- function() {
  if (is_installed("usethis")) {
    w <- "https://developer.wmata.com/products/5475f236031f590f380924ff"
    x <- "https://developer.wmata.com/signup/"
    y <- "https://developer.wmata.com/products/5475f1b0031f590f380924fe"
    z <- "https://developer.wmata.com/developer"
    ui_url <- function(x) crayon::italic(crayon::blue(sprintf("<%s>", x)))
    usethis::ui_info("Demo key available from {ui_url(w)} \\
                     or {usethis::ui_code('wmata_demo()')}")
    usethis::ui_line("===== or ====")
    usethis::ui_todo("Sign up for a WMATA developer account {ui_url(x)}")
    usethis::ui_todo("Subscribe to the free default tier {ui_url(y)}")
    usethis::ui_todo("Copy the {usethis::ui_field('Primary Key')} \\
                     from your profile {ui_url(z)}")
    usethis::ui_todo("Call {usethis::ui_code('usethis::edit_r_environ()')} \\
                     to open {usethis::ui_path('.Renviron')}.")
    usethis::ui_todo("Store your WMATA key with a line like:")
    usethis::ui_code_block("WMATA_KEY=xxxyyyzzz")
    usethis::ui_todo("Make sure {usethis::ui_value('.Renviron')} ends with \\n")
    invisible()
  } else {
    stop("The \"usethis\" package needed for key instructions", call. = FALSE)
  }
}
