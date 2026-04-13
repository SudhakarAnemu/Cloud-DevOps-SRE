---
title: "Learn to Mount a Directory on Host Machine to a Container Using Bind Mounts in READ-ONLY Mode"
description: "Understand how to mount a directory from the host machine to a Docker container using bind mounts in READ-ONLY mode with both `--mount` and `-v` flags."
---

# Learn to Mount a Directory on Host Machine to a Container Using Bind Mounts in READ-ONLY Mode

---
## Introduction

In this guide, you will learn how to:

1. **Mount a directory from the host machine** to a Docker container using bind mounts in READ-ONLY mode.
2. **Use bind mounts with read-only permissions** by leveraging both the `--mount` and `-v` flags.
3. **Verify the integrity and accessibility** of mounted directories.
4. **Clean up Docker resources** after completing the tasks.

Bind mounts are useful for scenarios where you need containers to access files on the host system without modifying them, such as serving static content or configuration files that should remain unchanged.

---

## Step 1: Prepare Host Directory with Static Content

Before mounting a directory to a Docker container, ensure that the host directory exists and contains the necessary static content.

### Step 1.1: Review Directory Structure

```bash
# Review Directory
cd myfiles
```

**Explanation:**

- **`cd myfiles`**: Navigates to the `myfiles` directory where the static content is located. Ensure that this directory contains the necessary files and subdirectories you intend to bind mount to the container.


---

## Step 2: Bind Mount Using `--mount` Flag (READ-ONLY)

The `--mount` flag provides a clear and explicit syntax for bind mounts.

### Step 2.1: Run Docker Container with Bind Mount Using `--mount`

```bash
# Navigate to the 'myfiles' directory
cd myfiles

# Single-Line Format
docker run --name bind-demo3 -p 8093:80 --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html,readonly -d nginx:alpine-slim  

# Readable Multi-Line Format
docker run \
  --name bind-demo3 \
  -p 8093:80 \
  --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html,readonly \
  -d \
  nginx:alpine-slim  
```

**Explanation:**

- **`--name bind-demo3`**: Names the container `bind-demo3`.
- **`-p 8093:80`**: Maps host port `8093` to container port `80`.
- **`--mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html,readonly`**:
  - **`type=bind`**: Specifies a bind mount.
  - **`source="$(pwd)"/static-content`**: The directory on the host machine to mount.
  - **`target=/usr/share/nginx/html`**: The directory inside the container where the host directory will be mounted.
  - **`readonly`**: Mounts the directory in READ-ONLY mode, preventing any write operations within the container.
- **`-d nginx:alpine-slim`**: Runs the container in detached mode using the Nginx Alpine image.

### Step 2.2: Verify the Bind Mount

```bash
# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"
```

**Example Output:**

```
IMAGE               NAMES         STATUS         ID                  PORTS
nginx:alpine-slim   bind-demo3    Up 10 seconds   abcdef123456        0.0.0.0:8093->80/tcp
```

**Explanation:**

- **`docker ps`**: Lists all running Docker containers.
- **`docker ps --format "table ..."`**: Formats the output into a table for better readability.

### Step 2.3: Connect to Container and Verify

```bash
# Connect to the Container
docker exec -it bind-demo3 /bin/sh

# Inside the Container: Check Disk Usage
df -h | grep html

# Navigate to the Mounted Directory
cd /usr/share/nginx/html
ls

# Attempt to Create a New File (Read-Only)
cp index.html reddy.html

# Exit the Container Shell
exit
```

**Observations:**

1. **Mount Point Verification:**
   - `/usr/share/nginx/html` is mounted to the `static-content` directory on the host.
   - Running `df -h | grep html` should show the mount point details.

   **Example Output:**

   ```
   /dev/sda1                58G      3.5G     51.8G   6% /usr/share/nginx/html
   ```

2. **Data Integrity:**
   - The `static-content` directory's contents are accessible within the container.
   - **Attempting to create a new file (`reddy.html`) will fail due to READ-ONLY permissions.**

   **Error Output:**

   ```
   cp: can't create 'reddy.html': Read-only file system
   ```

3. **Accessing the Application:**
   - Open a browser and navigate to `http://localhost:8093` to view the static content.
   - Access `http://localhost:8093/app1/index.html` to view App1's static content.
   - **Attempting to access `http://localhost:8093/reddy.html` will result in a 404 error**, confirming that the file was not created.

### Step 2.4: Inspect the Docker Container

```bash
# Inspect Docker Container
docker inspect bind-demo3

# Extract Mounts Information in JSON Format
docker inspect --format='{{json .Mounts}}' bind-demo3

# Pretty-Print Mounts Information Using jq
docker inspect --format='{{json .Mounts}}' bind-demo3 | jq  
```

**Explanation:**

- **`Type`**: Indicates a bind mount.
- **`Source`**: The directory on the host machine.
- **`Destination`**: The directory inside the container where the bind mount is applied.
- **`Mode`**: Shows mount options, including `readonly`.
- **`RW`**: `false` denotes READ-ONLY access.
- **`Propagation`**: Mount propagation setting.

### Step 2.5: Verify Using Docker Desktop

1. **Open Docker Desktop.**
2. **Navigate to Containers:**
   - Select **`bind-demo3`**.
3. **Check Tabs:**
   - **Bind Mounts**: Verify that `/usr/share/nginx/html` is mounted correctly and marked as READ-ONLY.
   - **Files**: Browse to `/usr/share/nginx/html` to view the files.
   - **Exec**: Run `df -h` to confirm the mount point within the container.

