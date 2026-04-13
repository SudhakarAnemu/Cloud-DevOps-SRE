---
title: "Deploy MySQL Database Using Docker Compose with Named Volumes"
description: "Step-by-step guide to deploying a MySQL database using Docker Compose with named volumes for persistent storage and container management."
---

# Deploy MySQL Database Using Docker Compose with Named Volumes

---

## Step-01: Introduction

This demo shows how to deploy a **MySQL** database using Docker Compose with named volumes for persistent storage. The setup consists of:

- **MySQL Database**: Manages user data storage.
- **Docker Named Volume**: Ensures persistent storage of the MySQL database data even after container shutdowns or deletions.

---

## Step-02: Prerequisites

Ensure you have the following installed on your machine before running this demo:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Step-03: Project Structure

```bash
mysqldb-named-volume/
├── docker-compose.yaml   # Docker Compose configuration file
```

---

## Step-04: Services

1. **MySQL Service**:
   - Uses the official `mysql:8.0` image from Docker Hub.
   - Configures database credentials and schema via environment variables.
   - The MySQL container is exposed on port `3306` of the host machine.
   - Data is persisted in a named Docker volume (`mydb`), ensuring the database remains intact even after the container is stopped or removed.

### docker-compose.yaml

```yaml
name: ums-stack
services:
  mysql:
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

volumes:
  mydb:
    name: ums-mysqldb-data-v1  # Explicitly name the volume
    driver: local  # Optional, as local is the default driver
    labels:
      project: "ums-stack"           # Label to indicate the project name
      component: "mysql-database"    # Label to specify that this volume is for the MySQL database
      purpose: "persistent-storage"  # Label to indicate the purpose of this volume
```

### Key Configuration

- **`MYSQL_ROOT_PASSWORD`**: The root password for the MySQL server.
- **`MYSQL_DATABASE`**: The name of the database to be created on startup (`webappdb`).
- **Ports**: The MySQL service is accessible on `localhost:3306`.
- **Volumes**: A Docker volume named `mydb` ensures persistent data storage at `/var/lib/mysql` inside the MySQL container.


### Volumes Explanation:

- **`mydb`**: This defines a named volume for persistent storage that ensures data is not lost when containers are stopped or removed.
  
  - **`name: ums-mysqldb-data-v1`**: This explicitly names the volume as `ums-mysqldb-data-v1`, making it easier to manage and identify in Docker commands.
  
  - **`driver: local`**: Specifies the volume driver as `local`, which is the default Docker volume driver. This can be omitted but is explicitly mentioned here for clarity.
  
  - **`labels`**: Adds metadata to the volume using labels:
    - **`project: "ums-stack"`**: Associates the volume with the project name (`ums-stack`).
    - **`component: "mysql-database"`**: Specifies that this volume is associated with the MySQL database component.
    - **`purpose: "persistent-storage"`**: Clearly indicates the purpose of the volume, which is to provide persistent storage for the database, ensuring that data remains intact across container restarts or removals.

By configuring the volume this way, the data in the MySQL container is safely stored outside of the container's lifecycle. Even if the container is removed or restarted, the data stored in `/var/lib/mysql` (inside the container) will persist because it is mapped to the named volume `ums-mysqldb-data-v1`.


---

## Step-05: How to Start the Containers

Run the following command to start the MySQL container and its associated volume:

```bash
# Start MySQL container in detached mode
docker compose up -d
```

- The `-d` flag runs the services in detached mode (in the background).

---

## Step-06: Verify Services

To verify that the MySQL container is running:

```bash
# List running Docker containers
docker compose ps
```

To inspect logs of the MySQL container:

```bash
# View MySQL container logs
docker compose logs mysql
```

---

## Step-07: Connect to MySQL Container

Connect to the MySQL container and interact with the database:

```bash
# Connect to MySQL container
docker exec -it ums-mysqldb mysql -u root -pdbpassword11
```

- Once inside the MySQL shell, you can execute SQL queries to interact with the `webappdb` database.

---

## Step-08: Inspect Docker Volume

Inspect the Docker volume for persistent data storage:

```bash
# List Docker Volumes
docker volume ls

# Inspect volume details
docker volume inspect ums-stack_mydb
```

**Observation:**
- This command provides detailed information about the Docker volume, such as mount paths and usage.

---

## Step-09: Stop and Clean Up

To stop and remove the containers, use the following commands:

```bash
# Stop and remove the containers
docker compose down
```

To remove the MySQL volume as well (optional):

```bash
# Stop containers and remove volumes
docker compose down -v

# List Docker Volumes to confirm removal
docker volume ls
```

**Observation:**
- Running `docker compose down -v` will also remove the named volume, deleting persistent data.

---

## Conclusion

In this demo, we deployed a MySQL database using Docker Compose with named volumes for persistent storage. This setup ensures that data remains available even after containers are stopped or removed. This basic setup can easily be expanded by adding additional services, such as web applications, that interact with the MySQL database.

---

## Additional Notes

- **Persistent Storage**: Docker volumes ensure that data remains available even after containers are stopped or deleted.
- **Environment Variables**: The `MYSQL_ROOT_PASSWORD` and `MYSQL_DATABASE` variables simplify the MySQL setup by pre-configuring the database on startup.
- **Scaling**: Docker Compose enables the easy scaling of services, allowing additional components like web applications to be added seamlessly.

---

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Hub Image](https://hub.docker.com/_/mysql)
- [Docker Volume Management](https://docs.docker.com/storage/volumes/)
- [Docker Networking](https://docs.docker.com/network/)
- [Docker Troubleshooting Guide](https://docs.docker.com/config/containers/troubleshoot/)

---

**Happy Dockerizing!**

