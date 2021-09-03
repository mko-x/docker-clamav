# docker-clamav
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-17-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
![ClamAV Logo](https://www.clamav.net/assets/clamav-trademark.png)

![ClamAV latest.stable](https://img.shields.io/badge/ClamAV-latest.stable-brightgreen.svg?style=flat-square)

[![CI-Build](https://github.com/mko-x/docker-clamav/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/mko-x/docker-clamav/actions/workflows/build-and-push.yml)

Dockerized open source antivirus daemons for use with 
- file sharing containers like [Nextcloud](https://hub.docker.com/_/nextcloud/) or 
- to use it via a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) proxy like [@solita](https://github.com/solita) made [clamav-rest](https://github.com/solita/clamav-rest) or
- to check files on a server via e.g. node.js [kylefarris/clamscan](https://github.com/kylefarris/clamscan)
- to directly connect to *clamav* via TCP port `3310`

ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the virus signature database. `clamd` itself
is listening on exposed port `3310`.

# Releases
Find the latest releases at the official [docker hub](https://hub.docker.com/r/mkodockx/docker-clamav) registry. There are different releases for the different platforms.

With special thanks to [@WhiteBahamut](https://github.com/WhiteBahamut) you will find versioned builds to pin to for production use at docker hub.

# Usage
The container run as user `clamav` with `uid=101` and `gid=102`.

## Debian (default, :latest, :buster-slim, :stretch-slim)
- buster-slim
- stretch-slim
```bash
    docker run -d -p 3310:3310 mkodockx/docker-clamav:buster-slim
```

## Alpine (:alpine, :alpine-edge, :alpine-main-idb-amd64)
- alpine
- alpine-idb-amd64 (initialized databases, [more info](alpine/main-idb/README.md))
- alpine-edge
```bash
    docker run -d -p 3310:3310 mkodockx/docker-clamav:alpine
```

## Prefer alpine-idb-amd64

Joel Esler from Cisco (main hosts of ClamAV):

**Downloading using other than FreshClam has now been limited.**


FreshClam supports the Cdiff system, the cdiff system allows for small micro 
updates to rebuild your daily.cvd instead of downloading the whole daily.cvd 
and main.cvd.

Abuse of the download system has forced us to push people towards FreshClam.  
Unfortunately a handful have ruined it for everyone.  (Looking at you, handful 
of IPs that download the daily.cvd 3x a second)

We cannot continue to transfer 9PB of traffic a month.

Further enhancements to Freshclam are planned to take advantage of, and handle 
our mirror infrastructure more politely.  More details will be published about 
this soon.  In the meantime, please immediately discontinue the use of other 
command line downloading systems and use FreshClam.

So to clarify:

1. Rate limiting around daily.cvd, main.cvd, and super excessive cdiff 
downloading is now in place.  If you are getting “429” back from Cloudflare - 
you are part of the problem.
2. Use of Wget, Curl, and the link is now severely limited.
3. Use FreshClam
4. We’re modifying FreshClam in upcoming releases to deal with this problem 
better.
5. See #3

--
Joel Esler
Manager, Communities Division
Cisco Talos Intelligence Group
http://www.talosintelligence.com | https://www.snort.org

> On Mar 3, 2021, at 9:57 AM, Joel Esler (jesler) via clamav-users 
> <clamav-users@lists.clamav.net> wrote:
> 
> Signed PGP part
> All —
> 
> I’ve had to be more stringent on the rate limiting for the daily.cvd and 
> main.cvd files.  It seems that some people either have stuck cron jobs (or 
> are doing it on purpose) and downloading the full file 200k-300k times a day.
> 
> We release AV updates once a day, in an emergency slightly more than that.  
> There is no reason for this.  I’ve had to lower the amount of connections you 
> are allowed, and raise the amount of time you are blocked.
> 
> If you are being blocked with a 429 code from the ClamAV update system, and 
> you believe your system isn’t broken, and have a valid reason to download 
> that much.
> 
> 1. Feel free to reach out to me via 1:1 or via this list.
> 2. Consider setting up a local mirror on your network.
> 
> Repeat:  You need to be using freshclam, and freshclam only.  It needs to 
> check the DNS for the presence of an update, and you need to be downloading 
> the diff files.  There’s no reason to download the full main and daily.
> 
> --
> Joel Esler
> Manager, Communities Division
> Cisco Talos Intelligence Group
> http://www.talosintelligence.com | https://www.snort.org
> 
> 

Source: https://www.mail-archive.com/clamav-users@lists.clamav.net/msg49810.html

With alpine-idb-amd64 image you download data just from docker hub not from clamav initially.

## Linkage (deprecated)
Linked usage was recommended, to not expose the port to "everyone". Now it is legacy and will be removed some time. Use networks instead.
```bash
    docker run -d --name av mkodockx/docker-clamav(:alpine)
    docker run -d --link av:av application-with-clamdscan-or-something
```
## Networks

There are several possibilities to use the network configuration. Out of the box the host network should fit your needs to connect any client to the ClamAV daemon.

If you need more information, follow instructions at [docker manuals](https://docs.docker.com/network/).

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

ClamaV is open source and the databases are provided by a network of mirrors that are hosted for free by some folks (Cisco) to support open source antivirus. That was about 9 PB a month. That is why downloads are now protected by Cloudflare. If you're downloading too often you will recieve 429 errors. (See ## Prefer alpine-idb-amd64 at the top of this document)

If you have an error related to the updates on your special OS, machine, iPad ;) or anything special else, first check the [FAQ to clamav troubleshooting](https://www.clamav.net/documents/troubleshooting-faq) and then the [virus database FAQ](https://www.clamav.net/documents/clamav-virus-database-faq.html).

If you keep on getting errors you might try your own [private local mirror](https://www.clamav.net/documents/private-local-mirrors) easily.

### alpine-idb-amd64

If you have problems with freshclam downloads use the alpine image with initialized dbs. [more info](alpine/main-idb/README.md)

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

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/mchus"><img src="https://avatars.githubusercontent.com/u/2232148?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mikhail Chus</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=mchus" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/DavidJFowler"><img src="https://avatars.githubusercontent.com/u/10775668?v=4?s=100" width="100px;" alt=""/><br /><sub><b>DavidJFowler</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=DavidJFowler" title="Code">💻</a></td>
    <td align="center"><a href="http://ericmason.net"><img src="https://avatars.githubusercontent.com/u/17150?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Eric Mason</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=ericmason" title="Code">💻</a></td>
    <td align="center"><a href="https://www.peterdavehello.org/"><img src="https://avatars.githubusercontent.com/u/3691490?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Peter Dave Hello</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=PeterDaveHello" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/eht16"><img src="https://avatars.githubusercontent.com/u/617017?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Enrico Tröger</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=eht16" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/WhiteBahamut"><img src="https://avatars.githubusercontent.com/u/38832027?v=4?s=100" width="100px;" alt=""/><br /><sub><b>WhiteBahamut</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=WhiteBahamut" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/braiinzz"><img src="https://avatars.githubusercontent.com/u/9280042?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Manuel Habert</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=braiinzz" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://kaiser.me"><img src="https://avatars.githubusercontent.com/u/238631?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nico Kaiser</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=nicokaiser" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/scholzie"><img src="https://avatars.githubusercontent.com/u/6815040?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Chris Scholz</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=scholzie" title="Code">💻</a></td>
    <td align="center"><a href="http://mohamedsahbi.com"><img src="https://avatars.githubusercontent.com/u/25180044?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mohamed Sahbi</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=MohamedSahbi" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/scp-mb"><img src="https://avatars.githubusercontent.com/u/52526733?v=4?s=100" width="100px;" alt=""/><br /><sub><b>scp-mb</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=scp-mb" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/uphlewis"><img src="https://avatars.githubusercontent.com/u/43346009?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Harry</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=uphlewis" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/bushong1"><img src="https://avatars.githubusercontent.com/u/236700?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Charles Bushong</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=bushong1" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Capusjon"><img src="https://avatars.githubusercontent.com/u/21157144?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Capusjon</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=Capusjon" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://codelobe.io"><img src="https://avatars.githubusercontent.com/u/6046654?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Adam Beck</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=adam-beck" title="Code">💻</a></td>
    <td align="center"><a href="https://alicef.me"><img src="https://avatars.githubusercontent.com/u/107572?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alice Ferrazzi</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=aliceinwire" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/timopick"><img src="https://avatars.githubusercontent.com/u/8996684?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Timo Pick</b></sub></a><br /><a href="https://github.com/mko-x/docker-clamav/commits?author=timopick" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!