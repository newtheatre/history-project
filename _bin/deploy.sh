#!/usr/bin/env bash
set -euo pipefail

curl -L https://github.com/bep/s3deploy/releases/download/v2.11.0/s3deploy_2.11.0_linux-amd64.tar.gz -o _bin/s3deploy.tar.gz
curl -L https://github.com/bep/s3deploy/releases/download/v2.16.0/s3deploy_2.16.0_linux-amd64.tar.gz -o _bin/s3deploy.tar.gz
mkdir -p _bin/s3deploy
tar -xf _bin/s3deploy.tar.gz -C _bin/s3deploy
rm _bin/s3deploy.tar.gz

# For Cloudflare R2 set AWS_S3_ENDPOINT, e.g. https://<account-id>.r2.cloudflarestorage.com
# R2 ignores region but s3deploy requires one; "auto" is what Cloudflare recommends.
endpoint_args=()
if [[ -n "${AWS_S3_ENDPOINT:-}" ]]; then
  endpoint_args=(-endpoint-url "$AWS_S3_ENDPOINT")
  AWS_REGION="${AWS_REGION:-auto}"
fi

echo "Deploying to ${AWS_S3_ENDPOINT:-S3} using path: $DEPLOY_NAME"

_bin/s3deploy/s3deploy \
  -bucket "$AWS_S3_BUCKET" -key "$AWS_ACCESS_KEY_ID" -secret "$AWS_SECRET_ACCESS_KEY" \
  -region "$AWS_REGION" "${endpoint_args[@]}" -config .s3deploy.yml -source dist -path "v1/$DEPLOY_NAME"
