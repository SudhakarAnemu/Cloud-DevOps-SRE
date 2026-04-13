---
title: Learn about Docker Compose profiles concept
description: Implement Docker compose profiles concept
---

## Step-01: Introduction
- Implement Docker Compose profiles concept

## Step-02: Review docker-compose.yaml
```yaml
  netshoot:
    image: nicolaka/netshoot
    container_name: ums-netshoot
    entrypoint: ["sleep", "infinity"]  # Keep the container running for manual troubleshooting
    profiles: ["debug"]
    networks:
      - frontend
      - backend      
```


## Step-03: Start the Stack 
```t
# Pull Docker Images and Start Containers
docker compose up -d 

# List Docker Containers
docker compose ps -a
Observation:
1. All 3 containers will be created
2. First "db-mysql" will become healthy
3. Second "app-ums" will become healthy
4. Third "web-nginx" will become healthy
5. Start happens sequentially "db-mysql" -> "app-ums" -> "web-nginx"
6. Live traffic will be allowed only from nginx and nginx is up  only after "db-mysql" and "app-ums" is healthy

# Start Service with the 'debug' Profile
docker compose --profile debug up -d

# List Docker Containers
docker compose ps -a
docker ps -a
Observation:
1. Docker container "debug" will be started

# Connect to debug container
docker exec -it ums-netshoot /bin/bash

# Run the following commands in netshoot container
## ping test
ping web-nginx
ping app-ums
ping db-mysql

## telnet test
telnet web-nginx 8080
telnet app-ums 8080
telnet db-mysql 3306

## dig test
dig web-nginx
dig app-ums
dig db-mysql

## nslookup test
nslookup web-nginx
nslookup app-ums
nslookup db-mysql

## curl test
curl http://app-ums:8080/health
curl http://web-nginx:8080/health
```

## Step-04: Stop Containers
```t
# Stop and Remove containers
docker compose down -v
Observation:
1. Only regular service containers will be removed (web-nginx, app-ums, db-mysql)
2. netshoot container created as part of --profile will not be removed
3. We need to remove it manually

# List Docker containers
docker ps -a

# List Docker Networks
docker network ls

# Stop and Remove Service with the 'debug' Profile
docker compose --profile debug down
Observation:
1. netshoot container will be removed

# List Docker containers
docker ps -a
Observation:
1. No running or stopped containers.

# List Docker Networks
docker network ls
Observation:
1. No networks related to this stack
2. Everything clean-up
```