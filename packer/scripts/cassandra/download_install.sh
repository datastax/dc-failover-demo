#!/bin/bash

apt-get install -y openjdk-8-jdk-headless
apt-get install -y cloud-utils
wget -c https://downloads.datastax.com/ddac/ddac-bin.tar.gz -O - | tar -xz