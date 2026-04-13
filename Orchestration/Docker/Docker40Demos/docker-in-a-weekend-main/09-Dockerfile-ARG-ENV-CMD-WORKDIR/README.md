---
title: "Learn Dockerfile ARG vs ENV, CMD, RUN, WORKDIR Instructions Practically"
description: "Understand the differences between ARG and ENV instructions in Dockerfiles, and learn how to use CMD, RUN, and WORKDIR instructions with practical examples."
---

# Learn Dockerfile ARG vs ENV, CMD, RUN, WORKDIR Instructions Practically

---

## Introduction

In this guide, you will:

1. Learn the differences between `ARG` and `ENV` instructions in Dockerfiles.
2. Learn how to use `CMD`, `RUN`, and `WORKDIR` instructions.
3. Create a simple Python Flask application.
4. Build Docker images using `ARG` and `ENV` instructions to manage build-time and runtime variables.

---

## Why Use ARG and ENV Together?

- The `ARG` instruction allows you to pass variables at build time without modifying the Dockerfile, making it more dynamic and reusable.
- By combining `ARG` and `ENV`, you can pass values configured during the build process into the runtime environment of the container.
- **Separation of Concerns:**
  - `ARG` is used for **build-time** customization.
  - `ENV` is used for **runtime** customization.
- This separation makes the Dockerfile flexible at both stages without overlap or confusion.

---

## Step 1: Create Python Application

**Create `requirements.txt`:**

```plaintext
Flask==3.0.3
```

**Create a `templates` folder** with two HTML files: `dev.html` and `qa.html`.

**`templates/dev.html`:**

```html
<!DOCTYPE html>
<html>
  <body style="background-color: rgb(152, 202, 134);">
    <h1>Welcome to StackSimplify - ARG (Build-time) and ENV (Runtime) Variables</h1>
    <h2>Environment: DEV</h2>
    <p>Learn technology through practical, real-world demos.</p>
    <p>Application Version: V1</p>
  </body>
</html>
```

**`templates/qa.html`:**

```html
<!DOCTYPE html>
<html>
  <body style="background-color: rgb(134, 196, 202);">
    <h1>Welcome to StackSimplify - ARG (Build-time) and ENV (Runtime) Variables</h1>
    <h2>Environment: QA</h2>
    <p>Learn technology through practical, real-world demos.</p>
    <p>Application Version: V1</p>
  </body>
</html>
```

**Create `app.py`:**

```python
from flask import Flask, render_template
import os

app = Flask(__name__)

# Get the environment variable APP_ENVIRONMENT (default to 'dev')
environment = os.getenv('APP_ENVIRONMENT', 'dev')

@app.route('/')
def home():
    # Serve different templates based on environment
    if environment == 'dev':
        return render_template('dev.html')
    elif environment == 'qa':
        return render_template('qa.html')
    else:
        return "<h1>Unknown Environment</h1>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

---

## Step 2: Create Dockerfile with ARG and ENV Instructions

- **Directory:** `Dockerfiles`

Create a `Dockerfile` with the following content:

```dockerfile
# Use python:3.12-alpine as the base image
FROM python:3.12-alpine

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: ARG vs ENV in Docker"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the difference between ARG (build-time) and ENV (runtime) instructions"
LABEL org.opencontainers.image.version="1.0"

# Define build-time argument for environment (defaults to "dev")
ARG ENVIRONMENT=dev

# Set the ENV variable using the ARG value
ENV APP_ENVIRONMENT=${ENVIRONMENT}

# Set the working directory inside the container
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt requirements.txt

# Install packages from requirements.txt
RUN pip install -r requirements.txt


# Copy the application code
COPY app.py .

# Copy the templates directory
COPY templates/ ./templates/

# Print the environment for demo purposes
RUN echo "Building for environment: ${APP_ENVIRONMENT}"

# Expose port 80
EXPOSE 80

# Start the Flask app
CMD ["python", "app.py"]
```

---

## Step 3: Build Docker Images and Run Them

### Build Docker Image with Default ARG Value

```bash
# Change to the directory containing your Dockerfile
cd Dockerfiles

# Build Docker Image using default ENVIRONMENT (dev)
docker build -t demo9-arg-vs-env:v1 .

# Run Docker Container
docker run --name my-arg-env-demo1-dev -p 8080:80 -d demo9-arg-vs-env:v1

# List Docker Containers
docker ps

# Print environment variables from Container
docker exec -it my-arg-env-demo1-dev env | grep APP_ENVIRONMENT

# Expected Output:
# APP_ENVIRONMENT=dev

# Access the application in your browser
http://localhost:8080
```

**Expected Output:**

- The **Dev** HTML page should be displayed, indicating that the `APP_ENVIRONMENT` is set to `dev`.

### Run Docker Container and Override ENV Variable

```bash
# Run Docker Container and override APP_ENVIRONMENT to 'qa'
docker run --name my-arg-env-demo2-qa -p 8081:80 -e APP_ENVIRONMENT=qa -d demo9-arg-vs-env:v1

