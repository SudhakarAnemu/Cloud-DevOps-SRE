---
title: Learn Docker Compose Healtchecks
description: Implement Docker Compose Healtchecks
---

## Step-01: Introduction
- Implement Health checks for all 3 services in Docker compose file

## Step-02: Review nginx.conf
```conf
events { }

http {
  # Docker's internal DNS resolver, configures the upstream block to resolve the service name to multiple IPs
  resolver 127.0.0.11 ipv6=off;  
  
  upstream app-ums {
    # Docker will resolve 'app-ums' to the containers automatically
    server app-ums:8080;  

    # Use client's IP address for session persistence (NEEDED FOR UMS WEBAPP)
    ip_hash;  # Disable to see how load balancing works by accessing API  http://localhost:8080/hello1
  }

  server {
    listen 8080;

    # Health check for NGINX (static page or simple response)
    location /nginx-health {
        return 200 "NGINX is healthy!";
        add_header Content-Type text/plain;
    } 

    # Nginx Status
    location /nginx_status {
        stub_status on;              # Enable stub_status module
        #allow 127.0.0.1;             # Allow requests from localhost
        #deny all;                    # Deny all other IPs
    }

    # Proxypass to our User Management Web Application (UMS App)
    location / {
      proxy_pass http://app-ums;
    }
  }
}
```
## Step-03: Review docker-compose.yaml
```yaml
name: ums-stack
services:
  web-nginx:
    image: nginx:latest 
    container_name: ums-nginx
    ports:
      - "8080:8080"  # NGINX listens on port 8080 of the host
    depends_on:
      - app-ums
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
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]   # Assuming /health is your app's health check endpoint
      interval: 30s
      timeout: 10s
      retries: 3

  db-mysql:
    container_name: ums-mysqldb
    image: mysql:8.0
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

volumes:
  mydb:

networks:
  frontend:
  backend:
```


## Step-04: Start the Stack 
```t
# Change Directory
cd  healthcheck-demo

# Pull Docker Images and Start Containers
docker compose up -d 

# List Docker Containers
docker compose ps
Observation:
1. You should see all the containers showing healthy

# Sample Output
kalyan-mini2:healthchecks-demo kalyan$ docker compose ps
NAME                  IMAGE                                             COMMAND                  SERVICE     CREATED          STATUS                    PORTS
ums-mysqldb           mysql:8.0                                         "docker-entrypoint.s…"   db-mysql    39 seconds ago   Up 38 seconds (healthy)   0.0.0.0:3306->3306/tcp, 33060/tcp
ums-nginx             nginx:latest                                      "/docker-entrypoint.…"   web-nginx   39 seconds ago   Up 38 seconds (healthy)   80/tcp, 0.0.0.0:8080->8080/tcp
ums-stack-app-ums-1   ghcr.io/stacksimplify/usermgmt-webapp-v6:latest   "catalina.sh run"        app-ums     39 seconds ago   Up 38 seconds (healthy)   0.0.0.0:63848->8080/tcp
kalyan-mini2:healthchecks-demo kalyan$ 
```


## Step-05: Clean-up
```t
# Stop and Remove Containers
docker compose down -v

# Delete Docker Images
docker rmi $(docker images -q)
```



