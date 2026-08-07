#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${APP_PATH:-app}"

if [ -d "$APP_PATH" ]; then
  if [ -f "$APP_PATH/composer.json" ]; then
    composer install --no-interaction --prefer-dist --working-dir="$APP_PATH"
    composer test
    exit 0
  fi

  if [ -f "$APP_PATH/package.json" ]; then
    npm ci --prefix "$APP_PATH"
    npm test --prefix "$APP_PATH" -- --runInBand
    exit 0
  fi

  if compgen -G "$APP_PATH/*.csproj" > /dev/null; then
    dotnet test "$APP_PATH" --configuration Release --no-restore
    exit 0
  fi
fi

if command -v terraform >/dev/null 2>&1; then
  find layers -mindepth 2 -maxdepth 2 -type f -name '*.tf' -print0 | xargs -0 -r -n1 dirname | sort -u | while read -r dir; do
    terraform -chdir="$dir" fmt -check -recursive
  done
  exit 0
fi

echo "No application test project was found. Set APP_PATH to the application source directory."
exit 1
