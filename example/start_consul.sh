#!/bin/sh
if ps axu | grep '[c]onsul agent'; then
  echo "Already running"
  exit
fi

consul agent -server -data-dir=/tmp/consul -bootstrap
