#!/bin/bash

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export unset LC_ALL 

npm install 
bower install --allow-root --config.interactive=false
gulp serve
