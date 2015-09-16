#!/bin/bash

# enable error reporting to the console
set -e

echo "Bundle path:" $BUNDLE_PATH
echo "Pull Request:" $TRAVIS_PULL_REQUEST

if [ -n "$TRAVIS_BUILD_NUMBER" ]
then
  echo $TRAVIS_BUILD_NUMBER > _includes/travis_build_number.txt
fi

if [[ $RESET = "true" ]]
then
  rm -rf _site
  rm -rf _asset_bundler_cache/
fi

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build

# generate search index
coffee _coffee/search_index_generator.coffee
