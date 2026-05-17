#!/bin/bash
set -e

echo "=== Starting build process ==="
echo "Current directory: $(pwd)"
echo "Environment: CF_PAGES_URL=$CF_PAGES_URL"

echo "Ignoring submodule checks (this project includes theme inline)..."
git config --global advice.submoduleFetch false 2>/dev/null || true
git submodule deinit --all 2>/dev/null || true
rm -rf .git/modules 2>/dev/null || true

echo "Cleaning previous build artifacts..."
rm -rf public resources .hugo_build.lock

echo "Building Hugo site..."
if [ -z "$CF_PAGES_URL" ]; then
  hugo --minify
else
  hugo --minify --baseURL "$CF_PAGES_URL/"
fi

BUILD_STATUS=$?
echo "Hugo build exit code: $BUILD_STATUS"

if [ $BUILD_STATUS -ne 0 ]; then
  echo "=== Build failed ==="
  exit $BUILD_STATUS
fi

echo "=== Build completed successfully ==="
ls -la public/