---

## Step 3: Bind Mount Using `-v` Flag (READ-ONLY)

The `-v` or `--volume` flag provides a shorthand syntax for bind mounts.

### Step 3.1: Run Docker Container with Bind Mount Using `-v`

```bash
# Navigate to the directory containing static content
cd myfiles

# Single-Line Format
docker run --name bind-demo4 -p 8094:80 -v "$(pwd)"/static-content:/usr/share/nginx/html:ro -d nginx:alpine-slim  

# Readable Multi-Line Format
docker run \
  --name bind-demo4 \
  -p 8094:80 \
  -v "$(pwd)"/static-content:/usr/share/nginx/html:ro \
  -d \
  nginx:alpine-slim  
```

**Explanation:**

- **`--name bind-demo4`**: Names the container `bind-demo4`.
- **`-p 8094:80`**: Maps host port `8094` to container port `80`.
- **`-v "$(pwd)"/static-content:/usr/share/nginx/html:ro`**:
  - **`$(pwd)/static-content`**: The directory on the host machine to mount.
  - **`/usr/share/nginx/html`**: The directory inside the container where the host directory will be mounted.
  - **`:ro`**: Mounts the directory in READ-ONLY mode.
- **`-d nginx:alpine-slim`**: Runs the container in detached mode using the Nginx Alpine image.

### Step 3.2: Verify the Bind Mount

```bash
# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"
```
**Explanation:**

- **`docker ps`**: Lists all running Docker containers.
- **`docker ps --format "table ..."`**: Formats the output into a table for better readability.

### Step 3.3: Connect to Container and Verify

```bash
# Connect to the Container
docker exec -it bind-demo4 /bin/sh

# Inside the Container: Check Disk Usage
df -h | grep html

# Navigate to the Mounted Directory
cd /usr/share/nginx/html
ls

# Attempt to Create a New File (Read-Only)
cp index.html reddy2.html

# Exit the Container Shell
exit
```

**Observations:**

1. **Mount Point Verification:**
   - `/usr/share/nginx/html` is mounted to the `static-content` directory on the host.
   - Running `df -h | grep html` should show the mount point details.

   **Example Output:**

   ```
   /dev/sda1                58G      3.5G     51.8G   6% /usr/share/nginx/html
   ```

2. **Data Integrity:**
   - The `static-content` directory's contents are accessible within the container.
   - **Attempting to create a new file (`reddy2.html`) will fail due to READ-ONLY permissions.**

   **Error Output:**

   ```
   cp: can't create 'reddy2.html': Read-only file system
   ```

3. **Accessing the Application:**
   - Open a browser and navigate to `http://localhost:8094` to view the static content.
   - **Attempting to access `http://localhost:8094/reddy2.html` will result in a 404 error**, confirming that the file was not created.

### Step 3.4: Inspect the Docker Container

```bash
# Inspect Docker Container
docker inspect bind-demo4

# Extract Mounts Information in JSON Format
docker inspect --format='{{json .Mounts}}' bind-demo4

# Pretty-Print Mounts Information Using jq
docker inspect --format='{{json .Mounts}}' bind-demo4 | jq  
```


**Explanation:**

- **`Type`**: Indicates a bind mount.
- **`Source`**: The directory on the host machine.
- **`Destination`**: The directory inside the container where the bind mount is applied.
- **`Mode`**: Shows mount options, including `ro` for read-only.
- **`RW`**: `false` denotes READ-ONLY access.
- **`Propagation`**: Mount propagation setting.

### Step 3.5: Verify Using Docker Desktop

1. **Open Docker Desktop.**
2. **Navigate to Containers:**
   - Select **`bind-demo4`**.
3. **Check Tabs:**
   - **Bind Mounts**: Verify that `/usr/share/nginx/html` is mounted correctly and marked as READ-ONLY.
   - **Files**: Browse to `/usr/share/nginx/html` to view the files.
   - **Exec**: Run `df -h` to confirm the mount point within the container.

---


## Step 4: Clean-Up

After completing the demonstrations, it's important to clean up Docker resources to free up system resources and maintain a tidy environment.

```bash
# Delete Docker Containers
docker rm -f $(docker ps -aq)

# Delete Docker Images
docker rmi $(docker images -q)

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

- **Mounted directories from the host machine** to Docker containers using both `--mount` and `-v` flags in READ-ONLY mode.
- **Used bind mounts with read-only permissions**, preventing containers from modifying host files.
- **Verified the integrity and accessibility** of mounted directories by attempting file operations within containers and observing outcomes on the host.
- **Cleaned up Docker resources** by removing containers, images, and volumes.

Bind mounts in READ-ONLY mode are a powerful feature in Docker, enabling secure integration between host systems and containers. They are particularly useful for serving static content, configuration management, and scenarios requiring data protection from unintended modifications.

---

## Additional Notes

- **`--mount` vs. `-v` Flags:**
  
  - **`--mount` Flag:**
    - More verbose and explicit.
    - Recommended for complex configurations.
    - **Syntax:** `--mount type=bind,source=<HOST_DIR>,target=<CONTAINER_DIR>,readonly`
  
  - **`-v` Flag:**
    - Shorthand syntax.
    - Suitable for simple volume mounts.
    - **Syntax:** `-v <HOST_DIR>:<CONTAINER_DIR>:ro`
  
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

