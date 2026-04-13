---
title: Learn the differences between Docker Volumes and Bind Mounts when mounted to a Non-empty directory in a container
description: Learn the differences between Docker Volumes and Bind Mounts when mounted to a Non-empty directory in a container
---

## Step-01: Introduction
1. Learn the differences between Docker Volumes and Bind Mounts when mounted to a Non-empty directory in a container
2. Create a Docker Image with Nginx Static content
3. Mount Volume to a Container using `--mount flag` (type=volume)
4. Use Bind Mount to a Container `--mount flag` (type=bind)
5. Observe the differences
    - Volume will persist the previous container data
    - Bind Mount will obscure the previous container data

## Step-02: Create a new Docker Image for this demo
### Step-02-01: Review Dockerfile
```bash
# Use nginx:alpine-slim as base Docker Image
FROM nginx:alpine-slim

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: Docker Volumes vs Bind Mounts"
LABEL org.opencontainers.image.description="Learn the Differences Between Docker Volumes and Bind Mounts When Mounted to a Non-Empty Directory in a Container"
LABEL org.opencontainers.image.version="1.0"

# Using COPY to copy a local file
COPY ./static-content/ /usr/share/nginx/html
```

### Step-02-02: Review Static Content that will be used for Nginx
- **Folder:** Dockerfiles/static-content
    - file1.html
    - file2.html
    - file3.html
    - file4.html
    - file5.html
    - index.html
    - app1/index.html

### Step-02-03: Build a Docker Image
```bash
# Change Directory
cd Dockerfiles

# Build Docker Image
docker build -t <IMAGE_NAME>:<TAG> .
docker build -t mynginx-nonemptydir:v1 .

# List Docker Images
docker images

# Run Docker Container and Verify
docker run --name=nonemtpydir-demo1 -p 8095:80 -d mynginx-nonemptydir:v1

# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"

# Connect to container and Verify
docker exec -it nonemtpydir-demo1 /bin/sh

# Run Commands inside container
cd /usr/share/nginx/html
ls
Observation:
1. All static files present

## Sample Output
/usr/share/nginx/html # ls
50x.html    file1.html  file3.html  file5.html
app1        file2.html  file4.html  index.html


# Access Application
http://localhost:8095
Observation:
1. We have all our static content present and accessible
```

## Step-03: Volume: Mount Volume to a Container using --mount flag
- If you start a container which creates a new volume, and the container has files or directories in the directory to be mounted such as /app/, Docker copies the directory's contents into the volume. 
- The container then mounts and uses the volume, and other containers which use the volume also have access to the pre-populated content.
```bash
# Verify any existing volumes present
docker volume ls

# Single Line Format: Using --mount option with volume location in container as /usr/share/nginx/html
docker run --name nonemtpydir-volume-demo -p 8096:80 --mount type=volume,source=myvol103,target=/usr/share/nginx/html -d mynginx-nonemptydir:v1

# Readable Format: Using --mount option with volume location in container as /usr/share/nginx/html
docker run \
    --name nonemtpydir-volume-demo \
    -p 8096:80 \
    --mount type=volume,source=myvol103,target=/usr/share/nginx/html \
    -d \
    mynginx-nonemptydir:v1

# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"

# Connect to Container and verify
docker exec -it nonemtpydir-volume-demo /bin/sh

# Run commands inside container
df -h
cd /usr/share/nginx/html
ls
exit
Observation:
1. We should see a new docker volume mount created in container
2. Whatever earlier present "/usr/share/nginx/html" from docker image copied successfully to Docker Volume mounted in container at path "/usr/share/nginx/html"
3. NO DATA LOSS
4. THIS IS THE GREATEST ADVANTAGE

# Inspect Docker Container
docker inspect volume-demo1
docker inspect --format='{{json .Mounts}}' nonemtpydir-volume-demo
docker inspect --format='{{json .Mounts}}' nonemtpydir-volume-demo | jq

# Access Application
http://localhost:8096
Observation:
1. We have all our static content present and accessible

# Review Volume in Docker Desktop
1. Go to Docker Desktop
2. Firstly we will find that content is present myvol103 (Size: 2.7KB) 
3. Go to myvol103
- Review Stored Data tab: We will find all content in that volume
```

## Step-04: Bind Mount: Bind Mount using --mount flag and READ-WRITE
```bash
# Change Directory
cd myfiles

# Single line Format: Using --mount option with type=bind and target location in container as /usr/share/nginx/html
docker run --name nonemtpydir-bind-demo -p 8097:80 --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html -d nginx:alpine-slim  

# Readable Format: Using --mount option with type=bind and target location in container as /usr/share/nginx/html
docker run \
  --name nonemtpydir-bind-demo \
  -p 8097:80 \
  --mount type=bind,source="$(pwd)"/static-content,target=/usr/share/nginx/html \
  -d \
  mynginx-nonemptydir:v1

# List Docker Containers
docker ps
docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.ID}}\t{{.Ports}}"

# Connect to Container and verify
docker exec -it nonemtpydir-bind-demo /bin/sh

# Run commands inside container
df -h
cd /usr/share/nginx/html
ls
exit

### SAMPLE OUTPUT
/usr/share/nginx/html # ls
local1.html
/usr/share/nginx/html # 

Observation: 
1. All data present inside container at location "/usr/share/nginx/html" is obscured
2. Only content from local directory from HOST_MACHINE is present in "/usr/share/nginx/html"
3. This can be beneficial, such as when you want to test a new version of your application without building a new image, just by creating new container and updated code bind mount for that container
4. VERY IMPORTANT NOTE: We should be very careful when mounting Bind Mounts to non-emtpy directories in a container, else it would take down our application
5. Pros and cons will be completely based on the usecase we are using in our organization


# Access Application
http://localhost:8097/local1.html
Observation:
1. We have all our static content present from HOST MACHINE and accessible
2. File system is READ-WRITE


# Inspect Docker Container
docker inspect nonemtpydir-bind-demo
docker inspect --format='{{json .Mounts}}' nonemtpydir-bind-demo
docker inspect --format='{{json .Mounts}}' nonemtpydir-bind-demo | jq  

# Verify using Docker Desktop
Go to Docker Desktop -> Containers -> nonemtpydir-bind-demo -> TABS
1. Bind Mounts
2. Files: /usr/share/nginx/html
3. Exec: df -h
```

## Step-05: Clean-Up
```t
# Delete Docker Containers
docker rm -f $(docker ps -aq)

# Delete Docker Images
docker rmi $(docker images -q)
```