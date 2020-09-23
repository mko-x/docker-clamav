#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset

if [ -z ${1} ] ; then
  echo "Repository not set. Provide a repository name in the format 'repo/'"
  exit 1
fi

repo=${1}

docker build -t ${repo}docker-clamav:buster-slim-amd64 debian/buster/
docker build -t ${repo}docker-clamav:buster-slim-armv7 -f debian/buster/Dockerfile.arm32v7 debian/buster/
docker build -t ${repo}docker-clamav:buster-slim-arm64v8 -f debian/buster/Dockerfile.arm64v8 debian/buster/

docker push ${repo}docker-clamav:buster-slim-amd64
docker push ${repo}docker-clamav:buster-slim-armv7
docker push ${repo}docker-clamav:buster-slim-arm64v8

docker build -t ${repo}docker-clamav:stretch-slim-amd64 debian/stretch/
docker build -t ${repo}docker-clamav:stretch-slim-armv7 -f debian/stretch/Dockerfile.arm32v7 debian/stretch/
docker build -t ${repo}docker-clamav:stretch-slim-arm64v8 -f debian/stretch/Dockerfile.arm64v8 debian/stretch/

docker push ${repo}docker-clamav:strech-slim-amd64
docker push ${repo}docker-clamav:strech-slim-armv7
docker push ${repo}docker-clamav:strech-slim-arm64v8

if ! test -f manifest-tool ; then
  curl -Lo manifest-tool https://github.com/estesp/manifest-tool/releases/download/v1.0.3/manifest-tool-linux-amd64
  chmod +x manifest-tool
fi

#./manifest-tool push from-spec debian/buster/mainfest.yml
./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:buster-slim-ARCHVARIANT \
    --target ${repo}docker-clamav:buster-slim
    
./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm/v7,linux/arm64/v8 \
    --template ${repo}docker-clamav:stretch-slim-ARCHVARIANT \
    --target ${repo}docker-clamav:stretch-slim
