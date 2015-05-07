#!/bin/bash

# enable error reporting to the console
set -e

echo "Bundle path:" $BUNDLE_PATH
echo "Pull Request:" $TRAVIS_PULL_REQUEST

echo $TRAVIS_BUILD_NUMBER > _includes/travis_build_number.txt

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build

