# docker-clamav

![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

## About
Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to directly connect to *clamav* via TCP port `3310`

## Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

## Usage

    docker run -d -p 3310:3310 mkodockx/docker-clamav

or linked (recommended)

    docker run -d --name av mkodockx/docker-clamav
    docker run -d --link av:av application-with-clamdscan-or-something
    
## docker-compose

See example with Nextcloud at [docker-compose.yml](https://github.com/mko-x/docker-clamav/blob/master/docker-compose.yml).