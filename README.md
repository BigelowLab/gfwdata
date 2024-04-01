Global Fish Watch
================

[Global Fishing Watch](https://globalfishingwatch.org/) makes a wide
variety of [data](https://globalfishingwatch.org/datasets-and-code/)
freely available. Here we provide simple tools for archiving, managing
and reading data manually downloaded.

## Requirements

[R v4.1+](https://www.r-project.org/)

[rlang](https://CRAN.R-project.org/package=rlang)

[readr](https://CRAN.R-project.org/package=readr)

[dplyr](https://CRAN.R-project.org/package=dplyr)

[sf](https://CRAN.R-project.org/package=sf)

[stars](https://CRAN.R-project.org/package=stars)

## Installation

Use the [remotes](https://CRAN.R-project.org/package=remotes) package to
install directly from github.

    remotes::install("BigelowLab/remotes)

### Download data

At this time downloading data is a manual process, but if you need
something more dynamic you can use GFW’s
[APIs](https://globalfishingwatch.org/our-apis/) which are not supported
by this package (yet.) Data you download may be compressed; you’ll need
to decompress it and save it to a “data directory”.

The organization of the code is important. Here’s what ours looks like
(abbreviated)…

    /mnt/s1/projects/ecocast/coredata/gfw
    ├── README-known-issues-v2.txt
    ├── README-mmsi-v2.txt
    ├── fishing-vessels
    │   └── fishing-vessels-v2.csv
    ├── mmsi-daily-csvs-10-v2-2020
    │   ├── 2020-01-01.csv
    │   ├── 2020-01-02.csv
    │   ├── 2020-01-03.csv
    │   ├── 2020-01-04.csv
    │   ├── 2020-01-05.csv
    │   ├── 2020-01-06.csv
            .
            .
            .
    │   ├── 2020-12-28.csv
    │   ├── 2020-12-29.csv
    │   ├── 2020-12-30.csv
    │   └── 2020-12-31.csv
    └── raster
        └── distance-from-shore.tif

You can see that all of the `mmsi-daily-csvs-10-v2-2020` files are
sequestered into their own directory. While this is generally the case
(one dataset: one directory), note that it is not a requirement.

## Usage

### Set the data path

The data is significant in size so it is not possible to include it in
the package. Instead, the package assumes that you have set a data
directory. We help you do that by providing a function to “hide” the
declared data path in a hidden file within your home directory. Assuming
that you use good password/security hygiene then your path information
will be secure.

``` r
library(gfwdata)
set_root_path(path = "/mnt/s1/projects/ecocast/coredata/gfw")
gfw_path()
```

    ## [1] "/mnt/s1/projects/ecocast/coredata/gfw"

### Read in a daily fishing effort table

Fishing effort can be read in as a table
([tibble](https://tibble.tidyverse.org/)), [sf
POINT](https://r-spatial.github.io/sf/) object or a [stars
raster](https://r-spatial.github.io/stars).

``` r
library(stars)
```

    ## Loading required package: abind

    ## Loading required package: sf

    ## Linking to GEOS 3.12.1, GDAL 3.8.3, PROJ 9.3.1; sf_use_s2() is TRUE

``` r
x = read_mmsi_daily(date = "2020-04-22", form = "stars")
x
```

    ## stars object with 2 dimensions and 3 attributes
    ## attribute(s):
    ##                   Min.     1st Qu.       Median         Mean     3rd Qu.
    ## mmsi           4168888 2.73568e+08 4.124227e+08 3.994857e+08 4.31866e+08
    ## hours                0 4.21350e-01 7.975000e-01 2.670259e+00 2.00550e+00
    ## fishing_hours        0 0.00000e+00 0.000000e+00 9.072836e-01 7.10900e-01
    ##                        Max.  NA's
    ## mmsi           9.999998e+08 58281
    ## hours          3.992250e+01 58281
    ## fishing_hours  2.586830e+01 58281
    ## dimension(s):
    ##   from  to offset   delta refsys point x/y
    ## x    1 406   -180  0.8884 WGS 84 FALSE [x]
    ## y    1 160   77.7 -0.8884 WGS 84 FALSE [y]

``` r
library(rnaturalearth)
coast = ne_coastline(returnclass = "sf")
plot(x['fishing_hours'] + 1, 
     breaks = "equal",
     axes = TRUE, 
     reset = FALSE, 
     logz = TRUE,
     col = sf.colors())
plot(coast, add = TRUE, color = "green")
```

    ## Warning in plot.sf(coast, add = TRUE, color = "green"): ignoring all but the
    ## first attribute

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
