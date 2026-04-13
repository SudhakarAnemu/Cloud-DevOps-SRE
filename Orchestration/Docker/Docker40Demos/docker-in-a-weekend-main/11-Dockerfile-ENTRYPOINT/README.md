---
title: "Learn Dockerfile ENTRYPOINT Instructions Practically"
description: "Understand how to use the ENTRYPOINT instruction in Dockerfiles, and how to override or append arguments during the 'docker run' command."
---

# Learn Dockerfile ENTRYPOINT Instructions Practically

---

## Introduction

In this guide, you will:

- Create a Dockerfile with the `ENTRYPOINT` instruction.
- Build a Docker image and verify its functionality.
- Understand how to:
  - Use `ENTRYPOINT` as defined in the Dockerfile.
  - Append additional arguments to the `ENTRYPOINT` instruction.
  - Override the `ENTRYPOINT` instruction using the `--entrypoint` flag.

---

## Step 1: Create Dockerfile

- **Directory:** `DockerFiles`

Create a `Dockerfile` with the following content:

```dockerfile
# Use ubuntu as base Docker Image
FROM ubuntu

# OCI Labels
LABEL org.opencontainers.image.authors="Kalyan Reddy Daida"
LABEL org.opencontainers.image.title="Demo: ENTRYPOINT Instruction in Docker"
LABEL org.opencontainers.image.description="A Dockerfile demo illustrating the use of the ENTRYPOINT instruction"
LABEL org.opencontainers.image.version="1.0"

# Always run the echo command as the entrypoint
ENTRYPOINT ["echo", "Kalyan"]
```

---

## Step 2: Build Docker Image and Run It

### Build the Docker Image

```bash
# Change to the directory containing your Dockerfile
cd DockerFiles

# Build the Docker Image
docker build -t demo11-dockerfile-entrypoint:v1 .
```

### Demo 1: Use ENTRYPOINT As-Is

```bash
# Run Docker Container and Verify
docker run --name my-entrypoint-demo1 demo11-dockerfile-entrypoint:v1

# Expected Output:
# Kalyan
```

**Observation:**

- The container runs and outputs `Kalyan`, which is the argument provided in the `ENTRYPOINT` instruction during the Docker image build.

### Demo 2: Append Arguments to ENTRYPOINT

```bash
# Run Docker Container and append an additional argument
docker run --name my-entrypoint-demo2 demo11-dockerfile-entrypoint:v1 Reddy

# Expected Output:
# Kalyan Reddy
```

**Observation:**

- The additional argument `Reddy` is appended to the `ENTRYPOINT` instruction.
- The container outputs `Kalyan Reddy`.

### Demo 3: Override ENTRYPOINT Instruction

```bash
# Run Docker Container and override the ENTRYPOINT instruction
docker run --name my-entrypoint-demo3 --entrypoint /bin/sh demo11-dockerfile-entrypoint:v1 -c 'echo "Overridden ENTRYPOINT instruction by Kalyan Reddy Daida!"'

# Expected Output:
# Overridden ENTRYPOINT instruction by Kalyan Reddy Daida!
```

**Observation:**

- The `--entrypoint` flag overrides the `ENTRYPOINT` instruction specified in the Dockerfile.
- The container runs `/bin/sh` with the `-c` option, executing the `echo` command.
- The container outputs `Overridden ENTRYPOINT instruction by Kalyan Reddy Daida!`

---

## Step 3: Stop and Remove Containers and Images

```bash
# Stop and Remove the Containers
docker rm -f my-entrypoint-demo1
docker rm -f my-entrypoint-demo2
docker rm -f my-entrypoint-demo3

# Remove the Docker Images
docker rmi demo11-dockerfile-entrypoint:v1

# List Docker Images to Confirm Removal
docker images
```

---

## Conclusion

You have successfully:

- Created a Dockerfile using the `ENTRYPOINT` instruction.
- Built a Docker image and ran it, observing the default `ENTRYPOINT` execution.
- Appended additional arguments to the `ENTRYPOINT` instruction during `docker run`.
- Overridden the `ENTRYPOINT` instruction using the `--entrypoint` flag.
- Tagged and pushed the Docker image to Docker Hub.

---

## Additional Notes

- **ENTRYPOINT Instruction:**

  - The `ENTRYPOINT` instruction allows you to configure a container to run as an executable.
  - It is useful for setting up a container that runs a specific command or application.

- **Appending Arguments:**

  - When you provide additional arguments during `docker run`, they are appended to the `ENTRYPOINT` instruction.

- **Overriding ENTRYPOINT:**

  - Use the `--entrypoint` flag during `docker run` to override the `ENTRYPOINT` instruction specified in the Dockerfile.

- **Best Practices:**

  - Use `ENTRYPOINT` when you want to define a container with a specific executable.
  - Use `CMD` to provide default arguments to the `ENTRYPOINT`.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Reference - ENTRYPOINT Instruction](https://docs.docker.com/engine/reference/builder/#entrypoint)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding ENTRYPOINT and CMD in Docker](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact)

---

**Happy Dockerizing!**
