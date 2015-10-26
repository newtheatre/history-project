#!/bin/bash

# Only deploy if not PR
if [[ $TRAVIS_PULL_REQUEST = "false" ]]
  then

  # commit and push generated content to built branch
  # since repository was cloned in write mode with token auth - we can push there
  cd _site

  git config user.email "webmaster@newtheatre.org.uk"
  git config user.name "ntbot"

  git init
  git remote add github https://${GH_TOKEN}@github.com/newtheatre/history-project-gh-pages.git gh-pages

  git add -A .
  git commit -a -m "Travis Build $TRAVIS_BUILD_NUMBER"
  git push -f --quiet github gh-pages > /dev/null 2>&1 # Hiding all the output from git push command, to prevent token leak.

  # Cleanup
  rm -rf .git
fi
