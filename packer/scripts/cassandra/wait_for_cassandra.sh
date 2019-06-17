#!/bin/bash

echo "Waiting for port 9042..."

export PRIVATE_IP=$(ec2metadata --local-ipv4)

timeout 180 bash -c 'until echo > /dev/tcp/$PRIVATE_IP/9042; do sleep 2; done'

echo "Cassandra node bootstrapped at $PRIVATE_IP"