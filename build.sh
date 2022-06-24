#!/bin/bash

docker build --rm \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    -t ubuntu18-env:latest \
    .