# docker-clamav

![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

# Optimized

Try the alpine based version:
```bash
    docker run -d -p 3310:3310 mkodockx/docker-clamav:alpine
```

Alpine version reduces foot print to something about less than 5%, compressed size in docker hub is 6.72 MB compared to debian 216.21 MB.

## Alpine edge

Check out latest alpine-edge version (for latest clamav releases):
```bash
    docker run mkodockx/docker-clamav:alpine-edge
```
Hint: Take a look at the [alpine-edge readme](https://github.com/mko-x/docker-clamav/tree/alpine-edge) before using.

## Hub
Find new hub image at [hub.docker.com](https://hub.docker.com/r/mkodockx/docker-clamav)

## About
Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to directly connect to *clamav* via TCP port `3310`

## Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

# Environment VARs

Thanks to @mchus proxy configuration is possible.

- HTTPProxyServer: Allows to set a proxy server
- HTTPProxyPort: Allows to set a proxy server port

## Releases
Find the latest releases at the official [docker hub](https://hub.docker.com/r/mkodockx/docker-clamav) registry.

## Known Forks

- OpenShift support in [kuanfandevops fork](https://github.com/kuanfandevops/docker-clamav)

## Usage

### Debian Buster Slim (default, :latest, :buster-slim)
```bash
    docker run -d -p 3310:3310 mk0x/docker-clamav
```

### Alpine (:alpine)
```bash
    docker run -d -p 3310:3310 mk0x/docker-clamav:alpine
```

## Link
or linked (recommended)
```bash
    docker run -d --name av mkodockx/docker-clamav(:alpine)
    docker run -d --link av:av application-with-clamdscan-or-something
```
    
## docker-compose

See example with Nextcloud at [docker-compose.yml](https://github.com/mko-x/docker-clamav/blob/master/docker-compose.yml).
