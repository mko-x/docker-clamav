# docker-clamav
![ClamAV Logo](https://www.clamav.net/assets/clamav-trademark.png)

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

# FAQ
## Memory?
Some users are wondering about memory consumption of clamd. Here is an explanation of the reasons I found:

"ClamAV holds the search strings using the classic string (Boyer Moore) and regular expression (Aho Corasick) algorithms. Being algorithms from the 1970s they are extemely memory efficient.

The problem is the huge number of virus signatures. This leads to the algorithms' datastructures growing quite large.

You can't send those datastructures to swap, as there are no parts of the algorithms' datastructures accessed less often than other parts. If you do force pages of them to swap disk, then they'll be referenced moments later and just swap straight back in. (Technically we say "the random access of the datastructure forces the entire datastructure to be in the process's working set of memory".)

The datastructures are needed if you are scanning from the command line or scanning from a daemon.

You can't use just a portion of the virus signatures, as you don't get to choose which viruses you will be sent, and thus can't tell which signatures you will need." 
Source [stackexchange.com](https://unix.stackexchange.com/questions/114709/how-to-reduce-clamav-memory-usage/278110#278110)

It is obvious that an antivirus engine based on virus signatures will raise memory consumption over the time as it always has to check for **all** signatures. As the number of virus signatures grows daily, the amount of necessary memory will increase as well.

## Error during DB update
Several users are experiencing problems during the database updates (incremental,diff,initial).

ClamaV is open source and the databases are provided by a network of mirrors that are hosted for free by some folks to support open source antivirus.

In the past I ran into these database update errors and spent hours of investigation, just to find it working the next hour or the other day. Please think about race conditions, proxy or network misconfiguration and update cycles within the clamav update mirrors - **BEFORE(!)** opening an issue here. 

If you have an error related to the updates on your special OS, machine, iPad ;) or anything special else, first check the [FAQ to clamav troubleshooting](https://www.clamav.net/documents/troubleshooting-faq) and then the [virus database FAQ](https://www.clamav.net/documents/clamav-virus-database-faq.html).

If you keep on getting errors you might try your own [private local mirror](https://www.clamav.net/documents/private-local-mirrors) easily.

# Projects
Several projects are using this image:
- [solita/clamav-rest](https://github.com/solita/clamav-rest)
- [r3kzi/clamav-prometheus-exporter](https://github.com/r3kzi/clamav-prometheus-exporter)
- [US DoD transcom/mymove](https://github.com/transcom/mymove)
- [Inveniem/nextcloud-azure-aks](https://github.com/Inveniem/nextcloud-azure-aks)
- [pivotal.io jzheaux/terracotta-bank](https://github.com/jzheaux/terracotta-bank)
- [Hasso Plattner Institut, Schul Cloud hpi-schul-cloud/antivirus_check_service](https://github.com/hpi-schul-cloud/antivirus_check_service)
- [UK Government Crown-Commercial-Service/ccs-conclave-document-clamav](https://github.com/Crown-Commercial-Service/ccs-conclave-document-clamav)
- [UKHomeOffice/file-vault](https://github.com/UKHomeOffice/file-vault)
- [SICTIAM/stela](https://github.com/SICTIAM/stela)
- [DeloitteDigitalAT/terracotta-bank](https://github.com/DeloitteDigitalAT/terracotta-bank)
- [UK ministryofjustice/moj-clamav-rest](https://github.com/ministryofjustice/moj-clamav-rest)
- [weixian-zhang/Azure-sSFTP](https://github.com/weixian-zhang/Azure-sSFTP)
- [Mattermost](https://github.com/mattermost/mattermost-plugin-antivirus)
- [Province of British Columbia, Transportation Fuels Reporting System (TFRS)](https://github.com/bcgov/tfrs)
- ...

# Thanks

Thank you for using this image. I have only a blink of how many projects are using this, but I know there are some including big tech, governments and many open source. I try to keep it working in my rare spare time. Feel free to participate or get in contact.

# License

For license see file [LICENSE](./LICENSE)
