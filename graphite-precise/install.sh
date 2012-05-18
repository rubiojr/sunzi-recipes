#!/bin/bash

# Graphite install instrucctions
# https://gist.github.com/1191574

# Load base utility functions like sunzi::silencer()
source recipes/sunzi.sh

# This line is necessary for automated provisioning for Debian/Ubuntu.
# Remove if you're not on Debian/Ubuntu.
export DEBIAN_FRONTEND=noninteractive

# Add Dotdeb repository. Recommended if you're using Debian. See http://www.dotdeb.org/about/
# source recipes/dotdeb.sh

# SSH key
source recipes/ssh_key.sh $(cat attributes/ssh_key)

# Update apt catalog. If you prefer less verbosity, use the sunzi::silencer version instead
apt-get update

# Install packages. If you prefer less verbosity, use the sunzi::silencer version instead
apt-get -y install git-core ntp python-pip python-cairo gcc make build-essential python-memcache python-ldap python-sqlite python-dev libapache2-mod-wsgi python-django python-django-tagging memcached

a2dissite default

cp files/ports.conf /etc/apache2/

pip install whisper carbon graphite-web

mkdir /var/run/wsgi
chown www-data /var/run/wsgi
cp files/carbon.conf /opt/graphite/conf/carbon.conf

pushd /opt/graphite/conf
cp storage-schemas.conf.example storage-schemas.conf
cp graphite.wsgi.example graphite.wsgi

cat > storage-schemas.conf <<EOF
[everything_1min_13months]
priority = 100
pattern = .*
retentions = 60:565920
EOF
popd

cp files/carbon.upstart /etc/init/carbon.conf
cp files/set_admin_passwd.py  /opt/graphite/webapp/graphite/
cp files/local_settings.py /opt/graphite/webapp/graphite/

pushd /opt/graphite/webapp/graphite
python manage.py syncdb --noinput
python set_admin_passwd.py admin admin
chown www-data /opt/graphite/storage -R
popd

cp files/apache.conf /etc/apache2/sites-enabled/graphite.conf

pushd /opt/graphite
./bin/carbon-cache.py start
popd
service apache2 restart
service carbon restart
