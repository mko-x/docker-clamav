#!/bin/bash
if [ -z ${1} ] ; then
  echo "Repository not set. Provide a repository name in the format 'repo/'"
  exit 1
fi

repo=${1}

docker push ${repo}docker-clamav:buster-slim-amd64
docker push ${repo}docker-clamav:buster-slim-armv7
docker push ${repo}docker-clamav:buster-slim-arm64v8

docker push ${repo}docker-clamav:stretch-slim-amd64
#docker push ${repo}docker-clamav:stretch-slim-armv7
docker push ${repo}docker-clamav:stretch-slim-arm64v8

docker push ${repo}docker-clamav:alpine-amd64
docker push ${repo}docker-clamav:alpine-armv7
docker push ${repo}docker-clamav:alpine-arm64v8

docker push ${repo}docker-clamav:alpine-edge-amd64
docker push ${repo}docker-clamav:alpine-edge-armv7
docker push ${repo}docker-clamav:alpine-edge-arm64v8

echo "Push to docker registry finished."