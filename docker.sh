main() {
  # abort if docker already installed
  which docker 2>/dev/null && return

  sunzi.mute apt-get remove --yes --purge docker docker-engine docker.io containerd runc

  curl -sSL https://get.docker.com | sh

  if [ -n "$SUDO_USER" ]; then
    sunzi.mute gpasswd -a $SUDO_USER docker
  fi

  if [ "$arch" = "x86_64" ]; then
    sunzi.mute curl -s -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sunzi.mute chmod +x /usr/local/bin/docker-compose
  else
    echo "docker-compose install not supported in non x86_64 architectures" >&2
  fi
}

main
