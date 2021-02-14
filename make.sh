#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

docker build -t demoncat/onec:full-"$ONEC_VERSION" \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg VERSION="$ONEC_VERSION" .

docker build -t demoncat/onec:full-"$ONEC_VERSION"-k8s --build-arg VERSION="$ONEC_VERSION" -f Dockerfile_k8s .
 