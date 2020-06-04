main() {
  arch=$(uname -m)
  march=$(echo $arch | sed s/armv7l/armhf/ | sed s/x86_64/amd64/)
  if [ "$arch" != x86_64 ] && [ "$arch" != armv7l ]; then
   echo "syncthing: architecture not supported" >&2
   return
  fi
  sunzi.mute apt-get remove --yes --purge docker docker-engine docker.io containerd runc
  sunzi.install apt-transport-https \
                ca-certificates \
                curl \
                gnupg-agent \
                software-properties-common

  curl -sSL https://get.docker.com | sh

  sunzi.mute curl -s -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sunzi.mute chmod +x /usr/local/bin/docker-compose
  if [ -n "$SUDO_USER" ]; then
    sunzi.mute gpasswd -a $SUDO_USER docker
  fi
}

main
