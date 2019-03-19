build-lists: true
slide-dividers: #

# -

![fit](./img/cover.jpg)

# Agenda

Errors in GraphQL Vs. Elm
Live Code Example
Q&A

# GraphQL Errors

```json
{
  "errors": [
    {
      "message": "Name for character with ID 1002 could not be fetched.",
      "locations": [{ "line": 6, "column": 7 }],
      "path": ["hero", "heroFriends", 1, "name"]
    }
  ]
}
```

- List of errors
- Line number
- Points to problematic field
- Message

# The Problem With GraphQL Errors

```json
{
  "errors": [
    {
      "message": "Name for character with ID 1002 could not be fetched.",
      "locations": [{ "line": 6, "column": 7 }],
      "path": ["hero", "heroFriends", 1, "name"]
    }
  ]
}
```

- Untyped (`message` is just a `String`)
- Useful for devs, not presentable to users
- `null`s out other data

# Errors in Elm

```elm
type Result error value
     = Err error
     | Ok value
```

- Elm errors are just a type of data
- ```
  case result of
      Err error -> ...
      Ok value -> ...
  ```

* GraphQL Errors are control flow

# GraphQL Errors in Action

# Rules of Thumb for GraphQL Errors

- **It's a GraphQL Error If...**
  - Only developers should see it
  - You don't expect it and want to log/track it
- **It's GraphQL Data If...**
  - A user will see it
  - You expect it

^ Can't blindly display the error to the user
^ Scanning for a specific value is scraping data

# Live Demo

# Other Examples

- Form validation
  - Unique username (server needs to check)
  - Already checked, should never fail
- Authentication
- There is an HTTP error code that describes the problem...

# Questions?
