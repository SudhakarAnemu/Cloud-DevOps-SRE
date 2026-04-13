---
title: "Create Docker Image with Labels and Push to Docker Hub"
description: "Learn how to create a Docker image with labels, build it, inspect it, and push it to Docker Hub. This guide covers Dockerfile creation, adding labels, building images, and using the docker inspect command."
---

# Create Docker Image with Labels and Push to Docker Hub

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile using `nginx:alpine-slim` as the base image.
- Add labels to your Docker image.
- Create a simple `index.html` file.
- Build the Docker image.
- Push the Docker image to Docker Hub.
- Learn about the `docker inspect` command.

---

## Step 1: Create Dockerfile and Customized `index.html`

- **Base Image:** [Nginx Alpine Slim](https://hub.docker.com/_/nginx/tags?page_size=&ordering=&name=alpine-slim)
- **Directory:** `Dockerfiles`

**Create a `Dockerfile`:**

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# Custom Labels
LABEL maintainer="Kalyan Reddy Daida"  
LABEL version="1.0"
LABEL description="A simple Nginx Application"
# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Nginx Alpine Slim Application"
LABEL org.opencontainers.image.description="A lightweight Nginx application built on Alpine."
LABEL org.opencontainers.image.version="1.0"
LABEL org.opencontainers.image.revision="1234567890abcdef" 
LABEL org.opencontainers.image.created="2024-10-14T08:30:00Z"
LABEL org.opencontainers.image.url="https://github.com/stacksimplify/docker-in-a-weekend"
LABEL org.opencontainers.image.source="https://github.com/stacksimplify/docker-in-a-weekend/tree/main/04-Dockerfile-LABELS/Dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/stacksimplify/docker-in-a-weekend/tree/main/04-Dockerfile-LABELS"
LABEL org.opencontainers.image.vendor="STACKSIMPLIFY"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Using COPY to copy a local file
COPY index.html /usr/share/nginx/html
```

**Create a simple `index.html`:**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StackSimplify</title>
  <style>
    body { 
      font-family: Arial, sans-serif; 
      text-align: center; 
      padding: 50px; 
      background-color: rgb(227, 213, 180);
    }
    h1 { font-size: 50px; }
    h2 { font-size: 40px; }
    h3 { font-size: 30px; }
    p { font-size: 20px; }
  </style>
</head>
<body>
  <h1>Welcome to StackSimplify</h1>
  <h2>Dockerfile: Nginx Alpine Slim Docker Image with custom LABELS and OCI LABELS</h2>
  <p>Learn technology through practical, real-world demos.</p>
  <p>Application Version: v1</p>
</body>
</html>
```

---

## Step 2: Build Docker Image and Run It

```bash
# Change to the directory containing your Dockerfile
cd Dockerfiles

# Build the Docker image
docker build -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build -t demo4-dockerfile-labels:v1 .

# Important Notes:
# 1. [IMAGE-TAG] is optional; if not provided, it defaults to "latest".
# 2. Best practice is to use explicit tags.

# List Docker Images
docker images

# Run the Docker container
docker run --name mylabels-demo -p 8080:80 -d demo4-dockerfile-labels:v1

# Access the application in your browser
http://localhost:8080
```

---

## Step 3: Install `jq` Package

`jq` is a lightweight and flexible command-line JSON processor, useful for parsing JSON output from commands like `docker inspect`.

**For macOS:**

```bash
brew install jq
jq --version
```

**For Linux (Ubuntu/Debian):**

```bash
sudo apt-get update
sudo apt-get install jq
jq --version
```

**For Linux (CentOS/RHEL):**

```bash
sudo yum install epel-release
sudo yum install jq
jq --version
```

**For Linux (Fedora):**

```bash
sudo dnf install jq
jq --version
```

**For Other Linux Distributions:**

```bash
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x ./jq
sudo mv jq /usr/local/bin
jq --version
```

**For Windows (Using Chocolatey):**

```bash
choco install jq
jq --version
```

**For Windows (Manual Install):**

1. Download the executable from [jq Releases](https://github.com/stedolan/jq/releases).
2. Choose `jq-win64.exe` (or `jq-win32.exe` for 32-bit systems).
3. Rename the downloaded file to `jq.exe`.
4. Move it to a folder in your system's PATH (e.g., `C:\Windows`).

---

## Step 4: Docker Image Inspect Commands

Use `docker inspect` to retrieve detailed information about Docker images.

```bash
# Inspect the Docker image
docker image inspect [IMAGE-NAME]:[IMAGE-TAG]

# Example:
docker image inspect demo4-dockerfile-labels:v1

# Get the creation date of the Docker image
docker inspect --format='{{.Created}}' [IMAGE-NAME]:[IMAGE-TAG]

# Example:
docker inspect --format='{{.Created}}' demo4-dockerfile-labels:v1

# Get the Docker image labels (unformatted)
docker inspect --format='{{json .Config.Labels}}' [IMAGE-NAME]:[IMAGE-TAG]

# Example:
docker image inspect --format='{{json .Config.Labels}}' demo4-dockerfile-labels:v1

# Get the Docker image labels (formatted with jq)
docker image inspect --format='{{json .Config.Labels}}' [IMAGE-NAME]:[IMAGE-TAG] | jq

# Example:
docker image inspect --format='{{json .Config.Labels}}' demo4-dockerfile-labels:v1 | jq
```

---

## Step 5: Docker Container Inspect Commands

Use `docker inspect` to retrieve detailed information about Docker containers.

```bash
# Inspect the Docker container
docker inspect [CONTAINER-NAME or CONTAINER-ID]

# Example:
docker inspect mylabels-demo

# Get the IP address of the container
docker inspect --format='{{.NetworkSettings.IPAddress}}' [CONTAINER-NAME or CONTAINER-ID]

# Example:
docker inspect --format='{{.NetworkSettings.IPAddress}}' mylabels-demo

# Inspect container state (running, paused, stopped)
docker inspect --format='{{.State.Status}}' [CONTAINER-NAME or CONTAINER-ID]

# Example:
docker inspect --format='{{.State.Status}}' mylabels-demo

# Inspect exposed ports
docker inspect --format='{{json .Config.ExposedPorts}}' [CONTAINER-NAME or CONTAINER-ID]

# Example:
docker inspect --format='{{json .Config.ExposedPorts}}' mylabels-demo

# Inspect network details of the container (formatted with jq)
docker inspect --format='{{json .NetworkSettings}}' [CONTAINER-NAME or CONTAINER-ID] | jq

# Example:
docker inspect --format='{{json .NetworkSettings}}' mylabels-demo | jq
```

---

## Step 6: Stop and Remove Container and Images

```bash
# Stop and remove the container
docker rm -f mylabels-demo

# Remove the Docker images
docker rmi demo4-dockerfile-labels:v1

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created a Dockerfile with labels using `nginx:alpine-slim` as the base image.
- Built and ran a Docker image with custom labels.
- Pushed the Docker image to Docker Hub.
- Used the `docker inspect` command to retrieve detailed information about images and containers.
- Installed and used `jq` to format JSON output from Docker commands.

---

## Additional Notes

- **Replace Placeholders:** Remember to replace `[IMAGE-NAME]`, `[IMAGE-TAG]`, `[DOCKER_USERNAME]`, `[CONTAINER-NAME]`, and other placeholders with your actual values.
- **Docker Hub Username:** Ensure you are logged in with your Docker Hub account when pushing images.
- **Labels:** Labels are key-value pairs that allow you to add metadata to your Docker images. They follow the [Open Containers Initiative (OCI) Image Format Specification](https://github.com/opencontainers/image-spec/blob/master/annotations.md).
- **`jq` Usage:** The `jq` tool is used to parse JSON output, making it easier to read and extract specific information from commands like `docker inspect`.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Inspect Command](https://docs.docker.com/engine/reference/commandline/inspect/)
- [OCI Image Format Specification](https://github.com/opencontainers/image-spec/blob/master/annotations.md)
- [jq Manual](https://stedolan.github.io/jq/manual/)

---

**Happy Dockerizing!**


