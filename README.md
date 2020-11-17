# docker-clamav
![ClamAV Logo](http://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to directly connect to *clamav* via TCP port `3310`

ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

# Releases
Find the latest releases at the official [docker hub](https://hub.docker.com/r/mkodockx/docker-clamav) registry. There are different releases for the different platforms.

# Usage
The container run as user `clamav` with `uid=101` and `gid=102`.

## Debian (default, :latest, :buster-slim, :stretch-slim)
- buster-slim
- stretch-slim
```bash
    docker run -d -p 3310:3310 mkodockx/docker-clamav:buster-slim
```

## Alpine (:alpine, :alpine-edge)
- alpine
- alpine-edge
```bash
    docker run -d -p 3310:3310 mkodockx/docker-clamav:alpine
```


Linked usage recommended, to not expose the port to "everyone".
```bash
    docker run -d --name av mkodockx/docker-clamav(:alpine)
    docker run -d --link av:av application-with-clamdscan-or-something
```

## Environment VARs

### Proxy
Thanks to @mchus proxy configuration is possible.
- HTTPProxyServer: Allows to set a proxy server
- HTTPProxyPort: Allows to set a proxy server port

### Database Mirror
Specifying a particular mirror for freshclam is also possible.
- DatabaseMirror: Hostname of the mirror web server.

### Custom Configuration Files
Mount custom configuration files into the container.
- FRESHCLAM_CONF_FILE: Path to custom `freshclam.conf` file, e.g. `/mnt/freshclam.conf`. 
- CLAMD_CONF_FILE: Set the path to a custom `clamd.conf` file, e.g. `/mnt/clamd.conf`.

## Persistency
Virus update definitions are stored in `/var/lib/clamav`. To store the defintion just mount the directory as a volume, `docker run -d -p 3310:3310 -v ./clamav:/var/lib/clamav mkodockx/docker-clamav:latest`

## docker-compose
See example with Nextcloud at [docker-compose.yml](https://github.com/mko-x/docker-clamav/blob/master/docker-compose.yml). You still need to configure the *AntiVirus files* app in Nextcloud.

You can find a tutorial here: https://www.virtualconfusion.net/clamav-for-nextcloud-on-docker/

## Healthcheck
The images provide with `check.sh` a file to check for the healthyness of the running container. To enable the health check configure your `docker run` or `compose file`. The _start period_ should be adjusted to your system needs. Slow internet connection, with limited cpu and IO speed might require larger values.


### Examples
Via docker run:

```
docker run --health-cmd=./check.sh \
            --health-start-period=120s \
            --health-interval=60s \
            --health-retries=3 \
            -p 3310:3310 mkodockx/docker-clamav:alpine`
```

Via docker-compose
```yml
  services:
    clamav:
      healthcheck:
        test: ["CMD", "./check.sh"]
        interval: 60s
        retries: 3
        start_period: 120s
```

# Build multi-arch
This image provides support for different platforms 
- x86
- amd64
- arm32v7
- arm64v8

# Known Forks
- OpenShift support in [kuanfandevops fork](https://github.com/kuanfandevops/docker-clamav)
