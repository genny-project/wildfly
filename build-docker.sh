#!/bin/bash

ver=`git rev-parse --abbrev-ref HEAD`
if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

docker build  --no-cache -t gennyproject/wildfly:${version} . 

if [ -z "${version}" ]; then
    docker tag gennyproject/wildfly:${version} gennyproject/wildfly:latest
    docker tag gennyproject/wildfly:${version} gennyproject/wildfly:${ver}
fi

#docker build -f DockerfileJRebel  --no-cache -t gennyproject/wildfly:jrebel . 
