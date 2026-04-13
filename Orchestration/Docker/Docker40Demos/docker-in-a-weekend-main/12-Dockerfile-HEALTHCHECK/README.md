---
title: "Learn Dockerfile HEALTHCHECK Instruction Practically"
description: "Create a Dockerfile with the HEALTHCHECK instruction to monitor container health."
---

# Learn Dockerfile HEALTHCHECK Instruction Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile using `nginx:alpine-slim` as the base image.
- Implement a health check using the `HEALTHCHECK` instruction.
- Build the Docker image and verify its functionality.

---

## Step 1: Create Dockerfile and Custom `index.html`

- **Dockerfile HEALTHCHECK Instruction Reference:** [Dockerfile HEALTHCHECK Instruction](https://docs.docker.com/engine/reference/builder/#healthcheck)

- **Directory:** `DockerFiles`

**Create a `Dockerfile` with the following content:**

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: HEALTHCHECK Instruction in Docker"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the use of the HEALTHCHECK instruction"
LABEL org.opencontainers.image.version="1.0"

# Install curl (needed for our Healthcheck command)
RUN apk --no-cache add curl

# Using COPY to copy a local file
COPY index.html /usr/share/nginx/html

# The HEALTHCHECK instruction tells Docker how to test a container to check that it's still working
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --start-interval=5s --retries=3 CMD curl -f http://localhost/ || exit 1
```

**Create a custom `index.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(227, 213, 180);'> 
    <h1>Welcome to StackSimplify - Dockerfile HEALTHCHECK Instruction</h1> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>     
  </body>
</html>
```

---

## Step 2: Build Docker Image and Run It

```bash
# Change to the directory containing your Dockerfile
cd DockerFiles

# Build the Docker Image
docker build -t demo12-dockerfile-healthcheck:v1 .

# Inspect the Docker Image
docker image inspect demo12-dockerfile-healthcheck:v1

# Inspect the Healthcheck settings of the Docker Image
docker image inspect --format='{{json .Config.Healthcheck}}' demo12-dockerfile-healthcheck:v1

# Run the Docker Container
docker run --name my-healthcheck-demo -p 8080:80 -d demo12-dockerfile-healthcheck:v1

# List Docker Containers
docker ps

# Expected Output:
# CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                    PORTS                  NAMES
# e63e7fe79986   demo12-dockerfile-healthcheck:v1  "/docker-entrypoint.…"   17 seconds ago   Up 15 seconds (healthy)   0.0.0.0:8080->80/tcp   my-healthcheck-demo

# Inspect the health status of the container
docker inspect --format='{{json .State.Health}}' my-healthcheck-demo

# Access the application in your browser
http://localhost:8080
```

**Observations:**

1. The container should be in a **healthy** state as indicated by the `STATUS` column in `docker ps`.
2. The `HEALTHCHECK` instruction periodically checks the health of the application inside the container.

---

## Step 3: Stop and Remove Container and Images

```bash
# Stop and remove the container
docker rm -f my-healthcheck-demo

# Remove the Docker images from local machine
docker rmi stacksimplify/demo12-dockerfile-healthcheck:v1
docker rmi demo12-dockerfile-healthcheck:v1

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created an Nginx Dockerfile using the `HEALTHCHECK` instruction.
- Built the Docker image and ran it, observing the health status.
- Verified the health check functionality of the container.
- Tagged and pushed the Docker image to Docker Hub.

---

## Additional Notes

- **HEALTHCHECK Instruction:**

  - The `HEALTHCHECK` instruction tells Docker how to test a container to check that it's still working.
  - It is useful for monitoring the health of the application running inside the container.
  - **Syntax:**

    ```dockerfile
    HEALTHCHECK [OPTIONS] CMD command
    ```

  - **Options:**
    - `--interval=` (default: `30s`): Time between running the check.
    - `--timeout=` (default: `30s`): Time the check is allowed to run before it is considered to have failed.
    - `--start-period=` (default: `0s`): Initialization time before starting health checks.
    - `--retries=` (default: `3`): Number of consecutive failures needed to consider the container unhealthy.

- **Observations:**

  - The health status can be `starting`, `healthy`, or `unhealthy`.
  - Use `docker inspect` to get detailed health status information.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - HEALTHCHECK Instruction](https://docs.docker.com/engine/reference/builder/#healthcheck)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Monitoring Container Health](https://docs.docker.com/config/containers/healthcheck/)

---

**Happy Dockerizing!**
