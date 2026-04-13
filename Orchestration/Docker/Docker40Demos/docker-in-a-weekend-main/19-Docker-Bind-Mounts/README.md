---
title: "Learn to Mount a Directory on Host Machine to a Container Using Bind Mounts"
description: "Understand how to mount a directory from the host machine to a Docker container using bind mounts with both `--mount` and `-v` flags."
---

# Learn to Mount a Directory on Host Machine to a Container Using Bind Mounts

---

## Introduction

In this guide, you will learn how to:

1. **Mount a directory from the host machine** to a Docker container using bind mounts.
2. **Use bind mounts with read-write permissions** by leveraging both the `--mount` and `-v` flags.
3. **Verify the integrity and accessibility** of mounted directories.
4. **Clean up Docker resources** after completing the tasks.

Bind mounts are useful for scenarios where you need containers to access or modify files on the host system, such as during development or when sharing configuration files.

---

## Step 1: Prepare Host Directory with Static Content

Before mounting a directory to a Docker container, ensure that the host directory exists and contains the necessary static content.

### Step 1.1: Review Directory Structure

```bash
# Review Directory
cd myfiles
```
---

## Step 2: Bind Mount Using `--mount` Flag (Read-Write)

The `--mount` flag provides a clear and explicit syntax for bind mounts.

### Step 2.1: Run Docker Container with Bind Mount Using `--mount`

```bash
# Navigate to the 'myfiles' directory
cd myfiles

# Single-Line Format
docker run --name bind-demo1 -p 8091:80 --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html -d nginx:alpine-slim  

# Readable Multi-Line Format
docker run \
  --name bind-demo1 \
  -p 8091:80 \
  --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html \
  -d \
  nginx:alpine-slim  
```

**Explanation:**

- **`--name bind-demo1`**: Names the container `bind-demo1`.
- **`-p 8091:80`**: Maps host port `8091` to container port `80`.
- **`--mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html`**:
  - **`type=bind`**: Specifies a bind mount.
  - **`source="$(pwd)"/static-content`**: The directory on the host machine to mount.
  - **`target=/usr/share/nginx/html`**: The directory inside the container where the host directory will be mounted.
- **`-d nginx:alpine-slim`**: Runs the container in detached mode using the Nginx Alpine image.

### Step 2.2: Verify the Bind Mount

```bash
# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"

# Connect to the Container
docker exec -it bind-demo1 /bin/sh

# Inside the Container: Check Disk Usage
df -h | grep html

# Navigate to the Mounted Directory
cd /usr/share/nginx/html
ls

# Attempt to Create a New File (Read-Write)
cp index.html kalyan.html

# Exit the Container Shell
exit
```

**Observations:**

1. **Mount Point Verification:**
   - `/usr/share/nginx/html` is mounted to the `static-content` directory on the host.
   - Running `df -h | grep html` should show the mount point details.
   
2. **Data Integrity:**
   - The `static-content` directory's contents are accessible within the container.
   - Creating a new file (`kalyan.html`) demonstrates read-write access.

3. **Accessing the Application:**
   - Open a browser and navigate to `http://localhost:8091` to view the static content.
   - Access `http://localhost:8091/kalyan.html` to verify the newly created file.

### Step 2.3: Inspect the Docker Container

```bash
# Inspect Docker Container
docker inspect bind-demo1

# Extract Mounts Information in JSON Format
docker inspect --format='{{json .Mounts}}' bind-demo1

# Pretty-Print Mounts Information Using jq
docker inspect --format='{{json .Mounts}}' bind-demo1 | jq  
```


**Explanation:**

- **`Type`**: Indicates a bind mount.
- **`Source`**: The directory on the host machine.
- **`Destination`**: The directory inside the container where the bind mount is applied.
- **`RW`**: `true` denotes read-write access.

### Step 2.5: Verify Using Docker Desktop

1. **Open Docker Desktop.**
2. **Navigate to Containers:**
   - Select **`bind-demo1`**.
3. **Check Tabs:**
   - **Bind Mounts**: Verify that `/usr/share/nginx/html` is mounted correctly.
   - **Files**: Browse to `/usr/share/nginx/html` to view the files.
   - **Exec**: Run `df -h` to confirm the mount point within the container.

---

## Step 3: Bind Mount Using `-v` Flag (Read-Write)

The `-v` or `--volume` flag provides a shorthand syntax for bind mounts.

### Step 3.1: Run Docker Container with Bind Mount Using `-v`

```bash
# Navigate to the directory containing static content
cd myfiles

# Single-Line Format
docker run --name bind-demo2 -p 8092:80 -v "$(pwd)"/static-content:/usr/share/nginx/html -d nginx:alpine-slim  

# Readable Multi-Line Format
docker run \
  --name bind-demo2 \
  -p 8092:80 \
  -v "$(pwd)"/static-content:/usr/share/nginx/html \
  -d \
  nginx:alpine-slim  
```

**Explanation:**

- **`--name bind-demo2`**: Names the container `bind-demo2`.
- **`-p 8092:80`**: Maps host port `8092` to container port `80`.
- **`-v "$(pwd)"/static-content:/usr/share/nginx/html`**:
  - **`$(pwd)/static-content`**: The directory on the host machine to mount.
  - **`/usr/share/nginx/html`**: The directory inside the container where the host directory will be mounted.
- **`-d nginx:alpine-slim`**: Runs the container in detached mode using the Nginx Alpine image.

### Step 3.2: Verify the Bind Mount

```bash
# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"

# Connect to the Container
docker exec -it bind-demo2 /bin/sh

# Inside the Container: Check Disk Usage
df -h | grep html

# Navigate to the Mounted Directory
cd /usr/share/nginx/html
ls

# Attempt to Create a New File (Read-Write)
cp index.html kalyan2.html

# Exit the Container Shell
exit
```

