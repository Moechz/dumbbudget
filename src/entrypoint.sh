#!/bin/sh
# TOS wrapper: DumbBudget writes generated assets into /app/public/assets on
# startup, which is read-only for a non-root user. Copy the application into
# the persistent /data volume once, then run it from there.
set -u
set -e
if [ ! -f /data/app/server.js ]; then
  mkdir -p /data/app
  cp -a /app/. /data/app/
fi
cd /data/app
exec npm start
