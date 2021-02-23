
<!-- README.md is generated from README.Rmd. Please edit that file -->

# metro <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/metro)](https://CRAN.R-project.org/package=metro)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/metro/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/metro?branch=master)
[![R build
status](https://github.com/kiernann/metro/workflows/R-CMD-check/badge.svg)](https://github.com/kiernann/metro/actions)
<!-- badges: end -->

The goal of metro is to return data frames from the Washington
Metropolitan Area Transit Authority API. Nested lists have been
converted to [tidy](https://en.wikipedia.org/wiki/Tidy_data) data frames
when possible.

## Installation

You can install the development version of metro from
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

As of February 2021, the demo key can be used like this:

``` r
Sys.setenv("WMATA_KEY" = "e13626d03d8e4c03ac07f95541b3091b")
```

## Example

``` r
library(metro)
```

Functions return data frames for easy analysis.

``` r
rail_stations(LineCode = "RD")
#> # A tibble: 27 x 8
#>    StationCode StationName                 Lat   Lon Street                City     State Zip  
#>    <chr>       <chr>                     <dbl> <dbl> <chr>                 <chr>    <chr> <chr>
#>  1 A01         Metro Center               38.9 -77.0 607 13th St. NW       Washing… DC    20005
#>  2 A02         Farragut North             38.9 -77.0 1001 Connecticut Ave… Washing… DC    20036
#>  3 A03         Dupont Circle              38.9 -77.0 1525 20th St. NW      Washing… DC    20036
#>  4 A04         Woodley Park-Zoo/Adams M…  38.9 -77.1 2700 Connecticut Ave… Washing… DC    20008
#>  5 A05         Cleveland Park             38.9 -77.1 3599 Connecticut Ave… Washing… DC    20008
#>  6 A06         Van Ness-UDC               38.9 -77.1 4200 Connecticut Ave… Washing… DC    20008
#>  7 A07         Tenleytown-AU              38.9 -77.1 4501 Wisconsin Avenu… Washing… DC    20016
#>  8 A08         Friendship Heights         39.0 -77.1 5337 Wisconsin Avenu… Washing… DC    20015
#>  9 A09         Bethesda                   39.0 -77.1 7450 Wisconsin Avenue Bethesda MD    20814
#> 10 A10         Medical Center             39.0 -77.1 8810 Rockville Pike   Bethesda MD    20814
#> # … with 17 more rows
```

Use coordinates to find station entrances or bus stops near a location.

``` r
# White House coordinates
rail_entrance(Lat = 38.8979, Lon = -77.0365, Radius = 500)
#> # A tibble: 3 x 5
#>   Name                                 StationCode   Lat   Lon Distance
#>   <chr>                                <chr>       <dbl> <dbl>    <dbl>
#> 1 WEST ENTRANCE (VERMONT & I STs)      C02          38.9 -77.0     379.
#> 2 EAST ENTRANCE (EAST OF 17th & I STs) C03          38.9 -77.0     422.
#> 3 EAST ENTRANCE (14TH & I STs)         C02          38.9 -77.0     499.
```

Dates use the UTC time zone but times use EST. Times are represented
using the [`hms`](https://github.com/tidyverse/hms/issues/28) class,
which counts the seconds since midnight (sometimes this means AM times
are over 24 hours).

``` r
bus_position(RouteId = "L2")
#> # A tibble: 2 x 7
#>   VehicleID TripID  RouteID DirectionText TripHeadsign  TripStartTime       TripEndTime        
#>   <chr>     <chr>   <chr>   <chr>         <chr>         <dttm>              <dttm>             
#> 1 7120      190912… L2      NORTH         CHEVY CHASE … 2021-02-23 03:32:00 2021-02-23 04:08:00
#> 2 7112      190915… L2      SOUTH         FARRAGUT SQU… 2021-02-23 03:45:00 2021-02-23 04:15:00
```

``` r
rail_times(StationCode = "A07")
#> # A tibble: 14 x 7
#>    StationCode StationName   DestinationStation Weekday OpeningTime FirstTime LastTime
#>    <chr>       <chr>         <chr>              <chr>   <time>      <time>    <time>  
#>  1 A07         Tenleytown-AU A15                Mon     05:14       05:46     23:51   
#>  2 A07         Tenleytown-AU B11                Mon     05:14       05:24     23:19   
#>  3 A07         Tenleytown-AU A15                Tue     05:14       05:46     23:51   
#>  4 A07         Tenleytown-AU B11                Tue     05:14       05:24     23:19   
#>  5 A07         Tenleytown-AU A15                Wed     05:14       05:46     23:51   
#>  6 A07         Tenleytown-AU B11                Wed     05:14       05:24     23:19   
#>  7 A07         Tenleytown-AU A15                Thu     05:14       05:46     23:51   
#>  8 A07         Tenleytown-AU B11                Thu     05:14       05:24     23:19   
#>  9 A07         Tenleytown-AU A15                Fri     05:14       05:46     25:21   
#> 10 A07         Tenleytown-AU B11                Fri     05:14       05:24     24:49   
#> 11 A07         Tenleytown-AU A15                Sat     07:14       07:46     25:21   
#> 12 A07         Tenleytown-AU B11                Sat     07:14       07:24     24:49   
#> 13 A07         Tenleytown-AU A15                Sun     08:14       08:46     23:21   
#> 14 A07         Tenleytown-AU B11                Sun     08:14       08:24     22:49
```

Functions that always return the same data have that data saved as
objects.

``` r
metro_stops # bus_stops() for live
#> # A tibble: 9,044 x 5
#>    StopID  Name                                                Lon   Lat Routes   
#>    <chr>   <chr>                                             <dbl> <dbl> <list>   
#>  1 1000001 SHEPHERD PKY SW + SHEPHERD PKY SW                 -77.0  38.8 <chr [3]>
#>  2 1000003 SHEPHERD PKY SW + DC VILLAGE LN                   -77.0  38.8 <chr [3]>
#>  3 1000004 M L KING AVE + JOLIET ST                          -77.0  38.8 <chr [5]>
#>  4 1000005 SHEPHERD PKWY + FIRE DEPT TRNG CTR                -77.0  38.8 <chr [3]>
#>  5 1000006 SHEPHERD PKY SW + FIRE DEPARTMENT TRAINING CENTER -77.0  38.8 <chr [3]>
#>  6 1000007 IRVINGTON ST SW + MARTIN LUTHER KING JR AVE SW    -77.0  38.8 <chr [6]>
#>  7 1000008 IRVINGTON ST + IVANHOE ST                         -77.0  38.8 <chr [6]>
#>  8 1000009 SOUTHERN AVE SE + S CAPITOL ST SE                 -77.0  38.8 <chr [1]>
#>  9 1000010 MARTIN LUTHER KING JR AVE SW + #4660              -77.0  38.8 <chr [5]>
#> 10 1000012 MARTIN LUTHER KING JR AVE SW + BLUE PLAINS DR SW  -77.0  38.8 <chr [6]>
#> # … with 9,034 more rows
```

<!-- refs: start -->
<!-- refs: end -->
