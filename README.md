# docker-clamav

![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

## About
Dockerized open source antivirus daemons for use with 
- file sharing containers or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like @lokori made [clamav-rest](https://hub.docker.com/r/lokori/clamav-rest/).

## Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd`
is listening on exposed port `3310`.

## Usage

    docker run -d -p 3310:3310 mkodockx/docker-clamav

or linked (recommended)

    docker run -d --name av mkodockx/docker-clamav
    docker run -d --link av:clamavd application-with-clamdscan-or-something
    
## docker-compose

See example with OwnCloud at [docker-compose.yml](docker-compose.yml).

## More Info
Inspired by work of [dinkel](https://github.com/dinkel)
