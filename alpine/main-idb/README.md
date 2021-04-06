# Alpine Main with initialized databases

## Usage

```
    docker pull mkodockx/docker-clamav:alpine-idb-amd64
    docker run -d -p 3310:3310 mkodockx/docker-clamav:alpine-idb-amd64
```

## About

This image provides the clamav alpine image with preloaded databases.

The databases were downloaded just before the build manually as Cloudflares rate limiting blocks automatic downloads with wget,curl etc. even at build time.

Due to it may be possible to bypass the limits somehow I decided to create an image with databases preloaded.

You can find the timestamps within the databasefiles:
- main.cvd - ClamAV-VDB:25 Nov 2019 08-56 -0500
- daily.cvd - ClamAV-VDB:31 Mar 2021 07-24 -0400
- bytecode.cvd - ClamAV-VDB:08 Mar 2021 10-21 -0500
- safebrowsing.cvd - ClamAV-VDB:10 Nov 2019 19-03 -0500

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
