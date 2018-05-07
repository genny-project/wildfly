#!/bin/bash
if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

docker push gennyproject/wildfly:"${version}"
docker tag gennyproject/wildfly:"${version}" gennyproject/wildfly:latest
docker push gennyproject/wildfly:latest
