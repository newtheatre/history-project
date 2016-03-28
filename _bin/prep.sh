#!/bin/bash

# enable error reporting to the console
set -e

echo "Bundle path: $BUNDLE_PATH"
echo "Pull Request: $TRAVIS_PULL_REQUEST"

if [[ "$TRAVIS_BUILD_NUMBER" ]]
then
  echo "$TRAVIS_BUILD_NUMBER" > _includes/travis_build_number.txt
fi

if [[ $RESET = "true" ]]
then
  rm -rf _site
  rm -rf _asset_bundler_cache
  rm -rf _smugmug_cache
fi
