---
title: "Docker Storage - Learn to Use a tmpfs Mount in a Container"
description: "Learn how to use a tmpfs mount in a Docker container for ephemeral storage."
---

# Docker Storage - Learn to Use a tmpfs Mount in a Container

---

## Introduction

In this guide, you will learn how to:

1. **Use a tmpfs mount in a Docker container** for ephemeral storage.
2. **Understand additional options** available for tmpfs mounts.
3. **Recognize the limitations** of using tmpfs mounts.
4. **Clean up Docker resources** after completing the tasks.

**tmpfs** mounts are temporary file storage systems that reside in the host system's memory. They are useful for scenarios requiring fast, ephemeral storage that doesn't persist after the container stops.

---
## Step 1: Introduction to tmpfs Mounts

Before diving into using tmpfs mounts, it's essential to understand what they are and when to use them.

- **tmpfs Mounts:**
  - Store data in the host system's RAM.
  - Data is **ephemeral** and **does not persist** after the container stops.
  - Ideal for temporary storage needs, such as caching or sensitive data that shouldn't be written to disk.

---
## Step 2: Use a tmpfs Mount in a Container

This section demonstrates how to create and use a tmpfs mount within a Docker container.

### Step 2.1: Run a Docker Container with tmpfs Mount

```bash
# Run a Docker container with a tmpfs mount at /app
docker run --name tmpfs-demo --mount type=tmpfs,destination=/app -d nginx:alpine-slim
```


**Explanation:**

- **`--name tmpfs-demo`**: Names the container `tmpfs-demo`.
- **`--mount type=tmpfs,destination=/app`**:
  - **`type=tmpfs`**: Specifies that a tmpfs mount is being used.
  - **`destination=/app`**: The directory inside the container where the tmpfs mount will be attached.
- **`-d nginx:alpine-slim`**: Runs the container in detached mode using the lightweight Nginx Alpine image.

### Step 2.2: Verify the tmpfs Mount

```bash
# List running Docker containers
docker ps

# Inspect the tmpfs mount details
docker inspect tmpfs-demo --format '{{ json .Mounts }}'
```

**Explanation:**

- **`Type`**: Indicates a tmpfs mount.
- **`Destination`**: The mount point inside the container (`/app`).
- **`RW`**: `true` denotes read-write access to the tmpfs mount.

### Step 2.3: Test tmpfs Mount Persistence

```bash
# Connect to the container
docker exec -it tmpfs-demo /bin/sh

# Inside the container: Check disk usage to confirm tmpfs mount
df -h | grep /app

# Navigate to the tmpfs mount directory
cd /app
ls

# Create sample files within the tmpfs mount
echo "file1 content" > file1.html
echo "file2 content" > file2.html
ls

# Exit the container shell
exit

# Stop the Docker container
docker stop tmpfs-demo

# Start the Docker container again
docker start tmpfs-demo

# Reconnect to the container
docker exec -it tmpfs-demo /bin/sh

# Inside the container: Verify the tmpfs mount contents
df -h | grep /app
cd /app
ls
exit

# Observation:
# 1. The /app directory is empty after restarting the container.
# 2. Files created inside the tmpfs mount do not persist across container restarts.
```

**Explanation:**

- **Creating Files:** Demonstrates that you can write to the tmpfs mount while the container is running.
- **Persistence Test:** After stopping and restarting the container, the `/app` directory is empty, confirming that tmpfs mounts are ephemeral.

---
## Step 3: Additional tmpfs Options

Docker allows you to specify additional options for tmpfs mounts to control their behavior.

### Step 3.1: Verify Size of tmpfs Mount

By default, tmpfs mounts have a maximum size of 50% of the host's total RAM. You can customize this using the `tmpfs-size` option.

```bash
# Run a Docker container with a tmpfs mount of 100MB
docker run --name tmpfs-demo-size --mount type=tmpfs,destination=/app,tmpfs-size=100m -d nginx:alpine-slim

# Inspect the container to verify tmpfs size
docker inspect tmpfs-demo-size --format '{{ json .Mounts }}' | jq
```

**Sample Output:**

```json
[
  {
    "Type": "tmpfs",
    "Source": "",
    "Destination": "/app",
    "Mode": "",
    "RW": true,
    "Propagation": "",
    "Options": {
      "size": "100m"
    }
  }
]
```

**Explanation:**

- **`tmpfs-size=100m`**: Sets the maximum size of the tmpfs mount to 100 megabytes.

---
## Step 4: Limitations of tmpfs Mounts

While tmpfs mounts offer benefits, they also come with certain limitations:

1. **Ephemeral Storage:**
   - Data stored in tmpfs mounts **does not persist** after the container stops.
   - Not suitable for data that needs to be retained across container restarts.

2. **No Sharing Between Containers:**
   - Unlike Docker volumes, tmpfs mounts **cannot be shared** between multiple containers.

3. **Memory Consumption:**
   - tmpfs mounts consume **RAM**. Excessive use can lead to memory exhaustion on the host.

---
## Step 5: Clean-Up

After completing the demonstrations, it's important to clean up Docker resources to free up system resources and maintain a tidy environment.

```bash
# Delete All Docker Containers
docker rm -f $(docker ps -aq)

# Delete All Docker Images
docker rmi $(docker images -q)

# Optionally, remove unused Docker volumes
docker volume prune -f
```

**Explanation:**

- **`docker rm -f $(docker ps -aq)`**: Forcefully removes all Docker containers, both running and stopped.
- **`docker rmi $(docker images -q)`**: Removes all Docker images from the system. *Use with caution.*
- **`docker volume prune -f`**: Removes all unused Docker volumes. The `-f` flag forces the operation without a confirmation prompt.

---
## Conclusion

You have successfully:

- **Used a tmpfs mount in a Docker container**, enabling ephemeral in-memory storage.
- **Configured additional options** for tmpfs mounts, such as setting size limits.
- **Tested the persistence behavior** of tmpfs mounts, confirming their ephemeral nature.
- **Understood the limitations** of tmpfs mounts, including their lack of persistence and sharing capabilities.
- **Cleaned up Docker resources** to maintain a clean environment.

**tmpfs mounts** are powerful for scenarios requiring fast, temporary storage that doesn't persist beyond the container's lifecycle. They are ideal for caching, temporary data processing, and storing sensitive information that should not be written to disk.

---
## Additional Notes

- **tmpfs vs. Docker Volumes:**
  - **tmpfs Mounts:**
    - Store data in RAM.
    - Ephemeral and do not persist after container stops.
    - Cannot be shared between containers.
  
  - **Docker Volumes:**
    - Store data on the host filesystem.
    - Persist data across container restarts.
    - Can be shared between multiple containers.

- **Memory Management:**
  - Monitor the memory usage of your host system when using tmpfs mounts to prevent resource exhaustion.
  
- **Security Considerations:**
  - Since tmpfs mounts reside in memory, they can be more secure for sensitive data as they are not written to disk.
  
- **Use Cases:**
  - Caching temporary data.
  - Storing sensitive information like API keys or tokens.
  - Temporary storage for build processes or data processing tasks.

---
## Additional Resources

- [Docker Documentation - tmpfs Mounts](https://docs.docker.com/storage/tmpfs/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/docker/)
- [Understanding Docker Storage Drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security - Use Volumes Securely](https://docs.docker.com/engine/security/security/#docker-volumes)

---
**Happy Dockerizing!**

