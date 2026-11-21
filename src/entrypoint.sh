#!/bin/sh
# TOS wrapper: the upstream image writes its generated PWA manifest and asset
# manifest into /app/public/assets on every start, which is read-only for the
# non-root user. Copy the application files (not node_modules) into the
# persistent data volume and refresh them on every start, so an application
# update takes effect immediately while transactions in /data/app/data survive.
set -u
set -e

APP_DIR=/data/app
mkdir -p "$APP_DIR"

# Refresh code and static files; $APP_DIR/data is deliberately left untouched.
rm -rf "$APP_DIR/public" "$APP_DIR/scripts" "$APP_DIR/assets"
cp -a /app/public /app/scripts /app/assets /app/server.js /app/package.json "$APP_DIR"/

# Reuse the image's node_modules read-only instead of copying ~200 MB.
ln -sfn /app/node_modules "$APP_DIR/node_modules"

cd "$APP_DIR"
exec node server.js
