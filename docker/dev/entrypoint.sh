#!/bin/bash
set -e

# Copy authorized keys if provided
if [ -f "/run/secrets/authorized_keys" ]; then
    cp /run/secrets/authorized_keys $HOME/.ssh/authorized_keys
    chmod 600 $HOME/.ssh/authorized_keys
fi

# Start SSH service
sudo service ssh start

# Keep container running
exec tail -f /dev/null