# List Docker Containers
docker ps

# Print environment variables from Container
docker exec -it my-arg-env-demo2-qa env | grep APP_ENVIRONMENT

# Expected Output:
# APP_ENVIRONMENT=qa

# Access the application in your browser
http://localhost:8081
```

**Expected Output:**

- The **QA** HTML page should be displayed, indicating that the `APP_ENVIRONMENT` is overridden to `qa` at runtime.

---

## Step 4: Verify WORKDIR and CMD Instructions

**Verify WORKDIR:**

```bash
# List files in the working directory inside the container
docker exec -it my-arg-env-demo1-dev ls /app

# Expected Output:
# app.py
# requirements.txt
# templates
```

- The files `app.py`, `requirements.txt`, and the `templates` directory should be present in the `/app` directory inside the container, confirming that the `WORKDIR` instruction is working as intended.

**Verify CMD Instruction:**

```bash
# Inspect the Docker image to verify CMD instruction
docker image inspect demo9-arg-vs-env:v1 --format='{{.Config.Cmd}}'

# Expected Output:
# [python app.py]
```

- This confirms that the `CMD` instruction is set to start the Flask application using `python app.py`.

---

## Step 5: Setting Default Environment to QA Without Changing Dockerfile

**Question:** How do you ensure the default environment is `qa` when building the Docker image without changing the Dockerfile?

**Answer:**

You can override the `ENVIRONMENT` build-time argument during the image build process using the `--build-arg` flag. This allows you to set the default `APP_ENVIRONMENT` to `qa` in the image without modifying the Dockerfile.

```bash
# Build Docker Image with ENVIRONMENT set to 'qa'
docker build --build-arg ENVIRONMENT=qa -t demo9-arg-vs-env:v1-qa .

# Run Docker Container without specifying the environment variable
docker run --name my-arg-env-demo3-qa -p 8082:80 -d demo9-arg-vs-env:v1-qa

# List Docker Containers
docker ps

# Print environment variables from Container
docker exec -it my-arg-env-demo3-qa env | grep APP_ENVIRONMENT

# Expected Output:
# APP_ENVIRONMENT=qa

# Access the application in your browser
http://localhost:8082
```

**Explanation:**

- By passing `--build-arg ENVIRONMENT=qa`, you set the build-time `ARG ENVIRONMENT` to `qa`.
- The `ENV APP_ENVIRONMENT=${ENVIRONMENT}` instruction then sets `APP_ENVIRONMENT` to `qa` in the image.
- When you run the container, `APP_ENVIRONMENT` is already set to `qa` by default, so you don't need to pass `-e APP_ENVIRONMENT=qa`.
- The application will serve the **QA** HTML page without additional runtime configurations.

**Cleanup:**

```bash
# Stop and remove the container
docker rm -f my-arg-env-demo3-qa

# Remove the Docker image
docker rmi demo9-arg-vs-env:v1-qa
```

---

## Conclusion

You have successfully:

- Learned the differences between `ARG` and `ENV` instructions in Dockerfiles.
- Created a Dockerfile that uses `ARG`, `ENV`, `CMD`, `RUN`, and `WORKDIR` instructions.
- Built Docker images with default and overridden values without modifying the Dockerfile.
- Ran Docker containers and verified the environment settings.
- Verified the functionality of the `WORKDIR` and `CMD` instructions.
- Tagged and pushed Docker images to Docker Hub.

---

## Additional Notes

- **ARG vs. ENV:**
  - **ARG** is used for build-time variables and is not available after the image is built.
  - **ENV** sets environment variables that are available during the build process and in the running container.

- **Overriding ENV Variables:**
  - You can override `ENV` variables at runtime using the `-e` flag with `docker run`.

- **CMD Instruction:**
  - The `CMD` instruction specifies the default command to run when starting a container from the image.
  - It can be overridden by specifying a different command in `docker run`.

- **WORKDIR Instruction:**
  - The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` instructions that follow it in the Dockerfile.
  - It ensures that your application files are located in a predictable location inside the container.

- **Best Practices:**
  - Use `ARG` for values you might want to change during the build without altering the Dockerfile.
  - Use `ENV` for setting default values that can be overridden at runtime if needed.
  - Keep your Docker images lean by minimizing the number of layers and removing unnecessary files.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - ARG Instruction](https://docs.docker.com/engine/reference/builder/#arg)
- [Dockerfile Reference - ENV Instruction](https://docs.docker.com/engine/reference/builder/#env)
- [Dockerfile Reference - CMD Instruction](https://docs.docker.com/engine/reference/builder/#cmd)
- [Dockerfile Reference - WORKDIR Instruction](https://docs.docker.com/engine/reference/builder/#workdir)
- [Understanding ARG and ENV in Dockerfile](https://vsupalov.com/docker-arg-vs-env/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

**Happy Dockerizing!**
