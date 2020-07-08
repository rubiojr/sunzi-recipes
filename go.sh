#!/bin/bash
set -e

GO_VERSION=1.14.4

arch=$(uname -m)
march=$(echo $arch | sed s/armv7l/arm/ | sed s/x86_64/amd64/)
if [ "$arch" = armv7l ]; then
  march=armv6l
fi
tdir=$(mktemp -d /tmp/goXXXXXX)

curl -sL https://golang.org/dl/go$GO_VERSION.linux-$march.tar.gz -o $tdir/go.tgz
rm -rf /usr/local/go
tar -C /usr/local -xzf $tdir/go.tgz
rm -rf $tdir
