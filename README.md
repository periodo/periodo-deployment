# Server architecture for PeriodO

## Fly.io

PeriodO is deployed on [Fly](https://fly.io/). Fly hosts **apps**,
which may be distributed over multiple **machines**. Each kind of
machine is defined by a Dockerfile. These Dockerfiles can be found in
the linked repositories for the various apps listed below.

Apps are grouped into **organizations**. Machines that are parts of
apps within the same organization can communicate using unencrypted
HTTP via a private network. All the apps listed below are in the
‘periodo‘ organization.

For each of the apps listed below, there is `-dev` version reachable
on the `staging.perio.do` subdomain. For example, `periodo-client-dev`
is reachable at
[`client.staging.perio.do`](https://client.staging.perio.do/).

## Publicly reachable apps

The machines running these apps have public IPv6 and shared IPv4 addresses.

Currently these apps run only in the `IAD` (Ashburn, Virginia, USA)
region, but in the future they may run in multiple regions
(e.g. `AMS`, `NRT`).

1. [**`periodo-client`**](https://github.com/periodo/periodo-client)
   ([`client.perio.do`](https://client.perio.do/))

    * Nginx server serving JavaScript, images, maptiles, etc. for the
     PeriodO web client.

1. [**`periodo-proxy`**](https://github.com/periodo/periodo-proxy)
   ([`data.perio.do`](https://data.perio.do/))

    * Nginx server that acts as a caching reverse for `periodo-server`
     (see below), which it accesses via IPv6 on the private network.
    * Has an attached volume for the HTTP cache.
    * In addition to the primary nginx process, there is an HTTP cache
     purging service reachable at
     `<region>.periodo-proxy.internal:8081` on the private network.

1. [**`periodo-corsproxy`**](https://github.com/periodo/periodo-corsproxy)
   ([`corsproxy.perio.do`](https://corsproxy.perio.do/))

    * Nginx server proxying requests to and responses from linked data
     servers that do not properly implement CORS.

1. [**`periodo-legacy-subdomain`**](https://github.com/periodo/periodo-legacy-subdomain)
   ([`test.perio.do`](https://test.perio.do/))

    * Nginx server redirecting requests to legacy PeriodO URLs.

## Internally reachable apps

The machines running these apps only have private IPv6 addresses, and no
public domain names or HTTPS certificates.

These apps run only in the `IAD` region.

1. [**`periodo-server`**](https://github.com/periodo/periodo-server)
   (`periodo-server.flycast`)

    * Flask HTTP server implementing PeriodO versioning and submission
      management.
    * Accesses `periodo-translator` (see below) and the cache purging
   service (see `periodo-proxy` above) via IPv6 on the private
   network.
    * Has an attached volume for the database.

1. [**`periodo-translator`**](https://github.com/periodo/periodo-translator)
   (`periodo-translator.flycast`)

    * Java HTTP server implementing long-running and memory-hungry
      serializations of the PeriodO dataset to Turtle and CSV.
    * This server stops running when not in use, which should be most
      of the time.
