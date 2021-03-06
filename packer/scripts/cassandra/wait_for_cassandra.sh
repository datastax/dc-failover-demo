#!/bin/bash

export PRIVATE_IP=$(ec2metadata --local-ipv4)

if timeout 240 bash -c 'until (echo > /dev/tcp/$PRIVATE_IP/9042) 2> /dev/null; do echo "Waiting for port 9042..."; sleep 2; done'; then
    echo "Cassandra node bootstrapped at $PRIVATE_IP"
else
    echo "Failed to start cassandra at $PRIVATE_IP"
    exit 1
fi
