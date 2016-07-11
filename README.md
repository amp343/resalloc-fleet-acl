# Fleet ACL

## Overview

This repo is the app that is built into the `amp343/fleet-acl` image, which
in the homework problem, runs on container `acl`.

This app manages user -> lease access to the fleet of server resources (github link)

I chose to write `fleet-acl` using Ruby/Rails-API because Rails-API is well suited for quickly
bootstrapping a fairly robust application. The fact that `fleet-acl` should perform
authentication, manage a DB of stateful server resources records, and serve
those records restfully over an API to multiple clients (the CLI tool, as well as the
fleet servers themselves) is what motivated that choice.

## API

### Authentication

#### `GET /resources`

Get information about all known server resources

**Request**

| **Method** | **Path** | **Auth required?** |
| --- | --- | --- |
| `GET` | `/resources` | `none` |

**Response**

| **Status** | **Description** |
| --- | --- |
| `200` | An array of all server resource records |

**Example**

```
[
  {
    "id": 1,
    "name": "server1",
    "os": "linux/alpine",
    "is_available": true,
    "leased_at": null,
    "leased_until": null,
    "lease_time_remaining": "00:00:00",
    "leased_to_user": null
  },
  {
    "id": 2,
    "name": "server2",
    "os": "linux/jessie",
    "is_available": true,
    "leased_at": null,
    "leased_until": null,
    "lease_time_remaining": "00:00:00",
    "leased_to_user": null
  },
  {
    "id": 3,
    "name": "server3",
    "os": "linux/wheezy",
    "is_available": true,
    "leased_at": null,
    "leased_until": null,
    "lease_time_remaining": "00:00:00",
    "leased_to_user": null
  },
  {
    "id": 4,
    "name": "server4",
    "os": "linux/precise",
    "is_available": true,
    "leased_at": "2016-07-10T02:50:22.464Z",
    "leased_until": null,
    "lease_time_remaining": "00:00:00",
    "leased_to_user": null
  },
  {
    "id": 5,
    "name": "server5",
    "os": "linux/trusty",
    "is_available": false,
    "leased_at": "2016-07-10T02:50:22.465Z",
    "leased_until": "2016-07-10T04:50:22+00:00",
    "lease_time_remaining": "01:24:21",
    "leased_to_user": "someone.else@email.com"
  }
]
```

#### `GET /resources/:name`

Get information about a single server resource by name,
ie, `server1`

**Request**

| **Method** | **Path** | **Auth required?** |
| --- | --- | --- |
| `GET` | `/resources/:name` | `none` |

**Response**

| **Status** | **Description** |
| --- | --- |
| `200` | A single server resource record |
| `404` | The requested server resource was not found |

**Example**

```
{
  "id": 4,
  "name": "server4",
  "os": "linux/precise",
  "is_available": true,
  "leased_at": "2016-07-10T02:50:22.464Z",
  "leased_until": null,
  "lease_time_remaining": "00:00:00",
  "leased_to_user": null
}
```

#### `POST /resources/:name/lease`

For the authenticated user, lease the server resource matching
the given name.

**Request**

| **Method** | **Path** | **Auth required?** |
| --- | --- | --- |
| `POST` | `/resources/:name/lease` | `basic` |

**Response**

| **Status** | **Description** |
| --- | --- |
| `200` | The successfully leased server resource record |
| `401` | Unauthorized error, on basic auth failure |
| `404` | The requested server resource was not found |
| `409` | The requested server resource is not available due to a leasing conflict |

**Example**

```
{
  "id": 4,
  "name": "server4",
  "os": "linux/precise",
  "is_available": false,
  "leased_at": "2016-07-10T02:50:22.464Z",
  "leased_until": "2016-07-10T02:53:22+00:00",
  "lease_time_remaining": "02:00:00",
  "leased_to_user": "you@email.com"
}
```

#### `DELETE /resources/:name/lease`

**Request**

| **Method** | **Path** | **Auth required?** |
| --- | --- | --- |
| `DELETE` | `/resources/:name/lease` | `basic` |

**Response**

| **Status** | **Description** |
| --- | --- |
| `200` | The successfully un-leased server resource record |
| `401` | Unauthorized error, on basic auth failure |
| `404` | The requested server resource was not found |
| `409` | You cannot un-lease the requested server resource because it is not leased to you |

**Example**

```
{
  "id": 4,
  "name": "server4",
  "os": "linux/precise",
  "is_available": true,
  "leased_at": "2016-07-10T02:50:22.464Z",
  "leased_until": null,
  "lease_time_remaining": "00:00:00",
  "leased_to_user": null
}
```

## Interesting code

Any interesting code here probably lives in `./src/app`, since much of the rest is boilterplate.
Even still, there's not too much in there, but that's by design.

## Caveats

There is no persistent state for server leasing beyond the lifecycle of a container.

If you were to start the `acl` container, lease a server with the `resalloc` CLI tool,
then restart the container, that record of that lease would no longer exist.
