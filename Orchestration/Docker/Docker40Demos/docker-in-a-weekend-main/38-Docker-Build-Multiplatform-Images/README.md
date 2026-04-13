---
title: "Create Multi-Platform Docker Images Using BuildKit and Buildx"
description: "Learn how to build and push multi-platform Docker images using Docker BuildKit and Buildx. This guide covers the use of `--load` and `--push` flags with `docker buildx build` command for efficient multi-architecture image creation."
---

# Create Multi-Platform Docker Images Using BuildKit and Buildx

---

## Step-01: Introduction

In this guide, you will learn how to build multi-platform Docker images using **Docker BuildKit** and **Buildx**. You will also learn how to use the `--load` and `--push` flags with the `docker buildx build` command.

---

## Step-02: Review Dockerfile

```dockerfile
# Use nginx as base Docker Image
FROM nginx

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: Create Multi-platform Docker Images using Docker BuildKit and Buildx"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating Multi-platform Docker Images using Docker BuildKit and Buildx"
LABEL org.opencontainers.image.version="1.0"

# Using COPY to copy a local file
COPY index.html /usr/share/nginx/html
```

---

## Step-03: Verify NGINX Base Image for Multi-Platform Support

- Check the [NGINX Docker Official Image](https://hub.docker.com/_/nginx) to verify if it supports multiple platforms.
- In the **Quick reference (cont.)** section, you can find the supported architectures:

```text
Supported architectures:
amd64, arm32v5, arm32v6, arm32v7, arm64v8, i386, mips64le, ppc64le, s390x
```

---

## Step-04: Build and Load Multi-Platform Docker Images Locally

```bash
# List Local builders
docker buildx ls

# Change Directory
cd multiplatform-demo

# Build Multi-platform Docker Images and Load to Docker Desktop (locally)
docker buildx build --platform linux/amd64,linux/arm64 -t demo1-multiplatform-local:v1 --load .
```

- **Note**:
  - When building multi-platform images, it is recommended to use `--push` instead of `--load`.
  - The `--load` flag is useful for local development but only supports one platform at a time in the local Docker daemon.

---

## Step-05: Build and Push Multi-Platform Docker Images to Docker Hub

```bash
# List Local builders
docker buildx ls

# Login with your Docker ID
docker login

# Change Directory
cd multiplatform-demo

# Build Multi-platform Docker Images and Push to Docker Hub
docker buildx build --platform linux/amd64,linux/arm64 -t YOUR_DOCKER_ID/demo2-multiplatform-local:v1 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t stacksimplify/demo2-multiplatform-local:v1 --push .
```

- **Replace** `YOUR_DOCKER_ID` with your actual Docker Hub username.

---

## Step-06: Verify Multi-Platform Docker Image in Docker Hub

1. Go to [Docker Hub](https://hub.docker.com).
2. Navigate to your Docker image: `YOUR_DOCKER_ID/demo2-multiplatform-local`.
3. Click on **Tags**.
4. Verify that there are multiple image digests corresponding to different architectures (e.g., arm64 and amd64).

---

## Step-07: Pull, Run, and Verify the Docker Image

```bash
# Pull the Docker image
docker pull YOUR_DOCKER_ID/demo2-multiplatform-local:v1
docker pull stacksimplify/demo2-multiplatform-local:v1

# Inspect the Docker image
docker image inspect YOUR_DOCKER_ID/demo2-multiplatform-local:v1
docker image inspect stacksimplify/demo2-multiplatform-local:v1

# Observation:
# 1. Verify the "Architecture" field in the output.
# 2. The image pulled corresponds to your local machine's architecture.

# Run the Docker container
docker run --name my-multiplatform-demo -p 8080:80 -d YOUR_DOCKER_ID/demo2-multiplatform-local:v1
docker run --name my-multiplatform-demo -p 8080:80 -d stacksimplify/demo2-multiplatform-local:v1

# List Docker containers
docker ps

# Access the application
# In your browser:
http://localhost:8080

# Or use curl:
curl http://localhost:8080
```

- **Clean Up**:

```bash
# Stop the Docker container
docker stop my-multiplatform-demo

# Remove the Docker container
docker rm my-multiplatform-demo
```

---

## Step-08: Stop and Remove Buildx Builder

```bash
# List Docker Buildx builders
docker buildx ls

# Stop Docker Buildx builder
docker buildx stop mybuilder1

# Remove Docker Buildx builder
docker buildx rm mybuilder1

# Verify the builders
docker buildx ls
```

---

## Step-09: Clean Up

```bash
# Remove all Docker images
docker rmi $(docker images -q)

# List Docker images to confirm
docker images
```

---

## Conclusion

In this tutorial, you learned how to build multi-platform Docker images using Docker BuildKit and Buildx. By leveraging the `docker buildx build` command with `--platform`, `--load`, and `--push` flags, you can create images that support multiple architectures and push them to Docker Hub for broader compatibility.

---

## Additional Notes

- **Multi-Platform Images**:
  - Multi-platform images (also known as multi-arch images) allow you to build images that can run on different CPU architectures, such as `amd64` and `arm64`.
  - This is particularly useful for supporting various devices and environments.

- **Buildx and BuildKit**:
  - **Buildx** is a CLI plugin that extends the `docker build` command with the full support of the features provided by BuildKit builder toolkit.
  - **BuildKit** provides improved performance and new features for Docker image builds.

- **Using `--push` vs. `--load`**:
  - `--push`: Builds the image and pushes it directly to a Docker registry. Recommended for multi-platform images.
  - `--load`: Loads the image into the local Docker image store. Only supports the current platform.

---

## Additional Resources

- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
- [Docker BuildKit Documentation](https://docs.docker.com/build/buildkit/)
- [Multi-Platform Docker Builds](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/)
- [NGINX Docker Official Image](https://hub.docker.com/_/nginx)
- [Docker Buildx Build Command Reference](https://docs.docker.com/engine/reference/commandline/buildx_build/)

---

**Happy Dockerizing!**
