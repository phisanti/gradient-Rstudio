#!/bin/bash

# Source: https://gist.github.com/earthgecko/3089509
# Generates a random alphanumeric string of length 48 (like a jupyter notebook token i.e. c8de56fa4deed24899803e93c227592aef6538f93025fe01)
if [ -z "$JUPYTER_TOKEN" ]; then
    JUPYTER_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 48 | head -n 1)
fi

# Note: print mocked jupyter token so that we can run this container as if it is a notebook within Gradient V1
echo "http://localhost:8888/?token=${JUPYTER_TOKEN}"
echo "http://localhost:8888/\?token\=${JUPYTER_TOKEN}"
#--www-port=8888 --auth-none=1 --server-daemonize=0 --server-data-dir="$RSTUDIO_SERVER_DATA_DIR" --server-pid-file="$RSTUDIO_SERVER_DATA_DIR/rstudio-server.pid"
# jupyter lab --ip=0.0.0.0 --NotebookApp.token='local-development' --allow-root --no-browser &> /dev/null &
PASSWORD=${JUPYTER_TOKEN} /usr/lib/rstudio-server/bin/rserver --www-port=8888 --auth-none=1 --server-daemonize=0 www-address=0.0.0.0
