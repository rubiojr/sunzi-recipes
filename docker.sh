sunzi.mute apt-get remove --yes --purge docker docker-engine docker.io containerd runc
sunzi.install apt-transport-https \
              ca-certificates \
              curl \
              gnupg-agent \
              software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sunzi.mute add-apt-repository --yes \
           "deb [arch=amd64] https://download.docker.com/linux/debian \
           $(lsb_release -cs) \
           stable"

sunzi.mute apt-get update

sunzi.install docker-ce docker-ce-cli containerd.io docker-compose

curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
