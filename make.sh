#!/bin/bash

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

buildImages() {

    

    _ONEC_VERSION=$1
    docker build -t thedemoncat/onec/full:"$_ONEC_VERSION" \
        --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
        --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
        --build-arg ONEC_VERSION="$_ONEC_VERSION" .

    docker build -t thedemoncat/onec/full:"$_ONEC_VERSION"-k8s \
        --build-arg ONEC_VERSION="$_ONEC_VERSION" -f Dockerfile_k8s .
    
}

docker pull docker.pkg.github.com/thedemoncat/onec-base/onec_base:latest

env=()
while IFS= read -r line || [[ "$line" ]]; do
  env+=("$line")
done < ONEC_VERSION

for item in ${env[*]}
do
    echo "launching an image build with a platform:: "$item
    buildImages $item
done
