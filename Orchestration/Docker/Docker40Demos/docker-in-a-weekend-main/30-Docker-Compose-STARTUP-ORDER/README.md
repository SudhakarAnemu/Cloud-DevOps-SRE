---
title: Learn to implement startup order using depends_on in Docker Compose file
description: Implement startup order using depends_on in Docker Compose file
---

## Step-01: Introduction
- Implement startup order using depends_on in Docker Compose file

## Step-02: Review docker-compose.yaml
```yaml
# For Service: web-nginx
    depends_on:
      app-ums:
        condition: service_healthy
        restart: true   

# For Service: app-ums
    depends_on:
      db-mysql:
        condition: service_healthy
        restart: true        
```


## Step-03: Start the Stack 
```t
# Change Directory
cd startuporder-demo

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
```

## Step-04: Clean-up
```t
# Stop and Remove Containers
docker compose down -v

# Delete Docker Images
docker rmi $(docker images -q)
```



