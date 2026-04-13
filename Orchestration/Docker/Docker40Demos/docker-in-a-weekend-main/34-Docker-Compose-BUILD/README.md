---
title: Learn to use Docker compose "--build" flag
description: Learn to use Docker compose "--build" flag
---

## Step-01: Introduction
- Learn to use `docker compose up --build` command
## Understand --build flag
```bash
# Docker Compose with --build flag
docker compose up --build -d
```
### `--build` Flag in `docker compose up`

- **Builds Images Before Starting Containers**: The `--build` flag forces Docker Compose to build or rebuild the images defined in your `docker-compose.yml` file before starting the containers. This is particularly useful if you’ve made changes to your Dockerfile or other components that affect the image, such as code updates or changes in environment variables.

- **No Need to Manually Run `docker compose build`**: Normally, if you modify your Dockerfile or application code, you would first need to run `docker compose build` to rebuild the images and then use `docker compose up` to start the containers. Using `--build` combines these steps into one, making it convenient to automatically build and bring up the containers in a single command.

- **Use Cases**:
  - **Code Changes**: If you've updated your application code or modified files copied into the image.
  - **Dockerfile Changes**: If you've changed instructions within the Dockerfile, such as adding a new dependency or updating the base image.
  - **Environment Updates**: If you have modified build arguments (`ARG`) or environment variables that affect the image during the build process.

- **Automatic vs. Manual Building**: Without the `--build` flag, `docker compose up` will use the existing image if it has already been built. It won’t check for changes in the Dockerfile or other dependencies that are part of the image. The `--build` flag ensures that the image is rebuilt regardless of whether it was previously built.


## Step-02: Review Sample Application
- Folder: python-app
- **File: app.py**
```py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "V1: Hello, Docker Compose Build Demo"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

- **File: requirements.txt**
```txt
flask
```
- **File: Dockerfile**
```Dockerfile
# Use the official Python image from the Docker Hub
FROM python:slim

# Set the working directory
WORKDIR /app

# Copy the requirements file and install the dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Expose the app on port 5000
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
```

## Step-03: Review docker-compose.yaml
```yaml
services:
  web:
    image: my-python-app:latest  # Name of the Docker image
    container_name: my-python-container  # Name of the container
    build: 
      context: ./python-app  
      dockerfile: Dockerfile  # The Dockerfile to use for building the image 
    ports:
      - "5000:5000"
```

## Step-04: Start the Stack and Verify
```t
# Change Directory
cd build-demo

# Pull Docker Images and Start Containers
docker compose up --build -d 

# List Docker Containers
docker compose ps

# List Docker Images
docker images
Observation:
1. Verify the Docker image "CREATED" section

# Access Application
http://localhost:5000
Observation:
1. V1 version of application displayed
```

## Step-05: Change Code to V2 version
```py
# Update app.py
return "V2: Hello, Docker Compose Build Demo"
```
## Step-06: Deploy V2 version of Application

```bash
# Change Directory
cd build-demo

# Re-build Docker Images and Start Containers
docker compose up --build -d 

# List Docker Images
docker images
Observation:
1. Verify the Docker image "CREATED" section
2. New Docker image will be created

# List Docker Containers
docker compose ps
Observation:
1. Container will be recreated with new Docker Image

# Access Application
http://localhost:5000
Observation:
1. V2 version of application will be displayed
```

## Step-07: Clean-up
```t
# Stop and Remove Containers
docker compose down

# Delete Docker Images
docker rmi $(docker images -q)
```



