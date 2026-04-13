---
title: "Master Docker Networks Using Docker Compose for Secure Multi-Tier Application Deployment"
description: "Learn how to securely deploy and manage a multi-tier application using Docker Compose with separate frontend and backend networks for isolation, service discovery, and load balancing."
---

# Master Docker Networks Using Docker Compose for Secure Multi-Tier Application Deployment

---

## Step-01: Introduction

This configuration showcases a typical multi-tier application setup:
- `web-nginx` (frontend) communicates with `app-ums` over the `frontend` network, acting as a reverse proxy.
- `app-ums` communicates with `db-mysql` over the `backend` network, ensuring that the database is securely isolated from the external environment.
- The separation of networks (`frontend` and `backend`) ensures that services only interact with those that they need to, providing both isolation and security.

- **frontend**: The `web-nginx` and `app-ums` services are attached to this network, meaning these two services can communicate directly with each other. This network is typically used for communication between the reverse proxy (`web-nginx`) and the web application (`app-ums`).
  
- **backend**: Both the `app-ums` and `db-mysql` services are connected to this network. The backend network facilitates communication between the application (`app-ums`) and the database (`db-mysql`). The `db-mysql` service is not accessible from `web-nginx` because it is only attached to the `backend` network, providing a level of security by isolating the database from the external-facing services.

The networks provide an internal DNS-based service discovery mechanism, allowing services to communicate using service names instead of IP addresses. For example, `app-ums` can reach the `db-mysql` container by referring to it as `db-mysql` (via the `DB_HOSTNAME` environment variable).


---

## Step-02: Review docker-compose.yaml

```yaml
name: ums-stack
services:
  web-nginx:
    image: nginx:latest 
    container_name: ums-nginx
    ports:
      - "8080:8080"
    depends_on:
      - app-ums
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    networks:
      - frontend      

  app-ums:
    image: ghcr.io/stacksimplify/usermgmt-webapp-v6:latest
    ports:
      - "8080"
    deploy:
      replicas: 2
    depends_on:
      - db-mysql
    environment:
      - DB_HOSTNAME=db-mysql
      - DB_PORT=3306
      - DB_NAME=webappdb
      - DB_USERNAME=root
      - DB_PASSWORD=dbpassword11
    networks:
      - frontend  
      - backend

  db-mysql:
    container_name: ums-mysqldb
    image: mysql:8.0-bookworm
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: dbpassword11
      MYSQL_DATABASE=webappdb
    ports:
      - "3306:3306"
    volumes:
      - mydb:/var/lib/mysql
    networks:
      - backend        

volumes:
  mydb:

networks:
  frontend:
  backend:
```

---

## Step-03: Start the Stack 

```bash
# Pull Docker Images and Start Containers
docker compose up -d 

# List Docker Containers
docker compose ps
```

---

## Step-04: Verify and Inspect Docker Networks

```bash
# List Docker Networks
docker network ls

# Inspect specific Docker Network - FRONTEND
docker network inspect ums-stack_frontend

# Inspect specific Docker Network - BACKEND
docker network inspect ums-stack_backend
```

---

## Step-05: web-nginx: Verify Connectivity Between Containers from web-nginx

### 1. **Communication Between Services: `web-nginx` and `app-ums`**:
- `web-nginx` acts as a reverse proxy, forwarding incoming requests from port 8080 of the host to `app-ums`. Since both services share the `frontend` network, `web-nginx` can resolve and access `app-ums` via its container name (`app-ums`).

### 2. **Network Usage for `web-nginx` (Nginx Reverse Proxy)**:
- Attached to the `frontend` network.
- It forwards incoming traffic from the host's port 8080 to the `app-ums` service. Since both `web-nginx` and `app-ums` are on the same `frontend` network, `web-nginx` can reach `app-ums` via its container name.
- **No access to `db-mysql`**: Since `web-nginx` is not connected to the `backend` network, it cannot directly communicate with the database service, ensuring the database remains isolated.

