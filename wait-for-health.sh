#!/usr/bin/env bash

set -e

url="$1"
shift
cmd="$@"

until curl -s "$url" | grep "UP" > /dev/null; do
  echo "Waiting for $url to be UP..."
  sleep 2
done

exec $cmd