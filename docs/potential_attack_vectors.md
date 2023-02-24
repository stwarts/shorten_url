# Access Control

The API could return "sentitive" data to anonymous user.
e.g: the owner data

## Solution

Apply authorization layer

# URL Enumeration

As we assign a number for each input URL, people could enumerate all the shorten URLs.

E.g: they can run a loop from 0 to 100.000.000 to list all shorten link from the other users.

## Solution

1. Rate limit in combination with checking requesting IP addresses.
2. Add "salt" to encoded number if this is a crucial concern

# Denial of Service

## Causes

The application may be bloated by allowing anonymous users to use /encode API.
The /decode API could run to the same problem.

## Solution

1. Rate limit for anonymous users and signed in user.
2. Block IP address.

# Redirection flood

```
long_url_a -> short.est/1
short.est/1 -> short.est/2
short.est/2 -> short.est/3
...
short.est/1000 -> short.est/10001
```

This could be a real problem if we provide redirecting service.
