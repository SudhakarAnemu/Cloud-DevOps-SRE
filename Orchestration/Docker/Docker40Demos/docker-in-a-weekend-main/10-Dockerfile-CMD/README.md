---
title: "Learn Dockerfile CMD Instructions Practically"
description: "Understand how to use the CMD instruction in Dockerfiles, and how to override CMD during the 'docker run' command."
---

# Learn Dockerfile CMD Instructions Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile with the `CMD` instruction.
- Understand how to override the `CMD` instruction during the `docker run` command.
- Build the Docker image and verify its functionality.

---

## Step 1: Create Dockerfile and Custom `index.html`

- **Directory:** `DockerFiles`

**Create a `Dockerfile` with the following content:**

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: CMD Instruction in Docker"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the use of the CMD instruction"
LABEL org.opencontainers.image.version="1.0"

# Copy a custom index.html to the Nginx HTML directory
COPY index.html /usr/share/nginx/html

# Default CMD to start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
```

**Create a simple `index.html`:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(227, 213, 180);'> 
    <h1>Welcome to StackSimplify - CMD  Dockerfile Instruction</h1> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>     
    <p>CMD: Specify default commands.</p>     
  </body>
</html>
```

---

## Step 2: Build Docker Image and Run It

```bash
# Change to the directory containing your Dockerfile
cd DockerFiles

# Build the Docker Image
docker build -t [IMAGE_NAME]:[TAG] .

# Example:
docker build -t demo10-dockerfile-cmd:v1 .

# Run the Docker Container
docker run --name my-cmd-demo1 -p 8080:80 -d demo10-dockerfile-cmd:v1

# Verify Nginx is running inside the container
docker exec -it my-cmd-demo1 ps aux

# Expected Output:
# You should see the Nginx process running with 'nginx: master process nginx -g daemon off;'

# Access the application in your browser
http://localhost:8080
```

**Observations:**

1. The Nginx process should be running inside the container.
2. The `CMD ["nginx", "-g", "daemon off;"]` defined in the Dockerfile is executed as-is.

---

## Step 3: Run Docker Container by Overriding CMD

```bash
# Run Docker Container by overriding the CMD instruction
docker run --name my-cmd-demo2 -it demo10-dockerfile-cmd:v1 /bin/sh

# Run inside container ps aux
ps aux

# Expected Output:
# Nginx is not running because the CMD has been overridden with '/bin/sh'

# You can start Nginx manually if desired:
nginx -g 'daemon off;'

# To exit the container shell:
exit
```

**Observations:**

1. After connecting to the Docker container, Nginx is not running.
2. The `CMD` instruction has been overridden with `/bin/sh` during `docker run`.

---

## Step 4: Stop and Remove Containers and Images

```bash
# Stop and remove the containers
docker rm -f my-cmd-demo1
docker rm -f my-cmd-demo2

# Remove the Docker images from local machine
docker rmi [DOCKER_USERNAME]/[IMAGE_NAME]:[TAG]
docker rmi [IMAGE_NAME]:[TAG]

# Example:
docker rmi demo10-dockerfile-cmd:v1

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created an Nginx Dockerfile using the `CMD` instruction.
- Built the Docker image and ran it, observing the default `CMD` execution.
- Overridden the `CMD` instruction during `docker run` and verified its effect.
- Tagged and pushed the Docker image to Docker Hub.

---

## Additional Notes

- **CMD Instruction:**

  - The `CMD` instruction specifies the default command to run when starting a container from the image.
  - It can be overridden by specifying a different command during `docker run`.
  - Only the last `CMD` instruction in the Dockerfile takes effect.

- **Overriding CMD:**

  - When you specify a command at the end of the `docker run` command, it overrides the `CMD` specified in the Dockerfile.
  - This is useful when you want to run different commands using the same image.

- **Best Practices:**

  - Use `CMD` to specify the default command for the container.
  - Use `ENTRYPOINT` when you want to define a fixed command and allow additional parameters.
  - Avoid using both `ENTRYPOINT` and `CMD` unless necessary.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - CMD Instruction](https://docs.docker.com/engine/reference/builder/#cmd)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding CMD and ENTRYPOINT in Docker](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact)

---

**Happy Dockerizing!**
