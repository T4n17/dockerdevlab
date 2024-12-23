# Docker Development Lab

A secure containerized development environment with SSH access and security hardening features.

## Features

- Secure development container with SSH access
- Automatic security hardening with backup functionality
- Docker Compose orchestration
- Environment variable management
- Volume mounting for persistent development
- Customizable development tools
- Restricted system capabilities
- Comprehensive security configurations

## Prerequisites

- Docker
- Docker Compose
- OpenSSH client
- Sudo privileges (for security configurations)

## Quick Start

1. Clone this repository

2. Copy `.env.example` to `.env` and configure your settings
```bash
cp .env.example .env
```

3. Generate SSH keys and configure access
```bash
./scripts/generate-ssh-keys.sh
```
You can either use the generated SSH key or copy your own public key to `ssh/authorized_keys`.

4. Apply security hardening (optional)
```bash
sudo ./scripts/security-hardening.sh
```

5. Start the development environment
```bash
docker-compose up -d
```

6. Connect to the container
```bash
ssh -p 2222 devuser@localhost
```
Or use the generated private SSH key
```bash
ssh -i ssh/id_rsa -p 2222 devuser@localhost
```

## Security Features

- SSH key-based authentication
- Container security:
  - Specific capability controls (no privileged mode)
  - Limited sudo access (only for SSH service)
- Optional security hardening:
  - Docker daemon configuration
  - Audit logging
  - Inter-container communication control

## Security Hardening

The project includes optional security configurations that can be applied to the host system:

1. Apply security hardening (requires sudo privileges):
```bash
sudo ./scripts/security-hardening.sh
```
2. The script will:
   - Back up existing Docker configurations
   - Configure Docker daemon settings:
     - Disable inter-container communication
     - Restart the Docker daemon
   - Set up audit rules
   - Restart the Docker daemon

3. Verify the configurations:
```bash
docker info | grep -i seccomp
docker info | grep -i cgroup
```

To restore Docker to default configuration:
```bash
sudo ./scripts/restore-docker-defaults.sh
```

The restoration script will:
- Remove custom security settings
- Create minimal default configuration
- Restart the Docker daemon

Note: The security hardening is optional and affects the host system's Docker configuration. The development container will work with or without these additional security measures.

## Configuration

### Environment Variables

Configure the development environment by editing the `.env` file:

- `DEV_USER`: Development user inside the container
- `SSH_PORT`: External SSH port mapping (default: 2222)
- `WORKSPACE_PATH`: Path to mount your workspace
- `TZ`: Container timezone

## Directory Structure

```
.
├── docker/
│   ├── config/
│   │   ├── daemon.json
│   │   ├── seccomp-profile.json
│   │   └── audit.rules
│   └── dev/
│       ├── Dockerfile
│       └── entrypoint.sh
├── scripts/
│   ├── generate-ssh-keys.sh
│   ├── security-hardening.sh
│   └── restore-docker-defaults.sh
├── ssh/
│   ├── id_rsa
│   ├── id_rsa.pub
│   └── authorized_keys
├── workspace/
├── .env.example
├── docker-compose.yml
└── README.md
```

### Directory Explanations

#### `/docker`
- **`/config`**: Contains Docker security configurations
  - `daemon.json`: Docker daemon security settings
  - `seccomp-profile.json`: System call filtering rules
  - `audit.rules`: Docker operation audit rules
- **`/dev`**: Development container configuration
  - `Dockerfile`: Container image definition
  - `entrypoint.sh`: Container startup script

#### `/scripts`
- `generate-ssh-keys.sh`: Generates SSH keys for secure access
- `security-hardening.sh`: Applies security configurations and creates backups
- `restore-docker-defaults.sh`: Restores Docker to default configuration

#### `/ssh`
- `id_rsa`: Private SSH key (generated)
- `id_rsa.pub`: Public SSH key (generated)
- `authorized_keys`: Authorized public keys for SSH access

#### `/workspace`
Mount point for your development files, persisted across container restarts

#### Root Directory Files
- `.env.example`: Template for environment variables
- `docker-compose.yml`: Container orchestration configuration
- `README.md`: Project documentation

## Maintenance

- Update the container: `docker-compose build --no-cache`
- View logs: `docker-compose logs`
- Stop environment: `docker-compose down`

## Security Best Practices

1. Regularly update the base image and packages
2. Keep SSH keys secure and private
3. Use strong passwords for any additional services
4. Monitor container logs for suspicious activity
5. Regularly audit container security with tools like Docker Bench Security
