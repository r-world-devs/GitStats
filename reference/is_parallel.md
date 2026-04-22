# Check if parallel processing is active

Returns `TRUE` when mirai daemons are running on the given `GitStats`
object (i.e.
[`set_parallel()`](https://r-world-devs.github.io/GitStats/reference/set_parallel.md)
has been called), `FALSE` otherwise.

## Usage

``` r
is_parallel(gitstats)
```

## Arguments

- gitstats:

  A GitStats object.

## Value

A logical scalar.

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats()
  is_parallel(my_gitstats)
} # }
```
