# Slowness on API /decode

1. Reading from a large database
As the application runs, the database will become really fat.

2. Unnecessary decoding
Every decoding will read directly from database even it's for the same URL

## Solution

1. Reduce database size: make database smaller - sharding
1. Prevent database hit: caching

# Duplication of encoded URL

Currently we use the ID of the record itself as the number for encoding.
This could be an issue when sharding the shorten_url table because there could be ID confliction.

## Solution

Use external service responsible for generating the shorten string ahead of time (based on the needs we estimated).
This lead to another problem: this external service can be malfunction and be a single point of failure
-> Create multiple instances

# Feature expansion

## URL customization

Add a intermediary table, e.g customized_shorten_url.

### Encoding

1. Call encode service for the original URL and get the shorten version.
2. Create a record to customized_shorten_url(customized_url, shorten_url)

### Decoding

1. Fetch shorten_url record using customized_url
2. Fetch original_url using shorten_url

This approach introduces a new step, but the core table, and the core function is not modified, they're extended. We could reuse all functions (e.g: expiration, tracking) for the customized URL

## Expiration

Add `expired_at` column to the shorten_url table

## Tracking and Analysation
