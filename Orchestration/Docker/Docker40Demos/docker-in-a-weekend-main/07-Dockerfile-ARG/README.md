---
title: "Learn Dockerfile ARG Instructions Practically"
description: "Create a Dockerfile with ARG Instruction to understand build-time variables in Docker image building."
---

# Learn Dockerfile ARG Instructions Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile using `nginx:alpine-slim` as the base image, with the Nginx version passed using the `ARG` instruction.
- Build Docker images using the default value defined in the `Dockerfile` (`ARG NGINX_VERSION=1.26`).
- Build Docker images by overriding the Nginx version during build time using `docker build --build-arg`.
- Run the Docker containers and verify the Nginx versions.
- Clean-Up
---

## Step 1: Create Dockerfile with ARG Instruction

- **Directory:** `Dockerfiles`

Create a `Dockerfile` with the following content:

```dockerfile
# Define a build-time argument for the NGINX version
ARG NGINX_VERSION=1.26

# Use nginx:alpine-slim as base Docker Image with specified NGINX_VERSION
FROM nginx:${NGINX_VERSION}-alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: Using ARG Instruction"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the ARG instruction"
LABEL org.opencontainers.image.version="1.0"

# Copy a custom index.html to the Nginx HTML directory
COPY index.html /usr/share/nginx/html
```

**Create a simple `index.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(227, 213, 180);'> 
    <h1>Welcome to StackSimplify - ARG Build-time Variables</h1> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>     
  </body>
</html>

```

---

## Step 2: Build Docker Images and Run Them

### Build Docker Image with Default ARG Value

```bash
# Change to the directory containing your Dockerfile
cd Dockerfiles

# Build Docker Image using the default NGINX_VERSION from the Dockerfile
docker build -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build -t demo7-dockerfile-arg:v1.26 .

# Run Docker Container and Verify
docker run --name my-arg-demo1 -p 8080:80 -d demo7-dockerfile-arg:v1.26

# Verify Nginx version inside the container
docker exec -it my-arg-demo1 nginx -v

# Access the application in your browser
http://localhost:8080
```

**Expected Output:**

- The Nginx version should be **1.26**.
- The custom index page should display when accessing [http://localhost:8080](http://localhost:8080).

### Build Docker Image by Overriding ARG Value

```bash
# Build Docker Image by specifying a different NGINX_VERSION at build time
docker build --build-arg NGINX_VERSION=1.27 -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build --build-arg NGINX_VERSION=1.27 -t demo7-dockerfile-arg:v1.27 .

# Run Docker Container and Verify
docker run --name my-arg-demo2 -p 8081:80 -d demo7-dockerfile-arg:v1.27

# Verify Nginx version inside the container
docker exec -it my-arg-demo2 nginx -v

# Access the application in your browser
http://localhost:8081
```

**Expected Output:**

- The Nginx version should be **1.27**.
- The custom index page should display when accessing [http://localhost:8081](http://localhost:8081).

---

## Step 3: Stop and Remove Containers and Images

```bash
# Stop and remove the containers
docker rm -f my-arg-demo1
docker rm -f my-arg-demo2

# Remove the Docker images from local machine
docker rmi [DOCKER_USERNAME]/[IMAGE-NAME]:[IMAGE-TAG]
docker rmi [IMAGE-NAME]:[IMAGE-TAG]

# Examples:
docker rmi demo7-dockerfile-arg:v1.26
docker rmi demo7-dockerfile-arg:v1.27

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created a Dockerfile using the `ARG` instruction to define build-time variables.
- Built Docker images using the default `ARG` value specified in the Dockerfile.
- Overridden the `ARG` value during build time using `--build-arg` to specify a different Nginx version.
- Ran Docker containers and verified the Nginx versions.
- Tagged and pushed Docker images to Docker Hub.

---

## Additional Notes

- **Replace Placeholders:** Remember to replace `[IMAGE-NAME]`, `[IMAGE-TAG]`, `[DOCKER_USERNAME]`, and other placeholders with your actual values.
- **Docker Hub Username:** Ensure you are logged in with your Docker Hub account when pushing images.
- **ARG vs. ENV:**
  - `ARG` variables are only available during the build time of the image.
  - `ENV` variables are available during runtime within the container. We will see this in our upcoming demo-09 (ARG and ENV combination)
- **Best Practices:**
  - Use explicit tags for your Docker images to manage versions effectively.
  - Clean up unused images and containers to free up disk space.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - ARG Instruction](https://docs.docker.com/engine/reference/builder/#arg)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding ARG and ENV in Dockerfile](https://vsupalov.com/docker-arg-vs-env/)

---

**Happy Dockerizing!**

