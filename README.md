
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
Metropolitan Area Transit Authority API. User need a WMATA API key, see
below for more details.

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

As of December 2020, the demo key can be used like this:

``` r
Sys.setenv("WMATA_KEY" = "e13626d03d8e4c03ac07f95541b3091b")
```

## Example

``` r
library(metro)
```

Functions return data frames for easy analysis.

``` r
rail_stations(line = "RD")
```

    #> # A tibble: 27 x 8
    #>    station name                         lat   lon street                  city      state   zip
    #>    <chr>   <chr>                      <dbl> <dbl> <chr>                   <chr>     <chr> <int>
    #>  1 A01     Metro Center                38.9 -77.0 607 13th St. NW         Washingt… DC    20005
    #>  2 A02     Farragut North              38.9 -77.0 1001 Connecticut Avenu… Washingt… DC    20036
    #>  3 A03     Dupont Circle               38.9 -77.0 1525 20th St. NW        Washingt… DC    20036
    #>  4 A04     Woodley Park-Zoo/Adams Mo…  38.9 -77.1 2700 Connecticut Ave.,… Washingt… DC    20008
    #>  5 A05     Cleveland Park              38.9 -77.1 3599 Connecticut Avenu… Washingt… DC    20008
    #>  6 A06     Van Ness-UDC                38.9 -77.1 4200 Connecticut Avenu… Washingt… DC    20008
    #>  7 A07     Tenleytown-AU               38.9 -77.1 4501 Wisconsin Avenue … Washingt… DC    20016
    #>  8 A08     Friendship Heights          39.0 -77.1 5337 Wisconsin Avenue … Washingt… DC    20015
    #>  9 A09     Bethesda                    39.0 -77.1 7450 Wisconsin Avenue   Bethesda  MD    20814
    #> 10 A10     Medical Center              39.0 -77.1 8810 Rockville Pike     Bethesda  MD    20814
    #> # … with 17 more rows

Dates and locations often assume the user is in the Washington area.

``` r
rail_entrance(lat = 38.8979, lon = -77.0365, radius = 500)
```

    #> # A tibble: 3 x 5
    #>   station   lat   lon distance name                                
    #>   <chr>   <dbl> <dbl>    <dbl> <chr>                               
    #> 1 C02      38.9 -77.0     379. WEST ENTRANCE (VERMONT & I STs)     
    #> 2 C03      38.9 -77.0     422. EAST ENTRANCE (EAST OF 17th & I STs)
    #> 3 C02      38.9 -77.0     499. EAST ENTRANCE (14TH & I STs)

Functions that always return the same data have that data saved as
objects.

``` r
metro_stops # bus_stops() for live
#> # A tibble: 9,074 x 5
#>    stop    name                                  lon   lat routes    
#>    <chr>   <chr>                               <dbl> <dbl> <list>    
#>  1 2000474 UNIVERSITY BLVD W + HEMINGWAY CT    -77.0  39.0 <chr [6]> 
#>  2 2000475 UNIVERSITY BLVD W + INWOOD AVE      -77.0  39.0 <chr [6]> 
#>  3 2000477 UNIVERSITY BLVD W + SLIGO CREEK PKY -77.0  39.0 <chr [2]> 
#>  4 2000479 LOCKWOOD DR + NORTHWEST DR          -77.0  39.0 <chr [10]>
#>  5 2000480 UNIVERSITY BLVD W + SLIGO CREEK PKY -77.0  39.0 <chr [6]> 
#>  6 2000481 LOCKWOOD DR + NORTHWEST DR          -77.0  39.0 <chr [9]> 
#>  7 2000483 NEW HAMPSHIRE AVE + NORTHWEST DR    -77.0  39.0 <chr [4]> 
#>  8 2000486 FALLS RD + ELDWICK WAY              -77.2  39.0 <chr [1]> 
#>  9 2000487 UNIVERSITY BLVD W + EASECREST DR    -77.0  39.0 <chr [6]> 
#> 10 2000488 UNIVERSITY BLVD W + EASECREST DR    -77.0  39.0 <chr [2]> 
#> # … with 9,064 more rows
```

<!-- refs: start -->

<!-- refs: end -->
