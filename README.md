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

### Authentication

Backend authentication is based on JWT tokens. See `Token` for how to create a token. To access endpoints that require authentication, you must supply an access token in one of two ways:

- `Authorization` HTTP header using the format `Bearer MY_TOKEN`. This is the preferred way.
- `access_token` parameter in the URL. Example `?access_token=MY_TOKEN`

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

Lists valid public keys.

Reply:

```json
["<RSA public key>"]
```

## License

MIT © 2017 Otto Vehviläinen. See LICENSE for details.
