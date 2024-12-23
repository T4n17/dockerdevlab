#!/bin/bash
set -e

echo "Starting Docker configuration restoration process..."

echo "Removing custom configurations..."

# Remove daemon.json
if [ -f "/etc/docker/daemon.json" ]; then
    echo "Removing daemon.json..."
    sudo rm -f "/etc/docker/daemon.json"
fi

# Remove custom seccomp profile
if [ -f "/etc/docker/seccomp-profile.json" ]; then
    echo "Removing custom seccomp profile..."
    sudo rm -f "/etc/docker/seccomp-profile.json"
fi

# Remove custom audit rules
if [ -f "/etc/audit/rules.d/docker.rules" ]; then
    echo "Removing custom audit rules..."
    sudo rm -f "/etc/audit/rules.d/docker.rules"
fi

# Create default daemon.json with minimal settings
echo "Creating default daemon.json..."
cat > /tmp/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}
EOF
sudo mv /tmp/daemon.json /etc/docker/daemon.json

echo "Restarting Docker daemon..."
sudo systemctl restart docker

echo "Docker has been restored to default configuration."
echo "Backup of previous configuration can be found in: $backup_dir"
echo ""
echo "To verify the restoration:"
echo "1. Check Docker info:"
echo "   docker info"
echo ""
echo "2. Check Docker daemon configuration:"
echo "   cat /etc/docker/daemon.json"
echo ""
echo "3. Verify Docker is running properly:"
echo "   docker run hello-world"
