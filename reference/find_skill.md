# Search for skills on GitHub

Searches GitHub for repositories tagged with a skill topic and matching
a keyword query. Searches across all supported agent topic conventions
(e.g. `claude-skill`, `cursor-skill`).

## Usage

``` r
find_skill(query)
```

## Arguments

- query:

  Keyword to search for.

## Value

A data frame with columns:

- `name`: repository name.

- `description`: repository description.

- `owner`: repository owner login.

- `url`: full URL of the repository.

- `stars`: number of GitHub stars.

## Examples

``` r
if (FALSE) { # \dontrun{
# Requires GitHub API access; may fail due to rate limiting
find_skill('rstats')
} # }
```
