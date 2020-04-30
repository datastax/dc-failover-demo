#!/bin/bash

# install packages
sudo apt-get update -y -qq
sudo apt-get install -y openjdk-8-jdk-headless
sudo apt-get install -y cloud-utils
sudo apt-get install -y python-dev python-setuptools python-yaml python-pip

# install locust
sudo pip install 'locustio==0.13.5'
