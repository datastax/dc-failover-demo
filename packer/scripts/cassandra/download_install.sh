#!/bin/bash

# install packages
sudo apt-get update -y -qq
sudo apt-get install -y openjdk-8-jdk-headless
sudo apt-get install -y cloud-utils
sudo apt-get install -y python-dev python-setuptools python-yaml

# download and uncompress Cassandra
mkdir cassandra; wget -c http://archive.apache.org/dist/cassandra/4.0-alpha4/apache-cassandra-4.0-alpha4-bin.tar.gz -O - | tar -xz -C cassandra --strip-components=1

