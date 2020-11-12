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

if ! test -f manifest-tool ; then
  echo Ensure compatible version of manifest tool https://github.com/estesp/manifest-tool
  curl -Lo manifest-tool https://github.com/estesp/manifest-tool/releases/download/v1.0.3/manifest-tool-linux-amd64
  chmod +x manifest-tool
fi

./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:buster-slim-ARCHVARIANT \
    --target ${repo}docker-clamav:buster-slim

./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:buster-slim-ARCHVARIANT \
    --target ${repo}docker-clamav:latest
    
./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm64/v8 \
    --template ${repo}docker-clamav:stretch-slim-ARCHVARIANT \
    --target ${repo}docker-clamav:stretch-slim

./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:alpine-ARCHVARIANT \
    --target ${repo}docker-clamav:alpine

./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:alpine-edge-ARCHVARIANT \
    --target ${repo}docker-clamav:alpine-edge
    