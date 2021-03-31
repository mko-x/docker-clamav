#!/bin/bash

docker run --rm --privileged multiarch/qemu-user-static:register --reset

repo=mkodockx/

docker build -t mkodockx/docker-clamav:buster-slim-amd64 debian/buster/
docker build -t mkodockx/docker-clamav:buster-slim-armv7 -f debian/buster/Dockerfile.arm32v7 debian/buster/
docker build -t mkodockx/docker-clamav:buster-slim-arm64v8 -f debian/buster/Dockerfile.arm64v8 debian/buster/

#armv7 cause problems in the moment
docker build -t mkodockx/docker-clamav:stretch-slim-amd64 debian/stretch/
#docker build -t mkodockx/docker-clamav:stretch-slim-armv7 -f debian/stretch/Dockerfile.arm32v7 debian/stretch/
docker build -t mkodockx/docker-clamav:stretch-slim-arm64v8 -f debian/stretch/Dockerfile.arm64v8 debian/stretch/


docker build -t mkodockx/docker-clamav:alpine-amd64 alpine/main/
docker build -t mkodockx/docker-clamav:alpine-armv7 -f alpine/main/Dockerfile.arm32v7 alpine/main/
docker build -t mkodockx/docker-clamav:alpine-arm64v8 -f alpine/main/Dockerfile.arm64v8 alpine/main/

docker build -t mkodockx/docker-clamav:alpine-idb-amd64 alpine/main-idb/
docker build -t mkodockx/docker-clamav:alpine-idb-armv7 -f alpine/main-idb/Dockerfile.arm32v7 alpine/main-idb/
docker build -t mkodockx/docker-clamav:alpine-idb-arm64v8 -f alpine/main-idb/Dockerfile.arm64v8 alpine/main-idb/


docker build -t mkodockx/docker-clamav:alpine-edge-amd64 alpine/edge/
docker build -t mkodockx/docker-clamav:alpine-edge-armv7 -f alpine/edge/Dockerfile.arm32v7 alpine/edge/
docker build -t mkodockx/docker-clamav:alpine-edge-arm64v8 -f alpine/edge/Dockerfile.arm64v8 alpine/edge/


