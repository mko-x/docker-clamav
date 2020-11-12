#!/bin/bash

if [ -z ${1} ] ; then
  echo "Repository not set. Provide a repository name in the format 'repo/'"
  exit 1
fi

docker run --rm --privileged multiarch/qemu-user-static:register --reset

repo=${1}

docker build -t ${repo}docker-clamav:buster-slim-amd64 debian/buster/
docker build -t ${repo}docker-clamav:buster-slim-armv7 -f debian/buster/Dockerfile.arm32v7 debian/buster/
docker build -t ${repo}docker-clamav:buster-slim-arm64v8 -f debian/buster/Dockerfile.arm64v8 debian/buster/

#armv7 cause problems in the moment
docker build -t ${repo}docker-clamav:stretch-slim-amd64 debian/stretch/
#docker build -t ${repo}docker-clamav:stretch-slim-armv7 -f debian/stretch/Dockerfile.arm32v7 debian/stretch/
docker build -t ${repo}docker-clamav:stretch-slim-arm64v8 -f debian/stretch/Dockerfile.arm64v8 debian/stretch/


docker build -t ${repo}docker-clamav:alpine-amd64 alpine/main/
docker build -t ${repo}docker-clamav:alpine-armv7 -f alpine/main/Dockerfile.arm32v7 alpine/main/
docker build -t ${repo}docker-clamav:alpine-arm64v8 -f alpine/main/Dockerfile.arm64v8 alpine/main/


docker build -t ${repo}docker-clamav:alpine-edge-amd64 alpine/edge/
docker build -t ${repo}docker-clamav:alpine-edge-armv7 -f alpine/edge/Dockerfile.arm32v7 alpine/edge/
docker build -t ${repo}docker-clamav:alpine-edge-arm64v8 -f alpine/edge/Dockerfile.arm64v8 alpine/edge/


