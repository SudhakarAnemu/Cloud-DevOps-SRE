---
title: "Learn to Mount a Volume Subdirectory to a Container"
description: "Understand how to mount a subdirectory of a Docker volume to a container using the `--mount` flag."
---

# Learn to Mount a Volume Subdirectory to a Container

---

## Introduction

In this guide, you will learn how to:

1. **Use the `volume-subpath` flag** when mounting volumes to containers.
2. **Mount subdirectories** from a Docker volume to specific directories within a container.

Mounting subdirectories of Docker volumes allows for more granular control over data sharing and persistence, enabling containers to access only the necessary parts of a volume.

---

## Step 1: Review Docker Volume

Before mounting, it's essential to understand the current state of our Docker volumes.

```bash
# List Docker Volumes
docker volume ls

# Example Output:
DRIVER    VOLUME NAME
local     myvol103
```

### Verify Content in Volume

1. **Using Docker Desktop:**
   - Open Docker Desktop.
   - Navigate to **Volumes**.
   - Select **`myvol103`**.
   - Click on **Stored data** to view the contents.
   - You should see the `app1` directory populated with static content.

**Explanation:**

- **`myvol103`**: This is the Docker volume we will be using for mounting a subdirectory.
- **`app1` Directory**: Contains specific static content that we intend to mount into the container.

---

## Step 3: Mount a Volume Subdirectory Using `--mount` Flag

Mounting a subdirectory of a Docker volume allows you to access only a specific part of the volume within the container.

### Run Container with Volume Subdirectory Mount

We will mount the `app1` subdirectory of the `myvol103` volume to `/usr/share/nginx/html/app1` inside the container.

```bash
# Single-Line Format
docker run --name volume-demo6 -p 8096:80 --mount type=volume,source=myvol103,target=/usr/share/nginx/html/app1,volume-subpath=app1 -d nginx:alpine-slim

# Readable Multi-Line Format
docker run \
    --name volume-demo6 \
    -p 8096:80 \
    --mount type=volume,source=myvol103,target=/usr/share/nginx/html/app1,volume-subpath=app1 \
    -d \
    nginx:alpine-slim
```

**Explanation:**

- **`--name volume-demo6`**: Names the container `volume-demo6`.
- **`-p 8096:80`**: Maps host port `8096` to container port `80`.
- **`--mount type=volume,source=myvol103,target=/usr/share/nginx/html/app1,volume-subpath=app1`**:
  - **`type=volume`**: Specifies that a Docker volume is being used.
  - **`source=myvol103`**: The name of the Docker volume to mount.
  - **`target=/usr/share/nginx/html/app1`**: The directory inside the container where the volume will be mounted.
  - **`volume-subpath=app1`**: Specifies the subdirectory within the volume to mount. *(Note: As of Docker 20.10+, `volume-subpath` is primarily used in Docker Compose. In `docker run`, simply specifying the `target` to a subdirectory achieves similar behavior.)*

### Verify the Volume Mount

```bash
# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"
```

**Example Output:**

```
IMAGE               NAMES           STATUS         ID                  PORTS
nginx:alpine-slim   volume-demo6    Up 10 seconds   abcdef123456        0.0.0.0:8096->80/tcp
```

### Connect to Container and Verify

```bash
# Connect to the Container
docker exec -it volume-demo6 /bin/sh

# Inside the Container: Check Disk Usage
df -h | grep app1

# Navigate to the Mounted Directory
cd /usr/share/nginx/html/app1
ls

# Exit the Container Shell
exit
```

**Expected Output Inside Container:**

```
/usr/share/nginx/html # df -h | grep app1
/dev/vda1                58.4G      3.5G     51.8G   6% /usr/share/nginx/html/app1

/usr/share/nginx/html # ls
index.html
app1/
```

**Observation:**

1. **Mount Point:** `/usr/share/nginx/html/app1` is correctly mounted to the `app1` subdirectory of `myvol103`.
2. **Data Integrity:** The static content from the `app1` directory is present within the mounted subdirectory, ensuring no data loss.
3. **Advantages:** Mounting subdirectories allows for selective data sharing and better organization within containers.

### Access the Application

```bash
# Access via Browser
http://localhost:8096/app1/index.html

# Access via curl
curl http://localhost:8096/app1/index.html
```

