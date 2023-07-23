#!/usr/bin/env bash
set -euo pipefail

# $REF_NAME will either be a branch name or a PR number with a suffix. This script returns the branch name or the PR number without the suffix.

# e.g. master -> master
# e.g. 1234/merge -> 1234

if [[ $REF_NAME =~ ^[0-9]+/merge$ ]]; then
  # It's a PR deploy
  PR_NUM=${REF_NAME%/*}
  echo "DEPLOY_NAME=${PR_NUM}" >> $GITHUB_OUTPUT
else
  echo "DEPLOY_NAME=${REF_NAME}" >> $GITHUB_OUTPUT
fi

# If $REF_NAME is master then set $ENVIRONMENT to "production" otherwise set it to PR number

if [[ $REF_NAME == "master" ]]; then
  # It's a production deploy
  echo "ENVIRONMENT=production" >> $GITHUB_OUTPUT
else
  # It's a PR deploy
  echo "ENVIRONMENT=${PR_NUM}" >> $GITHUB_OUTPUT
fi
