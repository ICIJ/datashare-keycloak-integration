#!/bin/sh

set -e

cmd="$@"

until echo GET / | nc -w 1 elasticsearch 9200 ; do
  >&2 echo "ElasticSearch is not ready - sleeping"
  sleep 2
done
  
>&2 echo "ElasticSearch is up - executing command"
exec $cmd
