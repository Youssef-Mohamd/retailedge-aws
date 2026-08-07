#!/bin/bash
set -euo pipefail

docker stop retailedge-app 2>/dev/null || true
docker rm retailedge-app 2>/dev/null || true
