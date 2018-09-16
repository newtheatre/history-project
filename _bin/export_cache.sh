#!/bin/bash

if [[ $TRAVIS_PULL_REQUEST = "false" && $TRAVIS_BRANCH = "master" ]]
then
    mkdir -p tmp/export
    tar cfJ tmp/export/sm-cache.tar.xz tmp/smugmug
fi
