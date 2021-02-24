# metro 1.0.0

* [All API JSON endpoints](https://developer.wmata.com/docs/services/) are 
  covered as tidy data frames (#1). Buses stops, train stations, next bus or
  trains, incidents, paths, routes, circuits.
* Stops, Stations, Routes, and Lines saved as exported objects.
* All functions accept `api_key` argument.
* Demo key can be scraped and keys can be validated.
* Calls are made using `httr::RETRY()` to deal with issues like rate limit.
* Remove `parking_*()` functions until a data frames can be made.
* Use the documentation and parameters in the official API documentation.
* Convert all dates to `POSIXct` with UTC time zone.
* Convert times to `hms` columns with values past midnight.

# metro 0.0.3

* Add `rail_times()`.

# metro 0.0.2

* Add `parking_spots()` and `_cost()`.
* Add `rail_path()` and `path_distance()`
* Add `rail_entrance()`

# metro 0.0.1

* Added a `NEWS.md` file to track changes to the package.
* Add `rail_lines()` and `_stations()` and save objects.
* Add `wmata_keys()` and associated helpers.
