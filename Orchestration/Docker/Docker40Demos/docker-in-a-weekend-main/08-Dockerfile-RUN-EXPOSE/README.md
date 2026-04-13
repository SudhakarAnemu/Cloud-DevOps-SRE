---
title: "Learn Dockerfile EXPOSE and RUN Instructions Practically"
description: "Create a Dockerfile with EXPOSE and RUN instructions to understand their usage in Docker image building."
---

# Learn Dockerfile EXPOSE and RUN Instructions Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile with `EXPOSE` and `RUN` instructions.
- Create three Nginx configuration files listening on ports 8081, 8082, and 8083.
- Create three Nginx HTML files, each served on its respective port.
- Install the `curl` binary in the container using the `RUN` instruction.
- Build the Docker image and verify both `RUN` and `EXPOSE` instructions.

---

## Step 1: Application Files

### Nginx Configuration Files

- **Directory:** `DockerFiles/nginx-conf`

**`nginx-8081.conf`:**

```conf
server {
    listen 8081;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index-8081.html;
    }
}
```

**`nginx-8082.conf`:**

```conf
server {
    listen 8082;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index-8082.html;
    }
}
```

**`nginx-8083.conf`:**

```conf
server {
    listen 8083;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index-8083.html;
    }
}
```

### Nginx HTML Files

- **Directory:** `DockerFiles/nginx-html`

**`index-8081.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(135, 215, 159);'> 
    <h1>Welcome to StackSimplify - RUN, EXPOSE Dockerfile Instructions</h1>
    <h2>Response from Nginx on port 8081</h2> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>      
    <p>EXPOSE: Describe which ports your application is listening on.</p>     
    <p>RUN: Execute build commands.</p>     
  </body>
</html>
```

**`index-8082.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(210, 153, 152);'> 
    <h1>Welcome to StackSimplify - RUN, EXPOSE Dockerfile Instructions</h1>
    <h2>Response from Nginx on port 8082</h2> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>      
    <p>EXPOSE: Describe which ports your application is listening on.</p>     
    <p>RUN: Execute build commands.</p>     
  </body>
</html>
```

**`index-8083.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(227, 213, 180);'> 
    <h1>Welcome to StackSimplify - RUN, EXPOSE Dockerfile Instructions</h1>
    <h2>Response from Nginx on port 8083</h2> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>      
    <p>EXPOSE: Describe which ports your application is listening on.</p>     
    <p>RUN: Execute build commands.</p>     
  </body>
</html>
```

**`index.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(157, 182, 216);'> 
    <h1>Welcome to StackSimplify - RUN, EXPOSE Dockerfile Instructions</h1>
    <h2>Response from Nginx on port 80</h2> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>      
    <p>EXPOSE: Describe which ports your application is listening on.</p>     
    <p>RUN: Execute build commands.</p>     
  </body>
</html>
```

---

## Step 2: Create Dockerfile

- **Directory:** `DockerFiles`

Create a `Dockerfile` with the following content:

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: Using RUN and EXPOSE Instructions in Dockerfile"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the usage of RUN and EXPOSE instructions"
LABEL org.opencontainers.image.version="1.0"

# Copy all Nginx configuration files from nginx-conf directory
COPY nginx-conf/*.conf /etc/nginx/conf.d/

# Copy all HTML files from nginx-html directory
COPY nginx-html/*.html /usr/share/nginx/html/

# Install curl using RUN
RUN apk --no-cache add curl

# Expose the ports 8081, 8082, 8083 (default port 80 already exposed from base nginx image)
EXPOSE 8081 8082 8083
```

---

## Step 3: Build Docker Image and Run It

```bash
# Change Directory
cd DockerFiles

# Build Docker Image 
docker build -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build -t demo8-dockerfile-expose-run:v1 .

# Inspect Labels
docker image inspect demo8-dockerfile-expose-run:v1

# Run Docker Container and Map Ports
docker run --name my-expose-run-demo -p 8080:80 -p 8081:8081 -p 8082:8082 -p 8083:8083 -d demo8-dockerfile-expose-run:v1

# Access Application in Browser
http://localhost:8080
http://localhost:8081
http://localhost:8082
http://localhost:8083

# List Configuration Files from Docker Container
docker exec -it my-expose-run-demo ls /etc/nginx/conf.d

# List HTML Files from Docker Container
docker exec -it my-expose-run-demo ls /usr/share/nginx/html

# Connect to Container Shell
docker exec -it my-expose-run-demo /bin/sh

# Commands to Run inside the Container
curl http://localhost
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083

# Exit the Container Shell
exit
```

**Observations:**

1. The `curl` commands inside the Docker container work, which means the `RUN` instruction to install `curl` was successful.
2. All Nginx listening ports are accessible inside the Docker container.

---

## Step 4: Stop and Remove Container and Images

```bash
# Stop and Remove the Container
docker rm -f my-expose-run-demo

# Remove the Docker Images
docker rmi [DOCKER_USERNAME]/[IMAGE-NAME]:[IMAGE-TAG]
docker rmi [IMAGE-NAME]:[IMAGE-TAG]

# Examples:
docker rmi demo8-dockerfile-expose-run:v1

# List Docker Images to Confirm Removal
docker images
```

---

## Conclusion

You have successfully:

- Created an Nginx Dockerfile using the `EXPOSE` and `RUN` instructions.
- Configured Nginx to listen on multiple ports by adding custom configuration files.
- Served different HTML pages on different ports.
- Installed additional packages (`curl`) inside the Docker image using the `RUN` instruction.
- Built and ran the Docker image, verifying the functionality of the `RUN` and `EXPOSE` instructions.
- Tagged and pushed the Docker image to Docker Hub.

---

## Additional Notes

- **EXPOSE Instruction:**
  - The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime.
  - It does not actually publish the ports; you still need to use the `-p` or `-P` flag with `docker run` to map the ports.

- **RUN Instruction:**
  - The `RUN` instruction executes commands in a new layer on top of the current image and commits the results.
  - It's used for installing software packages or any command that needs to be run during the image build process.

- **Best Practices:**
  - Use explicit tags for your Docker images to manage versions effectively.
  - Clean up unused images and containers to free up disk space.
  - Keep your Docker images small by minimizing the number of layers and using lightweight base images.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [EXPOSE Instruction](https://docs.docker.com/engine/reference/builder/#expose)
- [RUN Instruction](https://docs.docker.com/engine/reference/builder/#run)
- [Understanding Port Binding in Docker](https://docs.docker.com/config/containers/container-networking/)

---

**Happy Dockerizing!**
