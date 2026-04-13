---
title: "Learn About Docker BuildKit (Builder) and Buildx (Client-side CLI)"
description: "Master Docker BuildKit and Buildx to enhance your Docker build processes with improved performance and new functionalities."
---

# Learn About Docker BuildKit (Builder) and Buildx (Client-side CLI)

---

## Step-01: Introduction

Docker Build implements a client-server architecture, where:

- **Client:** Buildx is the client and the user interface for running and managing builds.
- **Server:** BuildKit is the server, or builder, that handles the build execution.

### BuildKit - In Detail

1. **BuildKit** is an improved backend that replaces the legacy builder.
2. **BuildKit** is the default builder for users on Docker Desktop and Docker Engine as of version 23.0.
3. **BuildKit** provides new functionality and improves your builds' performance.
4. For a complete understanding, refer to the [BuildKit Documentation](https://docs.docker.com/build/buildkit/).

---

## Step-02: Docker Buildx Commands - Version and List

```bash
# Show buildx version information
docker buildx version

# List builder instances
docker buildx ls

# Observation:
# 1. Lists the builders pre-configured as part of Docker Desktop installation.
```

---

## Step-03: Verify Builder Instances Using Docker Desktop

1. Open **Docker Desktop**.
2. Navigate to **Settings** > **Builders**.
3. Review the default builder instances that have been created.

---

## Step-04: Docker Buildx Commands - `du` and `prune`

```bash
# Check disk usage
docker buildx du

# Remove build cache
docker buildx prune

# Check disk usage again
docker buildx du
```

---

## Step-05: Docker Buildx Commands - Inspect

```bash
# Inspect the current builder instance
docker buildx inspect

# Inspect a specific builder instance
docker buildx inspect --builder desktop-linux
docker buildx inspect --builder default
```

---

## Step-06: Docker Buildx - Switch Builders

```bash
# List builder instances
docker buildx ls

# Observation:
# 1. Observe the star (*) next to the builder name indicating the currently configured builder.

# Switch to the default builder and verify
docker context use default
docker buildx ls

# Observation:
# 1. Go to Docker Desktop > Settings > Builders to verify the active builder.

# Switch back to the desktop-linux builder
docker context use desktop-linux
docker buildx ls

# Observation:
# 1. Go to Docker Desktop > Settings > Builders to verify the active builder.
```

---

## Step-07: Create and Initialize a New Builder

```bash
# Create a new Buildx builder
docker buildx create --name mybuilder1 --use 
[or]
docker buildx create --name mybuilder1 --use --bootstrap

# Explanation:
# - `create`: Create a new builder instance.
# - `--name mybuilder1`: Name of the new builder.
# - `--use`: Automatically switch to the newly created builder.
# - `--bootstrap`: Boot builder after creation

# Inspect and Initialize the Buildx builder
docker buildx inspect --bootstrap

# Explanation:
# - `inspect`: Inspect the current builder instance.
# - `--bootstrap`: Ensure the builder has booted before inspecting.

# List builder instances
docker buildx ls

# List Docker containers
docker ps

# Observation:
# Verify if the Buildx container is running.

# Verify the builder using Docker Desktop:
# 1. Open Docker Desktop.
# 2. Navigate to Settings > Builders.
# 3. Confirm that 'mybuilder1' is listed and active.
```

---

## Additional References

- [Docker Buildx Create Command Reference](https://docs.docker.com/engine/reference/commandline/buildx_create/)
- [BuildKit Documentation](https://docs.docker.com/build/buildkit/)
- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)

---