**Expected Output:**

```html
<!DOCTYPE html> 
<html> 
  <body style='background-color:rgb(136, 209, 144);'> 
    <h1>Welcome to StackSimplify -  App1 - Volume Subdirectory "/app1"</h1> 
    <p>Learn technology through practical, real-world demos.</p> 
    <p>Application Version: V1</p>     
  </body>
</html>
```

**Observation:**

- The static content from the `app1` subdirectory is accessible and correctly served by Nginx.
- This confirms that the subdirectory mount is functioning as intended.

### Inspect the Docker Container

```bash
# Inspect Docker Container
docker inspect volume-demo6

# Extract Mounts Information in JSON Format
docker inspect --format='{{json .Mounts}}' volume-demo6

# Pretty-Print Mounts Information Using jq
docker inspect --format='{{json .Mounts}}' volume-demo6 | jq
```

**Explanation:**

- These commands provide detailed information about the container's mounts.
- Using `jq` helps in formatting the JSON output for better readability.

**Sample Output:**

```json
[
  {
    "Type": "volume",
    "Name": "myvol103",
    "Source": "/var/lib/docker/volumes/myvol103/_data",
    "Destination": "/usr/share/nginx/html/app1",
    "Driver": "local",
    "Mode": "",
    "RW": true,
    "Propagation": ""
  }
]
```

**Observation:**

- Confirms that `myvol103` is mounted to `/usr/share/nginx/html/app1` within the container.
- **`RW: true`** indicates that the mount is read-write.

---

## Step 4: Clean-Up

After completing the demonstration, it's important to clean up Docker resources to free up system resources and maintain a tidy environment.

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
docker volume remove myvol103
```

**Explanation:**

- **`docker rm -f $(docker ps -aq)`**: Forcefully removes all Docker containers, both running and stopped.
- **`docker rmi $(docker images -q)`**: Removes all Docker images from the system. *Use with caution.*
- **`docker volume ls`**: Lists all Docker volumes to verify which ones still exist.
- **`docker volume remove myvol103`**: Deletes the specific Docker volume `myvol103`.

**Note:**

- **Data Persistence:** Docker volumes persist data even after containers or images are removed, ensuring that important data is not lost unintentionally.
- **Selective Cleanup:** Always ensure that you do not need the data within a volume before removing it to prevent accidental data loss.

---

## Conclusion

You have successfully:

- **Mounted a subdirectory** of a Docker volume to a container using the `--mount` flag.
- **Verified the integrity and accessibility** of the mounted subdirectory within the container.
- **Accessed the application** to confirm that the static content is served correctly.
- **Inspected the Docker container** to understand the mount configuration.
- **Cleaned up Docker resources** by removing containers, images, and volumes.

Mounting subdirectories of Docker volumes enhances data management by allowing precise control over which parts of the volume are accessible within containers. This approach is beneficial for organizing data, enhancing security, and optimizing resource usage.

---

## Additional Notes

- **`volume-subpath` Flag:**
  
  - The `volume-subpath` option is primarily used in Docker Compose files rather than in `docker run` commands.
  - In `docker run`, specifying the `target` to a subdirectory achieves similar functionality by mounting the volume directly to that subdirectory.

- **Best Practices:**
  
  - **Use Named Volumes:** They provide better manageability and clarity compared to anonymous volumes.
  - **Limit Permissions:** Use read-only mounts where appropriate to enhance security and prevent unintended modifications.
  - **Regular Cleanup:** Remove unused volumes to free up disk space and maintain system performance.

- **Volume Persistence:**
  
  - Data stored in Docker volumes persists even after the container is removed, making it ideal for databases, user-generated content, and other persistent data needs.
  
- **Security Considerations:**
  
  - Mounting sensitive directories should be done cautiously to prevent unauthorized access.
  - Use appropriate permissions and ownership settings within volumes to safeguard data.

---

## Additional Resources

- [Docker Documentation - Use Volumes](https://docs.docker.com/storage/volumes/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/docker/)
- [Differences Between `-v` and `--mount`](https://docs.docker.com/storage/#choose-the--v-or---mount-flag)
- [Docker Storage Drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security - Use Volumes Securely](https://docs.docker.com/engine/security/security/#docker-volumes)

---

**Happy Dockerizing!**

