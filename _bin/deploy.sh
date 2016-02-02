#!/bin/bash

# Only deploy if not PR
if [[ $TRAVIS_PULL_REQUEST = "false" && $TRAVIS_BRANCH = "master" ]]
  then
  cd _site

  git init
  git checkout -b gh-pages
  git remote add origin https://${GH_TOKEN}@github.com/newtheatre/history-project-gh-pages.git

  # commit and push generated content to built branch
  # since remote was added with token auth - we can push there
  git config user.email "webmaster@newtheatre.org.uk"
  git config user.name "ntbot"
  git add -A .
  git commit -a -m "Travis Build $TRAVIS_BUILD_NUMBER for $TRAVIS_COMMIT"
  git push --quiet -f origin gh-pages > /dev/null 2>&1 # Hiding all the output from git push command, to prevent token leak.
fi
