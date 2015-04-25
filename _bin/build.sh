#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build

# cleanup
rm -rf gh-pages

git clone -b gh-pages https://${GH_TOKEN}@github.com/newtheatre/history-project.git gh-pages

# copy generated HTML site to built branch
cp -R _site/* gh-pages

# commit and push generated content to built branch
# since repository was cloned in write mode with token auth - we can push there
cd gh-pages
git config user.email "webmaster@newtheatre.org.uk"
git config user.name "NTHP Build Bot"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin travis-build-test > /dev/null 2>&1 # Hiding all the output from git push command, to prevent token leak.
