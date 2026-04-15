# Check if parallel processing is active

Returns `TRUE` when mirai daemons are running (i.e.
[`set_parallel()`](https://r-world-devs.github.io/GitStats/reference/set_parallel.md)
has been called), `FALSE` otherwise.

## Usage

``` r
is_parallel()
```

## Value

A logical scalar.

## Examples

``` r
is_parallel()
#> [1] FALSE
```
