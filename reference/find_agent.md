# Search for agents on GitHub

Searches GitHub for repositories tagged with an agent topic and matching
a keyword query. Searches across all supported agent topic conventions
(e.g. `claude-agent`, `cursor-agent`).

## Usage

``` r
find_agent(query)
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
find_agent('code-review')
} # }
```
