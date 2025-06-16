# Docker Container with Claude Code and .NET SDK

This Docker setup creates a lightweight Debian-based container with Node.js, npm, .NET SDK, and Claude Code installed. It mounts your local Windows source directory for easy access.

## Mounted Directory

The container mounts your local Windows directory:
- Windows path: `%USERPROFILE%\source` (your user's source directory)
- Container path: `/workspace/source`

You have full read/write access to this directory from within the container.

## Prerequisites

- Docker Desktop installed on your Windows machine
- Docker Compose installed (comes with Docker Desktop)

## Getting Started

### Building the Container

```powershell
# Navigate to the directory containing the Dockerfile and docker-compose.yml
cd %USERPROFILE%\source\repos\DockerLinuxWithMountedFolder

# Build and start the container
docker-compose build
docker-compose up -d
```

### Connecting to the Container

```powershell
# Connect to bash in the running container
docker exec -it claude-code-container bash
```

### Using Claude Code

Claude Code is pre-installed in the container. You can run it with:

```bash
# Get help and available commands
claude --help

# Start an interactive session
claude

# Run with specific options
claude [options] [command] [prompt]
```

### Working with Files in the Mounted Directory

Once connected to the container, you can access your Windows source directory at `/workspace/source`. Any changes made to files within this directory from the container will be reflected in your Windows file system.

```bash
# Navigate to the mounted directory
cd /workspace/source

# List contents
ls -la

# Create, edit, or delete files as needed
```

### Stopping the Container

```powershell
# Stop the container when you're done
docker-compose down
```

## Included Tools and SDKs

The container comes pre-installed with:

1. **Node.js and npm**
   - Latest version of Node.js
   - npm package manager

2. **.NET SDK 9.0**
   - Full .NET SDK for building and running .NET applications
   - `dotnet` command-line interface

3. **Claude Code**
   - AI-powered coding assistant
   - Accessible via the `claude` command

4. **Other Development Tools**
   - git
   - Python 3
   - Basic build tools

## Persistence

This Docker setup has two aspects of persistence:

1. **Persistent by default:**
   - The mounted directory (`%USERPROFILE%\source` mapped to `/workspace/source`) is always persistent
   - Any files you create, modify, or delete in `/workspace/source` inside the container will persist on your host machine
   - **Claude Code API Key and configuration** are stored in a named volume and persist between container restarts
   - This is the main way you'll work with your code and files

2. **Not persistent by default:**
   - Changes made elsewhere in the container's filesystem (outside of `/workspace/source`) will be lost when you run `docker-compose down`
   - If you install additional packages or create files elsewhere in the container, these changes will be erased when the container is removed

If you need to persist other data, you have a few options:

### Option 1: Avoid removing the container
Instead of using `docker-compose down`, you can stop the container with:
```powershell
docker-compose stop
```
And restart it later with:
```powershell
docker-compose start
```
This keeps the container intact between restarts.

### Option 2: Add additional volume mounts
You can modify the `docker-compose.yml` file to add more persistent volumes:
```yaml
volumes:
  - ${USERPROFILE}/source:/workspace/source
  - ${USERPROFILE}/other-dir:/path/in/container
  - my_named_volume:/another/path/in/container

volumes:
  my_named_volume:
```

### Option 3: Create a custom image
If you find yourself repeatedly installing the same tools, you can:
1. Make your changes to the container
2. Create a new image: `docker commit claude-code-container my-custom-image:latest`
3. Update the docker-compose.yml to use your custom image

## Quick Connect Script

You can use the included PowerShell script to quickly connect to the container:

```powershell
# Run the connect script from the project directory
.\connect.ps1
```

## Customization

- Edit the `Dockerfile` to add additional dependencies if needed
- Edit the `docker-compose.yml` file to change mount points or container configuration
