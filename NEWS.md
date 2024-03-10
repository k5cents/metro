# metro 0.9.3

* Switch from MIT license to GPL-3
* Update maintainer email, website URL, and GitHub URL.
* Due to an error in the rail timing endpoint, the `rail_times()` function can
  only return example data for the time being. (#15)
* Due to an error in the train position endpoint, the `train_position()` 
  function can only return example data for the time being. (#16)
* Add `StopId` column to `bus_departs()` and use current date in the example.

# metro 0.9.2

* Update to new package doc help page.
* `bus_schedule()` now correctly merges both directions (thanks Prof. Moore!)
* No longer calls `unlist()` on affected lines of length one.
* Messages given instead of warnings when empty tibbles returned.
    * These conditions are tested with `no_data_now()` and `mockr::with_mock()`.

# metro 0.9.1

* Covered most [JSON endpoints](https://developer.wmata.com/docs/services/) 
  as tidy data frames. Buses stops, train stations, next bus or
  trains, incidents, paths, routes, circuits. (#1)
* `httr::RETRY()` in `wmata_api()` does not retry on 401, 404, etc. The purpose
  of this change is to primarily retry on 429 errors when too many requests have
  been made on a rate-limited subscription. Waiting should successfully retry.
* Stops, Stations, Routes, and Lines saved as exported objects.
* All functions accept `api_key` argument. (#5)
* Calls are made using `httr::RETRY()` to deal with issues like rate limit. (#8)
* Use the documentation and parameters in the official API documentation. (#7)
* Convert all dates to `POSIXct` with UTC time zone.
* Convert times to `hms` columns with values past midnight. (#6)
* Removed `parking_*()` functions until a data frames can be made.
* Removed `rail_path()` helper function. Keep only endpoint functions.
* Removed ability to automatically scrape demo API key.
* Removed package startup message about API key. (#2)
* Invalid URLs are removed from function documentation.
