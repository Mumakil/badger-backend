# BADGER! backend

[![Build Status](https://travis-ci.org/Mumakil/badger-backend.svg?branch=master)](https://travis-ci.org/Mumakil/badger-backend)

This is the backend for BADGER! mobile app. Badger allows you to create groups, create badges within those groups and grant them to other members.

## Dependencies

- Ruby 2.4.1 (rbenv or similar recommended)
- Postgresql
- Obtain `config/secrets.yml.key`

## Running

- Launch server: `bin/rails s`
- Launch console: `bin/rails c`
- Run tests: `bin/rspec`
- Run rubocop linters: `bin/rubocop`

## API

### Basics

#### Authentication

Backend authentication is based on JWT tokens. See `Token` for how to create a token. To access endpoints that require authentication, you must supply an access token in one of two ways:

- `Authorization` HTTP header using the format `Bearer MY_TOKEN`. This is the preferred way.
- `access_token` parameter in the URL. Example `?access_token=MY_TOKEN`

#### Errors

Here is a short list of usual error codes used as HTTP statuses:

- `400` usually a validation error or missing data.
- `401` invalid or missing authentication token. If a token was used, a new one should be created.
- `404` not found, the resource does not exist or the viewer has no access to it.

### Tokens

Facebook access tokens can be exchanged to actual application access tokens.

The JWT tokens are encrypted using RSA keys and `RS512` algorithm.

#### `POST /tokens`

Creates an access token.

Parameters:

- `strategy` - currently only `facebook` supported.
- `access_token` - Facebook access token

Reply:

```json
{"token": "<JWT token>"}
```

### Public keys

RSA public keys corresponding to the private keys used to encrypt the JWT tokens can be listed from the API.

#### `GET /public_keys`

Lists valid public keys. Does not require authentication.

Reply:

```json
["<RSA public key>"]
```

### Users

#### `GET /user/:id`

Shows a user's information. A special id `me` can be used to show current user's information. Shows basic information for all users, and a bit more details of yourself.

Reply:

```json
{
  "id": 1,
  "name": "Some user",
  "avatar_url": "https://example.com/avatar.jpg"
}
```

### Groups

#### `GET /groups/:id`

Shows a single group. One can only access groups they are part of.

Reply:

```json
{
  "id": 1,
  "name": "Example group of awesomeness",
  "photo_url": "https://example.com/photo.jpg",
  "creator": {
    "id": 1,
    "name": "Some user",
    "avatar_url": "https://example.com/avatar.jpg"
  },
  "members": [
    {
      "id": 1,
      "name": "Some user",
      "avatar_url": "https://example.com/avatar.jpg"
    }
  ]
}
```

#### `POST /groups`

Creates a new group. The creator is auomatically added as a member.

Params:

- `name` - group name. Required.
- `photo_url` - group photo.

Reply: same as show action.

#### `PUT /groups/:id`

Updates group information. Any member of the group can update the details.

Params:

- `name` - group name.
- `photo_url` - group photo.

Reply: same as show action except members.

### Group codes

#### `PUT /groups/:group_id/code`

Regenerates the group code.

Reply: same as show action.

## License

MIT © 2017 Otto Vehviläinen. See LICENSE for details.
