---
title: Learn to implement Docker Compose Aliases concept
description: Implement Docker Compose Aliases concept
---

## Step-01: Introduction
- Implement [Docker Compose Aliases concept](https://docs.docker.com/reference/compose-file/services/#aliases)

## Step-02: Review docker-compose.yaml
```yaml
name: ums-stack
services:
  web-nginx:
    image: nginx:latest 
    container_name: ums-nginx
    ports:
      - "8080:8080"  # NGINX listens on port 8080 of the host
    depends_on:
      app-ums:
        condition: service_healthy
        restart: true      
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf  # Custom NGINX configuration
    networks:
      - frontend      
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/nginx-health"]  # Check if NGINX is responding
      interval: 30s
      timeout: 10s
      retries: 3

  app-ums:
    image: ghcr.io/stacksimplify/usermgmt-webapp-v6:latest 
    ports:
      - "8080"  # Only expose the container's port, let Docker choose the host port
    deploy:
      replicas: 1  # Scale the service to 3 instances       
    depends_on:
      db-mysql:
        condition: service_healthy
        restart: true
    environment:
      - DB_HOSTNAME=db-mysql
      - DB_PORT=3306
      - DB_NAME=webappdb
      - DB_USERNAME=root
      - DB_PASSWORD=dbpassword11
    networks:
      frontend:
        aliases:
          - umsapp
          - dev-umsapp  
      backend: 
        aliases:
          - myspringapp
          - myapiservices
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]   # Assuming /health is your app's health check endpoint
      interval: 30s
      timeout: 10s
      retries: 3

  db-mysql:
    container_name: ums-mysqldb
    image: mysql:8.0-bookworm
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: dbpassword11
      MYSQL_DATABASE: webappdb
    ports:
      - "3306:3306"
    volumes:
      - mydb:/var/lib/mysql
    networks:
      - backend        
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-pdbpassword11"]
      interval: 30s
      timeout: 10s
      retries: 3

  netshoot:
    image: nicolaka/netshoot
    container_name: ums-netshoot
    entrypoint: ["sleep", "infinity"]  # Keep the container running for manual troubleshooting
    profiles: ["debug"]
    networks:
      - frontend
      - backend

volumes:
  mydb:

networks:
  frontend:
  backend:
```


## Step-03: Start the Stack 
```t
# Change Directory
cd aliases-demo

# Pull Docker Images and Start Containers
docker compose up -d 

# List Docker Containers
docker compose ps
```


## Step-04: web-nginx: Verify Connectivity to app-ums Aliases
```t
# Connect to web-nginx container
docker exec -it ums-nginx /bin/bash

# Debian/Ubuntu-based images: Install iputils
apt-get update
apt-get install -y iputils-ping dnsutils

# Ping Services
ping app-ums (SERVICE NAME)
ping umsapp (ALIAS defined in FRONTEND NETWORK)
ping dev-umsapp (ALIAS defined in FRONTEND NETWORK)
Observation:
1. All 3 should resolve to same IP

# nslookup services
nslookup app-ums
nslookup umsapp
nslookup dev-umsapp
Observation:
1. All 3 should resolve to same IP

# dig 
dig app-ums
dig umsapp
dig dev-umsapp
Observation:
1. All 3 should resolve to same IP


## NEGATIVE TEST
ping myspringapp  (ALIAS defined in BACKEND NETWORK)
Observation:
1. Should fail, because from web-nginx we dont have access to Backend network
```

## Step-05: db-mysql: Verify Connectivity to app-ums Aliases
```t
# Connect to web-nginx container
docker exec -it ums-mysqldb /bin/bash

# Debian/Ubuntu-based images: Install iputils
cat /etc/os-release
apt-get update
apt-get install -y iputils-ping dnsutils

# Oracle Image
cat /etc/os-release
microdnf install -y iputils bind-utils

# Ping Services
ping app-ums (SERVICE NAME)
ping myspringapp (ALIAS defined in FRONTEND NETWORK)
ping myapiservices (ALIAS defined in FRONTEND NETWORK)
Observation:
1. All 3 should resolve to same IP

# nslookup services
nslookup app-ums
nslookup myspringapp
nslookup myapiservices
Observation:
1. All 3 should resolve to same IP

# dig 
dig app-ums
dig myspringapp
dig myapiservices
Observation:
1. All 3 should resolve to same IP


## NEGATIVE TEST
ping umsapp  (ALIAS defined in FRONTEND NETWORK)
Observation:
1. Should fail, because from db-mysql we dont have access to Frontend network
```

## Step-06: Clean-up
```t
# Stop and Remove Containers
docker compose down -v

# Delete Docker Images
docker rmi $(docker images -q)
```



