set -e

main() {
  arch=$(uname -m)
  march=$(echo $arch | sed s/armv7l/arm/ | sed s/x86_64/amd64/)
  if [ "$arch" != x86_64 ] && [ "$arch" != armv7l ]; then
    echo "syncthing: architecture not supported" >&2
    return
  fi
  if systemctl --user is-active --quiet syncthing; then
    return
  fi
  stversion=1.6.1
  sturl="https://github.com/syncthing/syncthing/releases/download/v$stversion/syncthing-linux-$march-v$stversion.tar.gz"
  tdir=$(mktemp -d /tmp/syncthingXXXXXX)
  
  curl -sL $sturl > $tdir/syncthing.tgz
  tar --strip-components=1 -C $tdir -xzf $tdir/syncthing.tgz
  mkdir -p ~/bin
  mv $tdir/syncthing ~/bin
  sed -i "s/\/usr\/bin/\/home\/$USER\/bin/" $tdir/etc/linux-systemd/user/syncthing.service
  sed -i 's/^User=.*$//' $tdir/etc/linux-systemd/user/syncthing.service
  mkdir -p ~/.config/systemd/user/
  mv $tdir/etc/linux-systemd/user/syncthing.service ~/.config/systemd/user/syncthing.service
  systemctl --user daemon-reload
  systemctl --user enable syncthing
  systemctl --user start syncthing
}

sudo -u $SUDO_USER bash -c "$(declare -f main); main"
