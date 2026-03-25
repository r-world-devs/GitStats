# Set local (in-memory) storage

Reset storage to the default in-memory backend.

## Usage

``` r
set_local_storage(gitstats)
```

## Arguments

- gitstats:

  A GitStats object.

## Value

A `GitStats` object (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
  my_gitstats <- create_gitstats() |>
    set_local_storage()
} # }
```
