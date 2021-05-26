# Alpine Main with initialized databases

Latest pushed image:

**mkodockx/docker-clamav:alpine-idb-amd64-v2021-05-25**

## Usage

```
    docker pull mkodockx/docker-clamav:alpine-idb-amd64
    docker run -d -p 3310:3310 mkodockx/docker-clamav:alpine-idb-amd64
```

## Updates

As the files are too big for github I need to build the stuff on my machine and push it to the hub manually. This will happen from time to time on my very own schedule.

The builds are tagged with the date of creation to allow sticking to a special version. Every new build is based on the latest regular alpine image.

## About

This image provides the clamav alpine image with preloaded databases.

The databases were downloaded just before the build manually as Cloudflares rate limiting blocks automatic downloads with wget,curl etc. even at build time.

Due to it may be possible to bypass the limits somehow I decided to create an image with databases preloaded.

You can find the timestamps within the databasefiles. The latest version timestamps are shown below:
- main.cvd - ClamAV-VDB:25 Nov 2019 08-56 -0500
- daily.cvd - ClamAV-VDB:25 May 2021 07-17 -0400
- bytecode.cvd - ClamAV-VDB:08 Mar 2021 10-21 -0500
- safebrowsing.cvd - ClamAV-VDB:31 Mar 2021 15-11 -0400

## GitHub.com size limits
Github.com has a maximum filesize of 100 MB.

main.cvd and daily.cvd are both > 100 MB and can't be provided here.

## Target

This image targets usecases where download size doesn't matter. 

It works out of the box, even if there is no internet connection at startup time or a server connection problem. You might not have the latest signatures but at least most of them.

## History

See #103 for more reasons.

## ARM architectures

As I'm not that familiar with qemu I didn't get the ARM builds to work yet. Feel free to improve that if you need an ARM version.
