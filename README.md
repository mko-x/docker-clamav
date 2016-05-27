# docker-clamav

![ClamAV 0.99.2](https://img.shields.io/badge/ClamAV-0.99.2-brightgreen.svg?style=flat-square)

##About
Dockerized open source antivirus for use with file sharing containers.

##Description
ClamAV daemon as a Docker image. It *builds* with a current virus database and
*runs* `freshclam` in the background constantly updating the database. `clamd` 
is listening on exposed port `3310`.

##Usage

    docker run -d -p 3310:3310 mkodockx/docker-clamav
    
or linked (recommended)

    docker run -d --name av mkodockx/docker-clamav
    docker run -d --link av:clamavd application-with-clamdscan-or-something

##More Info
Inspired by work of (dinkel)[https://github.com/dinkel]