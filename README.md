# docker-clamav

![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

## Hub
Find new hub image: https://cloud.docker.com/repository/docker/mk0x/docker-clamav

## About
Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to directly connect to *clamav* via TCP port `3310`

## Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

## Releases
Find the latest releases at the [releases](https://github.com/mko-x/docker-clamav/releases) section here in the repository.

## Known Forks

- OpenShift support in [kuanfandevops fork](https://github.com/kuanfandevops/docker-clamav)

## Usage

    docker run -d -p 3310:3310 mk0x/docker-clamav

or linked (recommended)

    docker run -d --name av mk0x/docker-clamav
    docker run -d --link av:av application-with-clamdscan-or-something
    
## docker-compose

See example with Nextcloud at [docker-compose.yml](https://github.com/mko-x/docker-clamav/blob/master/docker-compose.yml).
