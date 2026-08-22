#!/usr/bin/env bash
set -euo pipefail

# Seeds a new deployment path with a server-side copy of master so the
# subsequent s3deploy only uploads the delta. No-op if the path already exists
# or if this is the master deploy itself.

[[ "$DEPLOY_NAME" == "master" ]] && exit 0

export RCLONE_CONFIG_R2_TYPE=s3
export RCLONE_CONFIG_R2_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true
if [[ -n "${AWS_S3_ENDPOINT:-}" ]]; then
  export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
  export RCLONE_CONFIG_R2_ENDPOINT="$AWS_S3_ENDPOINT"
else
  export RCLONE_CONFIG_R2_PROVIDER=AWS
  export RCLONE_CONFIG_R2_REGION="$AWS_REGION"
fi

target="r2:$AWS_S3_BUCKET/v1/$DEPLOY_NAME"

if [[ -n "$(rclone lsf --max-depth 1 "$target" | head -n 1)" ]]; then
  echo "Deployment $DEPLOY_NAME already exists, skipping seed"
  exit 0
fi

echo "Seeding $DEPLOY_NAME from master via server-side copy"
rclone copy --transfers 64 --checkers 64 --stats-one-line -P \
  "r2:$AWS_S3_BUCKET/v1/master" "$target"
