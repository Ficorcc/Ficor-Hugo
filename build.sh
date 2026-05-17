#!/bin/bash
set -e

echo "=== Starting build process ==="
echo "Current directory: $(pwd)"
echo "Environment: CF_PAGES_URL=$CF_PAGES_URL"

echo "Ignoring submodule checks (theme files are in themes/vortisil)..."

echo "Checking theme directory..."
ls -la themes/vortisil/

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
