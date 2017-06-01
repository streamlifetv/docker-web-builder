#!/bin/bash

# remove old containers
docker rm -f $(docker ps -aq)

# remove old image
# docker rmi -f bitmovin/web-builder:dev

# build new local web-builder image
docker build -t bitmovin/web-builder:dev .