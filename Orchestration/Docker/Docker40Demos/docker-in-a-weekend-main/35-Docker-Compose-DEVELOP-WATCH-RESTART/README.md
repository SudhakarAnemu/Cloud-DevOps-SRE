---
title: "Master the Docker Compose Develop Watch Feature for Efficient Development"
description: "Learn how to use Docker Compose's Develop Watch feature to enhance your development workflow with live code syncing and automatic container restarts."
---

# Master the Docker Compose Develop Watch Feature for Efficient Development

---

## Step-01: Introduction

In this guide, you will learn how to use the **Docker Compose Develop Watch** feature to enhance your development workflow. This feature allows you to:

- **Sync changes** to your code in real-time without rebuilding images.
- **Automatically restart** containers when configuration files change.
- Use the `--watch` option to enable the Develop Watch feature.
---

## Step-02: Review Dockerfile

**File Location:** `sync-and-restart-demo/web/Dockerfile`

```dockerfile
# Use the official NGINX base image
FROM nginx:latest

# Copy custom NGINX configuration file to replace the default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy static website files to the container's HTML directory
COPY ./html /usr/share/nginx/html

# Expose port 8080 for external access
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
```

---

## Step-03: Review Other Files

### HTML Files

- `sync-and-restart-demo/web/html/index.html`
- `sync-and-restart-demo/web/html/custom_404.html`

### NGINX Configuration

**File Location:** `sync-and-restart-demo/web/nginx.conf`

```conf
events { }

http {
  server {
    listen 8080;

    # Serve files from the root html directory for '/'
    location / {
      root /usr/share/nginx/html;  # Serve static files from this directory
      index index.html;  # Serve index.html by default if it exists
    }

    # Custom 404 page - ENABLE below 5 lines to test "sync+restart" option in Docker Compose
    # error_page 404 /custom_404.html;
    # location = /custom_404.html {
    #   root /usr/share/nginx/html;  # Location of the custom 404 page
    #   internal;
    # }    

  }
}
```

---

## Step-04: Review `docker-compose.yaml`

**File Location:** `sync-and-restart-demo/docker-compose.yaml`

```yaml
services:
  web:
    container_name: mywebserver1
    build:
      context: ./web  # The path to the Dockerfile
      dockerfile: Dockerfile  # The Dockerfile to use for building the image 
    develop:
      watch: 
        # Sync changes to static content
        - path: ./web/html
          action: sync
          target: /usr/share/nginx/html 
        # Sync changes to nginx.conf file
        - path: ./web/nginx.conf
          action: sync+restart
          target: /etc/nginx/nginx.conf     
    ports:
      - "8080:8080" 
```

---

## Step-05: Start the Stack and Verify

Use the `--watch` option to enable the Develop Watch feature.

```bash
# Change Directory
cd sync-and-restart-demo

# Pull Docker Images and Start Containers with --watch option
docker compose up --watch 

# List Docker Containers
docker compose ps

# Access Application
http://localhost:8080

# Observation:
# V1 version of the application will be displayed.
```

---

## Step-06: Test Sync Option: Update `index.html` to Version 2

**File Location:** `sync-and-restart-demo/web/html/index.html`

Update the content:

```html
<p>Application Version: V2</p>
```

**Observation:**

- Changes in static content will be synced to the container automatically.
- You should see the V2 version of the application without restarting the container.

```bash
# Access Application
http://localhost:8080

# Observation:
# V2 version of the application will be displayed.
```

---

## Step-07: Test Default NGINX 404 Page

Before testing the `sync+restart` option, check the default 404 page.

```bash
# Access a non-existent page to test the 404 page
http://localhost:8080/abc

# Observation:
# The default 404 page of NGINX will be displayed.
```

---

## Step-08: Test Sync + Restart Option: Update `nginx.conf`

### Step-08-01: Enable Custom 404 Page in `nginx.conf`

Uncomment the following lines in `nginx.conf`:

```conf
    # Custom 404 page - ENABLE below 5 lines to test "sync+restart" option in Docker Compose
    error_page 404 /custom_404.html;
    location = /custom_404.html {
      root /usr/share/nginx/html;  # Location of the custom 404 page
      internal;
    }    
```

### Step-08-02: Verify Automatic Container Restart

```bash
# List Containers
docker ps

# Access a non-existent page to test the custom 404 page
http://localhost:8080/abc

# Observation:
# - The custom 404 page of NGINX will be displayed.
# - The 'sync+restart' action defined in the Docker Compose file synced the updated 'nginx.conf' file to the container and automatically restarted it to apply the changes.
```

---

## Step-09: Clean Up

```bash
# Stop and Remove Containers
docker compose down

# Delete Docker Images (Optional)
docker rmi $(docker images -q)
```

---

## Conclusion

In this tutorial, you learned how to leverage the **Docker Compose Develop Watch** feature to improve your development workflow. By configuring the `watch` option in your `docker-compose.yaml` file, you can:

- **Automatically sync** changes to your application code or static files into running containers.
- **Restart containers** automatically when configuration files change, ensuring that updates are applied without manual intervention.

This feature significantly speeds up development cycles by eliminating the need to rebuild images or manually restart containers for every change.

---

## Additional Notes

- **Sync vs. Sync + Restart**:
  - **Sync**: Updates files inside the container without restarting it. Ideal for static content or code that doesn't require a restart.
  - **Sync + Restart**: Updates files and restarts the container. Use this when changes require a service restart to take effect (e.g., configuration files).

- **Efficient Development**:
  - The Develop Watch feature is especially useful for rapid development and testing, allowing developers to see changes in real-time.

- **Limitations**:
  - This feature is intended for development environments and should be used cautiously in production settings.

---

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Compose Develop Section](https://docs.docker.com/compose/reference/develop/)
- [NGINX Official Documentation](https://nginx.org/en/docs/)
- [Live Reloading with Docker](https://docs.docker.com/compose/develop/)

---

**Happy Dockerizing!**
