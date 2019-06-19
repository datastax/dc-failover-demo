#!/bin/bash

# install packages
sudo apt-get update -y -qq
sudo apt-get install -y openjdk-8-jdk-headless
sudo apt-get install -y cloud-utils
sudo apt-get install -y maven

#TODO: Remove this and /tmp/github_key file provisioner once the is repo is public
mv /tmp/github_key /home/ubuntu/.ssh/github_key
sudo chmod 400 /home/ubuntu/.ssh/github_key

cat > /home/ubuntu/.ssh/config << SSHCONFIG_EOL
Host github.com
     IdentityFile /home/ubuntu/.ssh/github_key
     IdentitiesOnly yes
SSHCONFIG_EOL

# Add github.com to known hosts
ssh-keyscan -H github.com >> /home/ubuntu/.ssh/known_hosts

git clone git@github.com:riptano/dc-failover-demo-provision-deploy.git
cd dc-failover-demo-*/service
mvn clean install