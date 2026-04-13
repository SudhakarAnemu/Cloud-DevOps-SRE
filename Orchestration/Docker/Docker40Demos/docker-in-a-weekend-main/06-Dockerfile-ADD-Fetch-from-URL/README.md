---
title: "Learn Dockerfile ADD with Fetch from URL Practically"
description: "Learn how to use the ADD instruction in a Dockerfile to fetch content from a URL, build a Docker image, and push it to Docker Hub."
---

# Learn Dockerfile ADD with Fetch from URL Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile using `nginx:alpine-slim` as the base image.
- Add labels to your Docker image.
- Use the `ADD` instruction in the Dockerfile to fetch content from a URL (GitHub URL).
- Build the Docker image.
- Push the Docker image to Docker Hub.

---

## Step 1: Create GitHub Repository and Upload Files

1. **Create a GitHub Repository:**

   - Repository Name: `docker-add-fetch-url-demo`
   - Repository Type: Public
   - Initialize with a README (optional).

2. **Upload Files:**

   - Upload `docs` folder into your repository.
     - You can drag and drop the `docs` folder for easy upload.

3. **Create a Git Release:**

   - Go to the **Releases** section in your repository.
   - Click on **Draft a new release**.
   - **Tag version:** `v1.0.0`
   - **Release title:** `Version 1.0.0`
   - Click on **Publish release**.

---

## Step 2: Create Dockerfile and Add Instructions

- **Directory:** `Dockerfiles`

Create a `Dockerfile` with the following content:

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: Using ADD Instruction to Fetch Files from a URL in Dockerfile"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the ADD instruction, which demonstrates how to download and add content from a GitHub Releases URL to the container."
LABEL org.opencontainers.image.version="1.0"

# Using GitHub Repository to download files
ADD https://github.com/stacksimplify/docker-add-fetch-url-demo.git#v1.0.0:docs /usr/share/nginx/html
```

---

## Step 3: Build Docker Image and Run It

```bash
# Change Directory
cd Dockerfiles

# Build Docker Image
docker build -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build -t demo6-dockerfile-add-fetch-url:v1 .

# Run Docker Container and Verify
docker run --name my-add-fetch-url-demo -p 8080:80 -d demo6-dockerfile-add-fetch-url:v1

# List Static Files from Docker Container
docker exec -it my-add-fetch-url-demo ls -l /usr/share/nginx/html

# Access Application
http://localhost:8080
```

---

## Step 4: Stop and Remove Container and Images

```bash
# Stop and remove the container
docker rm -f my-add-fetch-url-demo

# Remove the Docker images
docker rmi [DOCKER_USERNAME]/[IMAGE-NAME]:[IMAGE-TAG]
docker rmi [IMAGE-NAME]:[IMAGE-TAG]

# Example:
docker rmi demo6-dockerfile-add-fetch-url:v1

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created a Dockerfile using `nginx:alpine-slim` as the base image.
- Used the `ADD` instruction to fetch content from a URL (GitHub Release).
- Built and ran a Docker image with content downloaded directly from your GitHub repository.
- Pushed the Docker image to Docker Hub.

---

## Additional Notes

- **Replace Placeholders:**

  - Remember to replace `[IMAGE-NAME]`, `[IMAGE-TAG]`, `[DOCKER_USERNAME]` with your actual values.

- **Using `ADD` with URLs:**

  - The `ADD` instruction can fetch files from remote URLs. However, it's generally recommended to use `ADD` only for local files and use `curl` or `wget` in a `RUN` command to fetch remote files for better control and caching.

- **Security Considerations:**

  - Be cautious when downloading files from external URLs, especially in automated builds, as it may introduce security risks.

- **Best Practices:**

  - Clean up any temporary files after extraction to reduce the image size.
  - Use explicit tags for your Docker images to manage versions effectively.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding ADD vs. COPY in Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)

---

**Happy Dockerizing!**
