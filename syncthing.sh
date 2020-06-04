main() {
  if systemctl --user is-active --quiet syncthing; then
    return
  fi
  stversion=1.5.0
  sturl="https://github.com/syncthing/syncthing/releases/download/v$stversion/syncthing-linux-amd64-v$stversion.tar.gz"
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
