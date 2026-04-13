---
title: "Learn Dockerfile USER Instruction Practically"
description: "Create a Dockerfile with the USER instruction to run applications as a non-root user."
---

# Learn Dockerfile USER Instruction Practically

---

## Introduction

In this guide, you will:

- Create a Python Flask application that displays the current user and group.
- Create a Dockerfile that implements the `USER` instruction to run the application as a non-root user.
- Build the Docker image and verify that the application runs under the specified non-root user.

---

## Step 1: Create Sample Python Application and Dockerfile

### Create a Sample Python App

**File Name:** `app.py`

```python
from flask import Flask
import os
import pwd
import grp

app = Flask(__name__)

@app.route('/')
def hello_world():
    # Get the current user's ID and name
    user_id = os.getuid()
    user_name = pwd.getpwuid(user_id).pw_name

    # Get the current group's ID and name
    group_id = os.getgid()
    group_name = grp.getgrgid(group_id).gr_name

    # Return a response displaying both the user and the group
    return f'Hello from user: {user_name} (UID: {user_id}) and group: {group_name} (GID: {group_id})!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

This Flask application will display the current user and group when accessed.

### Create Dockerfile with USER Instruction

**Dockerfile**

```dockerfile
# Use the official Python image as the base image
# This image comes with Python pre-installed
FROM python

# Set the working directory inside the container to /usr/src/app
# All subsequent commands will be run from this directory
WORKDIR /usr/src/app

# Copy the contents of the current directory on the host (where the Dockerfile is located) to /usr/src/app in the container
# using pattern matching COPY command
COPY *.py .

# Install the Flask package using pip
# The --no-cache-dir option ensures no cache is used, reducing the image size
RUN pip install --no-cache-dir flask

# Explicitly set the USER environment variable for the non-root user
ENV USER=mypythonuser
ENV GROUP=mypythongroup

# Create a new group called 'mygroup' and a non-root user 'myuser' within this group
# -m creates a home directory for the user
RUN groupadd -r ${GROUP} && useradd -m -r -g ${GROUP} ${USER}

# Set ownership of the /usr/src/app directory to the non-root user 'myuser'
# This ensures that 'myuser' has the necessary permissions to access the app directory
RUN chown -R ${USER}:${GROUP} /usr/src/app

# Switch to the non-root user 'mypythonuser' so that the application does not run as root
USER ${USER}

# Command to run the Python application
# This command starts the Flask app when the container starts
CMD ["python", "app.py"]

# Expose port 5000 to the host, so the Flask app is accessible externally
EXPOSE 5000
```

**Explanation:**

- **FROM python:alpine**: Uses the Python image.
- **WORKDIR /usr/src/app**: Sets the working directory inside the container.
- **COPY app.py .**: Copies the application code into the container.
- **RUN pip install --no-cache-dir flask**: Installs Flask without caching to keep the image size small.
- **ENV USER=mypythonuser** and **ENV GROUP=mypythongroup**: Sets environment variables for the user and group.
- **RUN addgroup -S ${GROUP} && adduser -S ${USER} -G ${GROUP}**: Creates a new system group and user.
- **RUN chown -R ${USER}:${GROUP} /usr/src/app**: Changes ownership of the application directory.
- **USER ${USER}**: Switches to the non-root user.
- **EXPOSE 5000**: Exposes port 5000 for the Flask app.
- **CMD ["python", "app.py"]**: Starts the Flask application.

---

## Step 2: Build Docker Image and Run It

```bash
# Change to the directory containing your Dockerfile
cd DockerFiles

# Build the Docker Image
docker build -t demo13-dockerfile-user:v1 .

# Run the Docker Container
docker run --name my-user-demo -p 5000:5000 -d demo13-dockerfile-user:v1

# List Docker Containers
docker ps

# Expected Output:
# CONTAINER ID   IMAGE                       COMMAND             CREATED          STATUS          PORTS                    NAMES
# abcd1234efgh   demo13-dockerfile-user:v1   "python app.py"     10 seconds ago   Up 8 seconds    0.0.0.0:5000->5000/tcp   my-user-demo

# Access the application in your browser
http://localhost:5000
```

**Expected Output in Browser:**

```
Hello from user: mypythonuser (UID: 1000) and group: mypythongroup (GID: 1000)!
```

**Verify User and Group Inside the Container:**

```bash
# Connect to the container
docker exec -it my-user-demo /bin/bash
Observation:
1. You should see you have logged into container using non-root user "mypythonuser"

# Inside the container, list files and their ownership
ls -l
Observation:
1. app.py should have the user as mypythonuser and group as mypythongroup


# Expected Output:
# total 8
# -rw-r--r--    1 mypythonuser mypythongroup     629 Oct 13 12:00 app.py

# Check environment variables
env

# Look for USER and GROUP variables
# USER=mypythonuser
# GROUP=mypythongroup

# Exit the container shell
exit
```

---
## Step-3: How do you connect to container with root user which is running its process with non-root user ?
```t
# Connect to Container with Root User
docker exec --user root -it my-user-demo /bin/bash
```
**Note:**
- You will be logged in to Docker container with `root` user

---

## Step 4: Stop and Remove Container and Images

```bash
# Stop and remove the container
docker rm -f my-user-demo

# Remove the Docker images from local machine
docker rmi stacksimplify/demo13-dockerfile-user:v1
docker rmi demo13-dockerfile-user:v1

# List Docker Images to confirm removal
docker images
```

---

## Conclusion

You have successfully:

- Created a Python Flask application that displays the current user and group.
- Created a Dockerfile using the `USER` instruction to run the application as a non-root user.
- Built the Docker image and verified that the application runs under the specified non-root user.
- Tagged and pushed the Docker image to Docker Hub.

---

## Additional Notes

- **USER Instruction:**

  - The `USER` instruction sets the user name (or UID) and optionally the user group (or GID) to use when running the image and for any `RUN`, `CMD`, and `ENTRYPOINT` instructions that follow it in the Dockerfile.

- **Security Best Practices:**

  - Running applications as a non-root user inside Docker containers enhances security.
  - It minimizes potential damage if the container is compromised.

- **Environment Variables:**

  - Environment variables set with the `ENV` instruction are available during the build process and at runtime.
  - They can be accessed within the application code or the container shell.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - USER Instruction](https://docs.docker.com/engine/reference/builder/#user)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security - Run as Non-Root User](https://docs.docker.com/develop/security/#user)

---

**Happy Dockerizing!**
