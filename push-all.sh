#!/bin/bash

docker push mkodockx/docker-clamav:buster-slim-amd64
docker push mkodockx/docker-clamav:buster-slim-armv7
docker push mkodockx/docker-clamav:buster-slim-arm64v8

docker push mkodockx/docker-clamav:stretch-slim-amd64
#docker push mkodockx/docker-clamav:stretch-slim-armv7
docker push mkodockx/docker-clamav:stretch-slim-arm64v8

docker push mkodockx/docker-clamav:alpine-amd64
docker push mkodockx/docker-clamav:alpine-armv7
docker push mkodockx/docker-clamav:alpine-arm64v8

docker push mkodockx/docker-clamav:alpine-idb-amd64
docker push mkodockx/docker-clamav:alpine-idb-armv7
docker push mkodockx/docker-clamav:alpine-idb-arm64v8

docker push mkodockx/docker-clamav:alpine-edge-amd64
docker push mkodockx/docker-clamav:alpine-edge-armv7
docker push mkodockx/docker-clamav:alpine-edge-arm64v8

echo "Push to docker registry finished."