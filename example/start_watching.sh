#!/bin/sh
cd $(dirname $(dirname $0))
bundle exec exe/consul_event_handler watch --config=example/config.yml