```bash
# Connect to web-nginx container
docker exec -it ums-nginx /bin/sh

# Alpine-based images: Install iputils
apk update
apk add iputils bind-tools

# Debian/Ubuntu-based images: Install iputils
apt-get update
apt-get install -y iputils-ping dnsutils

# Ping Services
ping web-nginx
ping app-ums
ping db-mysql

# Observation:
# 1. web-nginx and app-ums will work.
# 2. db-mysql will fail as there is NO ACCESS TO backend network.

# nslookup services
nslookup web-nginx
nslookup app-ums
nslookup db-mysql

# Observation:
# 1. web-nginx and app-ums will work.
# 2. db-mysql will fail as there is NO ACCESS TO backend network.

# dig
dig web-nginx
dig app-ums
dig db-mysql

# Observation:
# 1. web-nginx and app-ums will work.
# 2. db-mysql will fail as there is NO ACCESS TO backend network.
```

---

## Step-06: app-ums: Verify Connectivity Between Containers from app-ums

### 1. **Communication Between Services: `app-ums` and `db-mysql`**:
- `app-ums` communicates with `db-mysql` using the database hostname `db-mysql` and port `3306`. Both services are attached to the `backend` network, allowing `app-ums` to resolve `db-mysql` via DNS without exposing the database to the external network.

### 2. **Network Usage for `app-ums` (User Management WebApp)**:
- Connected to both the `frontend` and `backend` networks.
- This service can communicate with:
  - **`web-nginx`** over the `frontend` network.
  - **`db-mysql`** over the `backend` network using the environment variable `DB_HOSTNAME=db-mysql`.
- `app-ums` scales to two replicas, meaning two instances of the application will be created. All replicas share the same networks and can access `db-mysql` over the backend network.

```bash
# Connect to app-ums container (one of the replicas)
docker exec -it --user root ums-stack-app-ums-1 /bin/bash

# Debian/Ubuntu-based images: Install iputils
apt-get update
apt-get install -y iputils-ping dnsutils

# Ping Services
ping web-nginx
ping app-ums
ping db-mysql

# Observation:
# 1. web-nginx, app-ums, and db-mysql will work.
# 2. app-ums Service needs connectivity to both frontend and backend db.

# nslookup services
nslookup web-nginx
nslookup app-ums
nslookup db-mysql

# Observation:
# 1. web-nginx, app-ums, and db-mysql will work.
# 2. app-ums Service needs connectivity to both frontend and backend db.

# dig
dig web-nginx
dig app-ums
dig db-mysql

# Observation:
# 1. web-nginx, app-ums, and db-mysql will work.
# 2. app-ums Service needs connectivity to both frontend and backend db.
```

---

## Step-07: db-mysql: Verify Connectivity Between Containers from db-mysql

### 1. **Network Usage for `db-mysql` (MySQL Database)**:
- Attached only to the `backend` network.
- Isolated from external services like `web-nginx`, enhancing security by limiting access only to `app-ums`, which is also on the `backend` network.
- The database listens on port 3306, but only the `app-ums` service can access it internally via the `backend` network.

```bash
# Connect to db-mysql container
docker exec -it ums-mysqldb /bin/bash

# Debian/Ubuntu-based images: Install iputils
cat /etc/os-release
apt-get update
apt-get install -y iputils-ping dnsutils

# Oracle Image
cat /etc/os-release
microdnf install -y iputils bind-utils


# Ping Services
ping web-nginx
ping app-ums
ping db-mysql

# Observation:
# 1. app-ums and db-mysql will work.
# 2. web-nginx has NO ACCESS from db-mysql.

# nslookup services
nslookup web-nginx
nslookup app-ums
nslookup db-mysql

# Observation:
# 1. app-ums and db-mysql will work.
# 2. web-nginx has NO ACCESS from db-mysql.

# dig
dig web-nginx
dig app-ums
dig db-mysql

# Observation:
# 1. app-ums and db-mysql will work.
# 2. web-nginx has NO ACCESS from db-mysql.
```

---


## Step-08: Clean-up

```bash
# Stop and Remove Containers
docker compose down -v

# Delete Docker Images
docker rmi $(docker images -q)
```

---

## Conclusion

### 1. **Isolated and Secure Networks**
- **Isolation of Database**: `db-mysql` is attached only to the `backend` network, isolating it from the external-facing `web-nginx` service for improved security.
- **No Host Networking**: Services communicate internally via Docker networks, reducing exposure of services to the outside world.

### 2. **Service Discovery Using DNS**
- Each service in a Docker network can be accessed by its service name. Docker networks provide a built-in DNS service, making it easy to manage and scale multi-container applications.

---

**Happy Dockerizing!**