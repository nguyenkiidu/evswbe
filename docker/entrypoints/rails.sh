#!/bin/sh 

set -x

rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

bundle install

BUNDLE="bundle check"

until $BUNDLE
do
  sleep 2;
done

exec "$@"
