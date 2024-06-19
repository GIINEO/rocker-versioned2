#!/bin/bash

set -e

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
    curl \
    vim

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -r ./aws

wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.deb
apt_install ./mount-s3.deb
rm ./mount-s3.deb
