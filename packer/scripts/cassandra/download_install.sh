#!/bin/bash

# install packages
sudo apt-get update -y -qq
sudo apt-get install -y openjdk-8-jdk-headless
sudo apt-get install -y cloud-utils
sudo apt-get install -y python-dev python-setuptools python-yaml

# download and uncompress Cassandra
wget -c https://downloads.datastax.com/ddac/ddac-bin.tar.gz -O - | tar -xz

