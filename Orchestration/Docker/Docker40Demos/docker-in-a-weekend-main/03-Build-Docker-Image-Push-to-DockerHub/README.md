---
title: "How to Create and Push Docker Images to Docker Hub: A Step-by-Step Guide"
description: "Learn how to build a Docker image, tag it, and push it to Docker Hub. This tutorial covers creating a Docker Hub account, Dockerfile creation, image building, tagging, and pushing to Docker Hub."
---

# How to Create and Push Docker Images to Docker Hub: A Step-by-Step Guide

---

## Introduction

In this guide, you will:

1. Create a Docker Hub account.
2. Sign in with your Docker ID in Docker Desktop.
3. Log in to Docker Hub using the Docker CLI.
4. Run a base Nginx Docker image.
5. Create a custom `Dockerfile` and `index.html`.
6. Build a Docker image from the `Dockerfile`.
7. Tag and push the Docker image to Docker Hub.
8. Search and explore Docker images on Docker Hub.

> **Important Note:** In the commands below, wherever you see `stacksimplify`, replace it with your Docker Hub username.

---

## Step 1: Create Docker Hub Account

- Visit [Docker Hub](https://hub.docker.com/) and sign up for a new account.

> **Note:** Docker Hub sign-in is not required for downloading public images. For example, the Docker image `stacksimplify/mynginx` is a public image.

---

## Step 2: Sign In to Docker Desktop

- Open **Docker Desktop**.
- Click on **Sign In** and log in with your Docker ID.

---

## Step 3: Verify Docker Version and Log In via Command Line

```bash
# Check Docker version
docker version

# Log in to Docker Hub
docker login

# To Logout from Docker Hub
docker logout
```

---

## Step 4: Run the Base Nginx Container

- Refer to the [NGINX Docker Image on Docker Hub](https://hub.docker.com/_/nginx).

```bash
# Run the default Nginx Docker Image
docker run --name <CONTAINER-NAME> -p <HOST_PORT>:<CONTAINER_PORT> -d <IMAGE_NAME>:<TAG>

# Example:
docker run --name myapp1 -p 8090:80 -d nginx

# List running Docker containers
docker ps

# Access the application in your browser
http://localhost:8090

# Stop and remove the Docker container
docker stop myapp1
docker rm myapp1

# Or force remove the container
docker rm -f myapp1
```

---

## Step 5: Create Dockerfile and Customized `index.html`

- **Directory:** `Dockerfiles`

**Create a `Dockerfile`:**

```dockerfile
FROM nginx
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
      background-color: rgb(197, 144, 144);
    }
    h1 { font-size: 50px; }
    h2 { font-size: 40px; }
    h3 { font-size: 30px; }
    p { font-size: 20px; }
  </style>
</head>
<body>
  <h1>Welcome to StackSimplify</h1>
  <h2>Docker Image BUILD, RUN, TAG and PUSH to Docker Hub</h2>
  <p>Learn technology through practical, real-world demos.</p>
  <p>Application Version: v1</p>
</body>
</html>
```

---

## Step 6: Build Docker Image and Run It

```bash
# Change to the directory containing your Dockerfile
cd Dockerfiles

# Build the Docker image
docker build -t <IMAGE_NAME>:<TAG> .

# Example:
docker build -t mynginx-custom:v1 .

# List Docker images
docker images

# Run the Docker container and verify
docker run --name <CONTAINER-NAME> -p <HOST_PORT>:<CONTAINER_PORT> -d <IMAGE_NAME>:<TAG>

# Example:
docker run --name mynginx1 -p 8090:80 -d mynginx-custom:v1

# Access the application in your browser
http://localhost:8090
```

---

## Step 7: Tag and Push the Docker Image to Docker Hub

```bash
# List Docker images
docker images

# Tag the Docker image
docker tag mynginx-custom:v1 YOUR_DOCKER_USERNAME/mynginx-custom:v1

# Example with 'stacksimplify':
docker tag mynginx-custom:v1 stacksimplify/mynginx-custom:v1

# Push the Docker image to Docker Hub
docker push YOUR_DOCKER_USERNAME/mynginx-custom:v1

# Example with 'stacksimplify':
docker push stacksimplify/mynginx-custom:v1

# IMPORTANT NOTE:
# Replace YOUR_DOCKER_USERNAME with your actual Docker Hub username.
```

---

## Step 8: Verify the Docker Image on Docker Hub

- Log in to Docker Hub and verify the image you have pushed.
- Navigate to your repositories: [Docker Hub Repositories](https://hub.docker.com/repositories).

---

## Step 9: Explore Docker Hub Web Interface

- Visit [Docker Hub](https://hub.docker.com/).
- Search for Docker images.
- Use filters to refine your search results.

---

## Step 10: Use Docker Search Command

```bash
# Search for 'nginx' images
docker search nginx

# Limit the search results to 5
docker search nginx --limit 5

# Filter search results by stars (e.g., images with at least 50 stars)
docker search --filter=stars=50 nginx

# Filter for official images only
docker search --filter=is-official=true nginx
```

---

## Conclusion

You've successfully created a Docker image, tagged it, and pushed it to Docker Hub. You've also learned how to search for images using both the Docker Hub web interface and the Docker CLI.

**Congratulations!**

---

## Additional Notes

- **Replace Placeholders:** Remember to replace `<YOUR-DOCKER-USERNAME>`, `<CONTAINER-NAME>`, `<HOST_PORT>`, `<CONTAINER_PORT>`, `<IMAGE_NAME>`, and `<TAG>` with your actual values.
- **Docker Hub Username:** Ensure you are logged in with your Docker Hub account when pushing images.
- **Public vs. Private Repositories:** Docker Hub allows unlimited public repositories for free accounts. Private repositories may require a paid subscription.
- **Cleanup:** To remove unused images and containers, you can use `docker system prune`, but be cautious as this will remove all unused data.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub Quickstart](https://docs.docker.com/docker-hub/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---
