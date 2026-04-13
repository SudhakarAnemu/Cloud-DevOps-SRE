---
title: "Mastering Docker Build Cloud: Accelerate Your Docker Builds with Cloud and Local Builders"
description: "Learn how to use Docker Build Cloud for Docker builds, compare performance between local and cloud builders, manage build caches, and set default builders."
---

# Mastering Docker Build Cloud: Accelerate Your Docker Builds with Cloud and Local Builders

---

## Introduction

In this guide, you will:

1. Create a **Cloud Builder** in Docker Build Cloud.
2. Create a **Local Builder** in Docker Desktop.
3. Build Docker images using both builders and compare performance differences.
4. Learn to clear build caches using the command `docker buildx prune`.
5. Learn to set up the default builder for Docker builds using the command `docker buildx use BUILDER-NAME --global`.

### Important Note about Docker Build Cloud
- Docker Build Cloud will only be available with the new Docker Pro, Team, and Business plans. 
- Docker Build Cloud is not available for Personal use 
---

## Step 1: Create Cloud Builder

- Go to the [Docker Build Cloud](https://app.docker.com/build).
- Click on **Create Cloud Builder**.
- **Cloud Builder name:** `mycloud-builder1`.
- Click on **Create**.

---

## Step 2: Add Cloud Builder Endpoint

### Using Docker CLI

1. **Docker Login**

   ```bash
   docker login
   ```

2. **Add the cloud builder endpoint**

   Replace `<YOUR-DOCKER-USERNAME>` with your Docker Hub username.

   ```bash
   docker buildx create --driver cloud <YOUR-DOCKER-USERNAME>/<BUILDER_NAME>
   ```

   **Example with 'stacksimplify':**

   ```bash
   docker buildx create --driver cloud stacksimplify/mycloud-builder1
   ```

### Using Docker Desktop

1. Sign in to your Docker account using the **Sign in** button in Docker Desktop.
2. Open the Docker Desktop **Settings** and navigate to the **Builders** tab.
3. Under **Available builders**, select **Connect to builder** and follow the prompts.

---

## Step 3: Create Local Builder

1. **Create a new Buildx builder and set it as the current builder**

   ```bash
   # Create a new Buildx builder and set it as the current builder
   docker buildx create --name mylocal-builder1 --use
   ```

2. **Inspect and initialize the Buildx builder**

   ```bash
   # Inspect and initialize the Buildx builder
   docker buildx inspect --bootstrap
   ```

3. **List builder instances**

   ```bash
   # List Builder Instances
   docker buildx ls
   ```

---

## Step 4: Run Build Using Local Builder

**Note:**

- We are using `--push` to push the Docker image directly to Docker Hub.
- We are **not** using `--load` in this context since we are not loading the image into local Docker Desktop.

```bash
# Change directory to your project
cd multiplatform-build-cloud-demo

# List Docker Images (optional)
docker images

# Run Docker Build with Local Builder
docker buildx build --builder mylocal-builder1 --platform linux/amd64,linux/arm64 -t <YOUR-DOCKER-USERNAME>/local-builder-demo1 --push .

# Example with 'stacksimplify':
docker buildx build --builder mylocal-builder1 --platform linux/amd64,linux/arm64 -t stacksimplify/local-builder-demo1 --push .
```

**Observations:**

1. The build process may take approximately **162 seconds** to complete.
2. After the build, list Docker images:

   ```bash
   docker images
   ```

3. **Note:** The Docker image will **not** be present in your local Docker Desktop since it was pushed directly to Docker Hub.

**Verify Docker Images in Docker Hub:**

- Log in to your Docker Hub account.
- Navigate to the **Repositories** section.
- You should see the newly pushed image `local-builder-demo1`.

---

## Step 5: Run Build Using Cloud Builder

**Note:**

- We are using `--push` to push the Docker image directly to Docker Hub.
- We are **not** using `--load` in this context since we are not loading the image into local Docker Desktop.

```bash
# Change directory to your project (if not already there)
cd multiplatform-build-cloud-demo

# List Docker Images (optional)
docker images

# Run Docker Build with Cloud Builder
docker buildx build --builder cloud-stacksimplify-mycloud-builder1 --platform linux/amd64,linux/arm64 -t <YOUR-DOCKER-USERNAME>/cloud-builder-demo101 --push .

# Example with 'stacksimplify':
docker buildx build --builder cloud-stacksimplify-mycloud-builder1 --platform linux/amd64,linux/arm64 -t stacksimplify/cloud-builder-demo101 --push .
```

**Observations:**

1. The build process may take approximately **18 seconds** to complete.
2. After the build, list Docker images:

   ```bash
   docker images
   ```

3. **Note:** The Docker image will **not** be present in your local Docker Desktop since it was pushed directly to Docker Hub.

**Verify Docker Images in Docker Hub:**

- Log in to your Docker Hub account.
- Navigate to the **Repositories** section.
- You should see the newly pushed image `cloud-builder-demo101`.

---

## Step 6: Set Cloud Builder as Default Builder

1. **Set the cloud builder as the default builder globally**

   ```bash
   docker buildx use cloud-stacksimplify-mycloud-builder1 --global
   ```

2. **Verify the default builder**

   - Open Docker Desktop.
   - Navigate to **Settings** → **Builders**.
   - **Observation:** You should see **"cloud-stacksimplify-mycloud-builder1"** set as the default builder.

3. **Create builds without specifying `--builder`**

   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 -t stacksimplify/cloud-builder-demo102 --push .
   ```

**Observations:**

1. The build process may take approximately **12 seconds** to complete.
2. **Note:** Even without specifying `--builder`, the build uses the cloud builder as it is set as the default.

---

## Step 7: Clean-up

1. **List Docker Buildx builders**

   ```bash
   docker buildx ls
   ```

2. **Stop the local builder**

   ```bash
   docker buildx stop mylocal-builder1
   ```

3. **Remove the local builder**

   ```bash
   docker buildx rm mylocal-builder1
   ```

4. **Verify builders list**

   ```bash
   docker buildx ls
   ```

5. **Remove Docker images (optional)**

   ```bash
   docker rmi $(docker images -q)
   ```

   > **Warning:** This command will remove **ALL** Docker images from your local Docker Desktop.

---

## Step 8: Remove Build Caches

1. **Remove build cache for specific builders**

   ```bash
   docker buildx prune --builder <BUILDER-NAME> -f
   ```

   **Examples:**

   ```bash
   docker buildx prune --builder mylocal-builder1 -f
   docker buildx prune --builder cloud-stacksimplify-mycloud-builder1 -f
   ```

---

## Conclusion

You have successfully learned how to use Docker Build Cloud, compared performance differences between local and cloud builders, managed build caches, and set default builders. Feel free to experiment further and integrate these practices into your Docker workflow.

**Happy Dockerizing!**

---

## Additional Resources

- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
- [Docker Build Cloud Official Guide](https://docs.docker.com/docker-cloud/builds/)

---

## Additional Notes

- Ensure you replace `<YOUR-DOCKER-USERNAME>` with your actual Docker Hub username throughout the guide.
- Be cautious when running `docker rmi $(docker images -q)` as it will remove **ALL** Docker images from your local environment.
- The performance times mentioned in the observations are approximate and may vary based on your network speed and system resources.
