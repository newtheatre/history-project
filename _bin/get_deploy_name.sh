#!/usr/bin/env bash
set -euo pipefail

# $REF_NAME will either be a branch name or a PR number with a suffix. This script returns the branch name or the PR number without the suffix.

# e.g. master -> master
# e.g. 1234/merge -> 1234

if [[ $REF_NAME =~ ^[0-9]+/merge$ ]]; then
  echo ${REF_NAME%/*}
else
  echo $REF_NAME
fi
