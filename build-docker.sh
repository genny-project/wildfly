#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

docker build  --no-cache -t gennyproject/wildfly:${version} . 
#docker build -f DockerfileJRebel  --no-cache -t gennyproject/wildfly:jrebel . 

if [ -z "${1}" ]; then
   docker tag gennyproject/wildfly:latest gennyproject/wildfly:v7.0.0
fi
