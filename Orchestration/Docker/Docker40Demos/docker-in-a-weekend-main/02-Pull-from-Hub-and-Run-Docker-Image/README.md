---
title: "How to Pull and Run Docker Images from Docker Hub and run"
description: "Learn how to pull Docker images from Docker Hub and run them. This guide covers pulling images, running containers, starting and stopping containers, and removing images."
---

# How to Pull and Run Docker Images from Docker Hub and Run

---

## Introduction

In this guide, you will:

1. **Pull Docker images** from Docker Hub.
2. **Run Docker containers** using the pulled images.
3. **Start and stop Docker containers**.
4. **Remove Docker images**.
5. **Important Note:** Docker Hub sign-in is not needed for downloading public images. In this case, the Docker image `stacksimplify/mynginx` is public and does not require authentication.

---

## Step 1: Pull Docker Image from Docker Hub

```bash
# List Docker images (should be empty if none are pulled yet)
docker images

# Pull Docker image from Docker Hub
docker pull stacksimplify/mynginx:v1

# Alternatively, pull from GitHub Packages (no download limits)
docker pull ghcr.io/stacksimplify/mynginx:v1

# List Docker images to confirm the image is pulled
docker images
```

**Important Notes:**

1. **Docker Image Pull Limits:** Docker Hub imposes pull rate limits for anonymous and free users.
2. **Alternative Registry:** To avoid hitting Docker Hub pull limits, you can pull the same Docker image from **GitHub Packages**.
3. **Consistency:** Both images are the same; choose either Docker Hub or GitHub Packages based on your needs.

---

## Step 2: Run the Downloaded Docker Image

- **Copy the Docker image name** from Docker Hub or GitHub Packages.
- **HOST_PORT:** The port number on your host machine where you want to receive traffic (e.g., `8080`).
- **CONTAINER_PORT:** The port number within the container that's listening for connections (e.g., `80`).

```bash
# Run Docker Container
docker run --name <CONTAINER-NAME> -p <HOST_PORT>:<CONTAINER_PORT> -d <IMAGE_NAME>:<TAG>

# Example using Docker Hub image:
docker run --name myapp1 -p 8080:80 -d stacksimplify/mynginx:v1

# Or using GitHub Packages image:
docker run --name myapp1 -p 8080:80 -d ghcr.io/stacksimplify/mynginx:v1
```

**Access the Application:**

- Open your browser and navigate to [http://localhost:8080/](http://localhost:8080/).

---

## Step 3: List Running Docker Containers

```bash
# List only running containers
docker ps

# List all containers (including stopped ones)
docker ps -a

# List only container IDs
docker ps -q
```

---

## Step 4: Connect to Docker Container Terminal

You can connect to the terminal of a running container to inspect or debug it:

```bash
# Connect to the container's terminal
docker exec -it <CONTAINER-NAME> /bin/sh

# Example:
docker exec -it myapp1 /bin/sh

# Inside the container, you can run commands:
ls
hostname
exit  # To exit the container's terminal
```

**Execute Commands Directly:**

```bash
# List directory contents inside the container
docker exec -it myapp1 ls

# Get the hostname of the container
docker exec -it myapp1 hostname

# Print environment variables
docker exec -it myapp1 printenv

# Check disk space usage
docker exec -it myapp1 df -h
```

---

## Step 5: Stop and Start Docker Containers

```bash
# Stop a running container
docker stop <CONTAINER-NAME>

# Example:
docker stop myapp1

# Verify the container has stopped
docker ps

# Test if the application is down
curl http://localhost:8080

# Start the stopped container
docker start <CONTAINER-NAME>

# Example:
docker start myapp1

# Verify the container is running
docker ps

# Test if the application is back up
curl http://localhost:8080
```

---

## Step 6: Remove Docker Containers

```bash
# Stop the container if it's still running
docker stop <CONTAINER-NAME>
docker stop myapp1

# Remove the container
docker rm <CONTAINER-NAME>
docker rm myapp1

# Or stop and remove the container in one command
docker rm -f <CONTAINER-NAME>
docker rm -f myapp1
```

---

## Step 7: Remove Docker Images

```bash
# List Docker images
docker images

# Remove Docker image using Image ID
docker rmi <IMAGE-ID>

# Example:
docker rmi abc12345def6

# Remove Docker image using Image Name and Tag
docker rmi <IMAGE-NAME>:<IMAGE-TAG>

# Example:
docker rmi stacksimplify/mynginx:v1
```

---

## Conclusion

You have successfully learned how to pull Docker images from Docker Hub or GitHub Packages, run containers from those images, interact with running containers, and manage containers and images on your local machine.

**Congratulations!**

---

## Additional Notes

- **Replace Placeholders:** Remember to replace `<CONTAINER-NAME>`, `<HOST_PORT>`, `<CONTAINER_PORT>`, `<IMAGE_NAME>`, and `<TAG>` with your actual values.
- **Docker Hub vs. GitHub Packages:** If you encounter Docker Hub pull rate limits, consider using GitHub Packages (`ghcr.io`) as an alternative.
- **Container Names:** Giving meaningful names to your containers helps in managing them easily.
- **Cleanup:** Regularly remove unused containers and images to free up disk space.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker CLI Command Reference](https://docs.docker.com/engine/reference/commandline/docker/)

---


**Happy Dockering!**

