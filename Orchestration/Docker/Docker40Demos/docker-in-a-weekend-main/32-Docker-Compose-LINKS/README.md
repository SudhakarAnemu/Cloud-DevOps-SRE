---
title: Learn about Docker Compose Links 
description: Implement Docker compose links concept
---

## Step-01: Introduction
- Learn about [Docker Compose Links](https://docs.docker.com/compose/how-tos/networking/#link-containers)

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
      - frontend  
      - backend
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]   # Assuming /health is your app's health check endpoint
      interval: 30s
      timeout: 10s
      retries: 3
    links:
      - db-mysql:myumsdb
      - db-mysql:mydevdb   

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
cd links-demo

# Pull Docker Images and Start Containers
docker compose up -d 

# List Docker Containers
docker compose ps
```

## Step-04: app-ums to db-mysql: Verify Connectivity between containers using LINKS concept
- Links allow you to define extra aliases by which a service is reachable from another service. 
- By default, any service can reach any other service at that service's name (db-mysql, app-ums, web-nginx). 
- In the following example, db-mysql is reachable from app-ums at the hostnames 
  - db-mysql (Service name ) 
  - myumsdb (link created in app-ums)
  - mydevdb (link created in app-ums)
```t
# Connect to web-nginx container
docker exec -it ums-stack-app-ums-1 /bin/bash

# Debian/Ubuntu-based images: Install iputils
apt-get update
apt-get install -y iputils-ping dnsutils

# nslookup Test
nslookup db-mysql
nslookup myumsdb
nslookup mydevdb
Observation:
1. db-mysql, myumsdb, mydevdb all resolve to same IP

# dig Test
dig db-mysql
dig myumsdb
dig mydevdb
Observation:
1. db-mysql, myumsdb, mydevdb all resolve to same IP

# Ping Test
ping db-mysql
ping myumsdb
ping mydevdb

# Telnet Test
telnet db-mysql 3306
telnet myumsdb 3306
telnet mydevdb 3306
```


## Step-05: Clean-up
```t
# Stop and Remove Containers
docker compose down -v

# Delete Docker Images
docker rmi $(docker images -q)
```



