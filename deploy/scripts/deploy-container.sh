#!/bin/bash
set -euo pipefail

source /opt/retailedge/config.env

aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
docker pull "$IMAGE_URI"

docker stop retailedge-app 2>/dev/null || true
docker rm retailedge-app 2>/dev/null || true

docker run -d \
  --name retailedge-app \
  --restart unless-stopped \
  -p 8080:8080 \
  "$IMAGE_URI"

for attempt in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:8080/ >/dev/null; then
    exit 0
  fi
  sleep 2
done

exit 1
