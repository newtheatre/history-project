#!/bin/bash

# Only deploy if not PR
if [[ $TRAVIS_PULL_REQUEST = "false" && $TRAVIS_BRANCH = "master" ]]
  then

  zip -r deploy.zip _site

  curl -H "Content-Type: application/zip" \
    -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" \
    --data-binary "@deploy.zip" \
    "https://api.netlify.com/api/v1/sites/$NETLIFY_SITE_ID/deploys"

fi
