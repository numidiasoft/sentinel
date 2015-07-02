#!/bin/bash

cd /app/ && bundle install --path=/.bundle
cd /app/ && bundle exec shotgun config.ru --port=9292 -o 0.0.0.0