**Observations:**

1. **Mount Point Verification:**
   - `/usr/share/nginx/html` is mounted to the `static-content` directory on the host.
   - Running `df -h | grep html` should show the mount point details.
   
2. **Data Integrity:**
   - The `static-content` directory's contents are accessible within the container.
   - Creating a new file (`kalyan2.html`) demonstrates read-write access.

3. **Accessing the Application:**
   - Open a browser and navigate to `http://localhost:8092` to view the static content.
   - Access `http://localhost:8092/kalyan2.html` to verify the newly created file.

### Step 3.3: Inspect the Docker Container

```bash
# Inspect Docker Container
docker inspect bind-demo2

# Extract Mounts Information in JSON Format
docker inspect --format='{{json .Mounts}}' bind-demo2

# Pretty-Print Mounts Information Using jq
docker inspect --format='{{json .Mounts}}' bind-demo2 | jq  
```



**Explanation:**

- **`Type`**: Indicates a bind mount.
- **`Source`**: The directory on the host machine.
- **`Destination`**: The directory inside the container where the bind mount is applied.
- **`RW`**: `true` denotes read-write access.

### Step 3.5: Verify Using Docker Desktop

1. **Open Docker Desktop.**
2. **Navigate to Containers:**
   - Select **`bind-demo2`**.
3. **Check Tabs:**
   - **Bind Mounts**: Verify that `/usr/share/nginx/html` is mounted correctly.
   - **Files**: Browse to `/usr/share/nginx/html` to view the files.
   - **Exec**: Run `df -h` to confirm the mount point within the container.

---

## Step 4: Verify Files in Local Directory

After performing operations inside the containers, it's crucial to verify that changes are reflected on the host machine.

```bash
# Navigate to the static-content directory on the host
cd myfiles/static-content

# List Files
ls
```

**Observation:**

- You should find the files `kalyan.html` and `kalyan2.html` present.
  - **`kalyan.html`**: Created by `bind-demo1`.
  - **`kalyan2.html`**: Created by `bind-demo2`.

**Explanation:**

- Changes made inside the container's mounted directory are immediately reflected on the host machine, demonstrating the effectiveness of bind mounts with read-write permissions.

---

## Step 5: Clean-Up

After completing the demonstrations, it's important to clean up Docker resources to free up system resources and maintain a tidy environment.

```bash
# Delete Docker Containers
docker rm -f $(docker ps -aq)

# Delete Docker Images
docker rmi $(docker images -q)

# List Docker Volumes
docker volume ls

# Observation: 
# Volumes will persist and are not deleted even after deleting containers or images

# Delete Specific Volume
docker volume rm myvol103
```

**Explanation:**

- **`docker rm -f $(docker ps -aq)`**: Forcefully removes all Docker containers, both running and stopped.
- **`docker rmi $(docker images -q)`**: Removes all Docker images from the system. *Use with caution.*
- **`docker volume ls`**: Lists all Docker volumes to verify existing volumes.
- **`docker volume rm myvol103`**: Deletes the specific Docker volume `myvol103`.

**Notes:**

- **Data Persistence:** Docker volumes persist data even after containers or images are removed. Always ensure that you do not need the data within a volume before removing it to prevent accidental data loss.
- **Selective Cleanup:** Use specific commands to remove only the resources you no longer need, avoiding unintended deletions.

---

## Conclusion

You have successfully:

- **Mounted directories from the host machine** to Docker containers using both `--mount` and `-v` flags.
- **Used bind mounts with read-write permissions**, allowing containers to access and modify host files.
- **Verified the integrity and accessibility** of mounted directories by creating files within containers and observing changes on the host.
- **Cleaned up Docker resources** by removing containers, images, and volumes.

Bind mounts are a powerful feature in Docker, enabling seamless integration between host systems and containers. They are particularly useful for development environments, configuration management, and scenarios requiring data persistence and sharing.

---

## Additional Notes

- **`--mount` vs. `-v` Flags:**
  
  - **`--mount` Flag:**
    - More verbose and explicit.
    - Recommended for complex configurations.
    - **Syntax:** `--mount type=bind,source=<HOST_DIR>,target=<CONTAINER_DIR>`
  
  - **`-v` Flag:**
    - Shorthand syntax.
    - Suitable for simple volume mounts.
    - **Syntax:** `-v <HOST_DIR>:<CONTAINER_DIR>`
  
- **Bind Mount Permissions:**
  
  - Ensure that the Docker daemon has the necessary permissions to access the host directory.
  - Use appropriate ownership and permissions on the host directory to control access from within the container.
  
- **Volume Persistence:**
  
  - Data in bind mounts is directly tied to the host filesystem. Ensure that critical data is backed up appropriately.
  
- **Security Considerations:**
  
  - Mounting sensitive directories should be done cautiously to prevent unauthorized access or modifications.
  - Use appropriate permissions and ownership settings within volumes to safeguard data.
  
- **Best Practices:**
  
  - Use absolute paths for host directories to avoid ambiguity.
  - Regularly monitor and manage mounted directories to maintain system security and integrity.
  - Prefer named volumes for data that needs to persist independently of container lifecycles.

---

## Additional Resources

- [Docker Documentation - Use Bind Mounts](https://docs.docker.com/storage/bind-mounts/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/docker/)
- [Differences Between `-v` and `--mount`](https://docs.docker.com/storage/#choose-the--v-or---mount-flag)
- [Docker Storage Drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security - Use Volumes Securely](https://docs.docker.com/engine/security/security/#docker-volumes)

---

**Happy Dockerizing!**

