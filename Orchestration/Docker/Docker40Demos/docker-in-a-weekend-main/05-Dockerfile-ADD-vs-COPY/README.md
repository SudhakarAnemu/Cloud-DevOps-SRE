---
title: "Learn Dockerfile ADD vs COPY Instructions Practically"
description: "Create a Dockerfile with ADD and COPY instructions to understand their differences in Docker image building."
---

# Learn Dockerfile ADD vs COPY Instructions Practically

---

## Introduction

In this guide, you will:

- Create an Nginx Dockerfile using `nginx:alpine-slim` as the base image.
- Add labels to your Docker image.
- Add `COPY` and `ADD` instructions in the Dockerfile and understand the differences.
- Build the Docker image.
- Push the Docker image to Docker Hub.

---

## Step 1: Create a GitHub Repo

## Step 2: Review App-Files Folder and Tar the Files

```bash
# Navigate to the App-Files directory
cd App-Files

# Create a tar.gz archive of the files
tar -czvf static_files.tar.gz index.html file1.html file2.html file3.html file4.html file5.html

# Copy the tar.gz file to the Dockerfiles directory
cp static_files.tar.gz ../Dockerfiles

# Review the copy-file.html in Dockerfiles
cat ../Dockerfiles/copy-file.html
```

---

## Step 2: Create Dockerfile and Copy Customized Files

- **Folder:** Dockerfiles

Create a `Dockerfile` with the following content:

```dockerfile
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: COPY vs ADD Instructions in Dockerfile"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the differences between COPY and ADD instructions, including copying files and extracting tarballs."
LABEL org.opencontainers.image.version="1.0"

# Using COPY to copy a local file
COPY copy-file.html /usr/share/nginx/html

# Using ADD to copy a file and extract a tarball
ADD static_files.tar.gz /usr/share/nginx/html
```

---

## Step 3: Build Docker Image and Run It

```bash
# Change Directory
cd Dockerfiles

# Build Docker Image
docker build -t [IMAGE-NAME]:[IMAGE-TAG] .

# Example:
docker build -t demo5-dockerfile-add-vs-copy:v1 .

# Run Docker Container and Verify
docker run --name my-add-vs-copy-demo -p 8080:80 -d demo5-dockerfile-add-vs-copy:v1

# List Static Files from Docker Container
docker exec -it my-add-vs-copy-demo ls -lrta /usr/share/nginx/html


# Access Application
http://localhost:8080
```

---

## Step 4: Stop and Remove Container and Images

```bash
# Stop and remove the container
docker rm -f my-add-vs-copy-demo

# Remove the Docker images
docker rmi stacksimplify/demo5-dockerfile-add-vs-copy:v1
docker rmi demo5-dockerfile-add-vs-copy:v1

# List Docker Images to confirm removal
docker images
```

---

## Step 5: COPY vs ADD in Dockerfile

When working with Dockerfiles, it’s important to understand the difference between `COPY` and `ADD` instructions. Both are used to copy files from the host machine into the Docker image, but they have distinct behaviors and best practices.

### Key Points:

1. **COPY**:
   - Copies files and directories from the build context to the Image.
   - Simple and explicit in its functionality, used purely for file transfers.
   - Preferred for local files and directories as it is faster and avoids unintended side effects.

2. **ADD**:
   - Does everything `COPY` does, but with additional features.
   - Automatically extracts tar archives (e.g., `.tar`, `.tar.gz`).
   - Supports URLs, allowing files to be fetched from the web.
   - More versatile, but can introduce security risks (especially with URLs) and unintended behavior (e.g., auto-extraction).

### Best Practice:

- Use `COPY` whenever possible for local files. Reserve `ADD` for cases where you need to extract a tarball or download from a URL.

### Comparison Table:

| Feature                   | `COPY`                                   | `ADD`                                          |
|---------------------------|------------------------------------------|------------------------------------------------|
| **File Transfer**         | Copies files from build context          | Copies files from build context                |
| **Tar Archive Extraction**| No                                       | Yes (automatically extracts `.tar` files)      |
| **URL Support**           | No                                       | Yes (can fetch files from the web)             |
| **Performance**           | Faster, less overhead                    | Can be slower if using additional features     |
| **Security**              | Safer for local file transfers           | Can introduce risks when fetching from URLs    |
| **Use Case**              | Preferred for all local file copies      | Use only for tar extraction or URL fetching    |

---

## Conclusion

You have successfully:

- Created a Dockerfile using `nginx:alpine-slim` as the base image.
- Used both `COPY` and `ADD` instructions in the Dockerfile to understand their differences.
  - `COPY` is used for copying files and directories.
  - `ADD` can also copy files but has additional features like extracting compressed files and supporting remote URLs.
- Built and ran a Docker image.
- Pushed the Docker image to Docker Hub.

---

## Additional Notes

- **Replace Placeholders:** Remember to replace `[IMAGE-NAME]`, `[IMAGE-TAG]`, `[DOCKER_USERNAME]`, and other placeholders with your actual values.
- **Best Practices:**
  - Use explicit tags for your Docker images to manage versions effectively.
  - Clean up unused images and containers to free up disk space.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding COPY vs. ADD in Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)

---

**Happy Dockerizing!**
