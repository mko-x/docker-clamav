# docker-clamav:alpine

![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

## Hub
Find hub image: https://cloud.docker.com/repository/docker/mk0x/docker-clamav

## About

### Alpine
This image offers all the same options like the original one. It is based on Alpine Linux and this time providing easy extensions via configuration files.

### Provides
Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to directly connect to *clamav* via TCP port `3310`

## Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

### Default clamd configuration

```conf
MaxScanSize 300M
MaxFileSize 100M
MaxRecursion 30
MaxFiles 50000
MaxEmbeddedPE 40M
MaxHTMLNormalize 40M
MaxHTMLNoTags 2M
MaxScriptNormalize 5M
MaxZipTypeRcg 1M
MaxPartitions 128
MaxIconsPE 200
PCREMatchLimit 10000
PCRERecMatchLimit 10000
```

## ClamAV Configuration
The basic configuration is now optimized for average requirements. It scans mails as well as PDF, executables, archives, html and more.

## Releases
Find the latest releases at the official [docker hub](https://hub.docker.com/r/mk0x/docker-clamav) registry.

## Usage

```bash
    docker run -d -p 3310:3310 mk0x/docker-clamav:alpine
```

or linked (recommended)
```bash
    docker run -d --name av mk0x/docker-clamav:alpine
    docker run -d --link av:av application-with-clamdscan-or-something:alpine
```
    
## docker-compose

See example with Nextcloud at [docker-compose.yml](https://github.com/mko-x/docker-clamav/blob/alpine/docker-compose.yml).

You can simply provide your own configurations via volume substitution.

# Use it with custom configurations of clamd and freshclam

Start with this one in your own Dockerfile:

```Dockerfile
FROM mk0x/docker-clamav:alpine
COPY your/clamd.conf /etc/clamav/clamd.conf
COPY your/freshclam.conf /etc/clamav/freshclam.conf

```
