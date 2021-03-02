
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metro <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://lifecycle.r-lib.org/articles/figures/lifecycle-maturing.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/metro)](https://CRAN.R-project.org/package=metro)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/metro)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/metro/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/metro?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/kiernann/metro/badge)](https://www.codefactor.io/repository/github/kiernann/metro)
[![R build
status](https://github.com/kiernann/metro/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/metro/actions)
<!-- badges: end -->

The goal of metro is to return data frames from the Washington
Metropolitan Area Transit Authority API. Nested lists have been
converted to [tidy](https://en.wikipedia.org/wiki/Tidy_data) data frames
when possible.

## Installation

The release version of metro (0.9.1) can be installed from
[CRAN](https://cran.r-project.org/package=metro):

``` r
install.packages("metro")
```

Or install the development version from
[GitHub](https://github.com/kiernann/metro):

``` r
# install.packages("devtools")
devtools::install_github("kiernann/metro")
```

## Key

Usage of the WMATA API requires a developer API key. Such a key can be
obtained by creating a developer account and subscribing to the free
default tier.

The WMATA also provides a [demo
key](https://developer.wmata.com/products/5475f236031f590f380924ff) to
try out the various features of the API. This key should **never** be
used in production, it is rate limited and subject to change at any
time.

``` r
Sys.setenv(WMATA_KEY = "e13626d03d8e4c03ac07f95541b3091b")
```

## Example

``` r
library(metro)
packageVersion("metro")
#> [1] '0.9.1.9002'
```

Functions return data frames for easy analysis.

``` r
next_train(StationCodes = "A01")
#> # A tibble: 6 x 9
#>     Car Destination DestinationCode DestinationName Group Line  LocationCode LocationName   Min
#>   <int> <chr>       <chr>           <chr>           <int> <chr> <chr>        <chr>        <int>
#> 1     8 Glenmont    B11             Glenmont            1 RD    A01          Metro Center    -1
#> 2     8 Glenmont    B11             Glenmont            1 RD    A01          Metro Center     5
#> 3     8 Shady Gr    A15             Shady Grove         2 RD    A01          Metro Center     6
#> 4     8 Glenmont    B11             Glenmont            1 RD    A01          Metro Center     9
#> 5     8 Shady Gr    A15             Shady Grove         2 RD    A01          Metro Center     9
#> 6     8 Shady Gr    A15             Shady Grove         2 RD    A01          Metro Center    17
```

### Coordinates

Use coordinates to find station entrances or bus stops near a location.
The [`geodist::geodist()`](https://github.com/hypertidy/geodist)
function is used to calculate distance from the supplied coordinates.

``` r
# Washington Monument coordinates
rail_entrance(Lat = 38.890, Lon = -77.035, Radius = 750)[, -(3:4)]
#> # A tibble: 5 x 5
#>   Name                                                         StationCode   Lat   Lon Distance
#>   <chr>                                                        <chr>       <dbl> <dbl>    <dbl>
#> 1 NORTH ENTRANCE (MALL EXIT, NORTHEAST OF 12TH ST & JEFERSON … D02          38.9 -77.0     582.
#> 2 SOUTH ELEVATOR ENTRANCE (NORTHWEST CORNER OF 12TH ST & INDE… D02          38.9 -77.0     612.
#> 3 SOUTH ENTRANCE (SOUTHWEST CORNER OF 12TH ST & INDEPENDENCE … D02          38.9 -77.0     626.
#> 4 MAIN ENTRANCE (WEST SIDE 12TH BETWEEN PENNSYLVANIA &  CONNE… D01          38.9 -77.0     672.
#> 5 ELEVATOR ENTRANCE (WEST SIDE 12TH BETWEEN PENNSYLVANIA &  C… D01          38.9 -77.0     714.
```

### Dates and Times

Date columns with class `POSIXt` have been shifted from Eastern time to
the UTC time zone (+5 hours).

``` r
bus_position(RouteId = "33")[, 1:8]
#> # A tibble: 5 x 8
#>   VehicleID   Lat   Lon Distance Deviation DateTime            TripID     RouteID
#>   <chr>     <dbl> <dbl>    <dbl>     <dbl> <dttm>              <chr>      <chr>  
#> 1 7149       39.0 -77.1       NA         0 2021-03-02 19:23:08 1932491020 33     
#> 2 7140       38.9 -77.0       NA        -4 2021-03-02 19:22:50 1932532020 33     
#> 3 7122       38.9 -77.1       NA        -3 2021-03-02 19:23:05 1932489020 33     
#> 4 7163       38.9 -77.1       NA         6 2021-03-02 19:23:18 1932531020 33     
#> 5 7151       38.9 -77.0       NA         4 2021-03-02 19:23:09 1932487020 33
```

Time values are left in Eastern time and are represented using the class
[`hms`](https://github.com/tidyverse/hms/issues/28), which counts the
seconds since midnight. If the *last* train on a Saturday leaves at 1:21
AM (past midnight), this would be represented as `25:21`.

``` r
tail(rail_times(StationCode = "A07"))
#> # A tibble: 6 x 7
#>   StationCode StationName   DestinationStation Weekday OpeningTime FirstTime LastTime
#>   <chr>       <chr>         <chr>              <chr>   <time>      <time>    <time>  
#> 1 A07         Tenleytown-AU A15                Fri     05:14       05:46     25:21   
#> 2 A07         Tenleytown-AU B11                Fri     05:14       05:24     24:49   
#> 3 A07         Tenleytown-AU A15                Sat     07:14       07:46     25:21   
#> 4 A07         Tenleytown-AU B11                Sat     07:14       07:24     24:49   
#> 5 A07         Tenleytown-AU A15                Sun     08:14       08:46     23:21   
#> 6 A07         Tenleytown-AU B11                Sun     08:14       08:24     22:49
```

### Data

Some data frames are includes as objects if their functions typically
return the same thing every time.

``` r
metro_lines # rail_lines() for live
#> # A tibble: 6 x 5
#>   LineCode DisplayName StartStationCode EndStationCode InternalDestination
#>   <chr>    <chr>       <chr>            <chr>          <list>             
#> 1 BL       Blue        J03              G05            <chr [0]>          
#> 2 GR       Green       F11              E10            <chr [0]>          
#> 3 OR       Orange      K08              D13            <chr [0]>          
#> 4 RD       Red         A15              B11            <chr [2]>          
#> 5 SV       Silver      N06              G05            <chr [0]>          
#> 6 YL       Yellow      C15              E06            <chr [1]>
```

<!-- refs: start -->
<!-- refs: end -->
