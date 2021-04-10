#! /bin/bash
eval "$(fixuid -q)"
if [ "${DOCKER_USER-}" ] && [ "$DOCKER_USER" != "$USER" ]; then
  echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd >/dev/null
  # Unfortunately we cannot change $HOME as we cannot move any bind mounts
  # nor can we bind mount $HOME into a new home as that requires a privileged container.
  sudo usermod --login "$DOCKER_USER" rstudio
  sudo groupmod -n "$DOCKER_USER" rstudio
  USER="$DOCKER_USER"
  sudo sed -i "/rstudio/d" /etc/sudoers.d/nopasswd
fi

if [ -z "$JUPYTER_TOKEN" ]; then
    JUPYTER_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 48 | head -n 1)
fi

echo "http://localhost:8787/?token=${JUPYTER_TOKEN}"
echo "http://localhost:8787/\?token\=${JUPYTER_TOKEN}"

#rstudio-server start
/usr/lib/rstudio-server/bin/rserver --www-port=8888 --auth-none=1 --server-app-armor-enabled=0
#bash