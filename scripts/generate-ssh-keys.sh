#!/bin/bash
set -e

# Create SSH directory if it doesn't exist
mkdir -p ssh

# Generate SSH key pair if it doesn't exist
if [ ! -f ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N ""
    echo "SSH key pair generated."
fi

# Create authorized_keys file from public key
cp ssh/id_rsa.pub ssh/authorized_keys
chmod 600 ssh/authorized_keys

echo "SSH keys have been generated and configured."
echo "The public key has been added to authorized_keys."
echo "Use the private key at ssh/id_rsa to connect to the container, or copy your public key to ssh/authorized_keys."
