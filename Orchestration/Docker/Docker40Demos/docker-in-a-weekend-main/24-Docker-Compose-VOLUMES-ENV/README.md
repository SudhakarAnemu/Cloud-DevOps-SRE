---
title: "Deploy MySQL Database Using Docker Compose with Persistent Data Storage"
description: "Step-by-step guide to deploying a MySQL database using Docker Compose, featuring persistent data storage with Docker volumes, network setup, and container management."
---

# Deploy MySQL Database Using Docker Compose with Persistent Data Storage

---

## Step-01: Introduction

This demo showcases how to deploy a **MySQL** database using Docker Compose. The setup consists of:

- **MySQL Database**: Acts as the backend for storing user data.
- **Docker Volume**: Provides persistent storage, ensuring that the database data remains intact even if the container is stopped or removed.

In future demos, we will add the **User Management WebApp (UMS WebApp)** to this Docker Compose setup to create a full application stack.

---

## Step-02: Prerequisites

Before running this demo, ensure you have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Step-03: Project Structure

```bash
mysqldb/
├── docker-compose.yaml   # Docker Compose configuration file
```

---

## Step-04: Services

### MySQL Service:

- Uses the official `mysql:8.0` image from Docker Hub.
- Database credentials and schema are configured via environment variables.
- The MySQL container is exposed on port `3306` of the host machine.
- Data is persisted in a named Docker volume (`mydb`), ensuring that the database remains intact even after the container is stopped or removed.

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
```

### Key Configuration

- **`MYSQL_ROOT_PASSWORD`**: The root password for the MySQL server.
- **`MYSQL_DATABASE`**: The name of the database to be created on startup (`webappdb`).
- **Ports**: The MySQL service is accessible on `localhost:3306`.
- **Volumes**: A Docker volume named `mydb` is used for persistent data storage at `/var/lib/mysql` within the MySQL container.

---

## Step-05: How to Start the Containers

Run the following commands to start the MySQL container along with its associated volume:

```bash
# Change Directory
cd mysqldb

# Start MySQL container in detached mode
docker compose up -d
```

- The `-d` flag runs the services in detached mode (in the background).

---

## Step-06: Verify Services

To verify that the MySQL container is up and running:

```bash
# List running Docker containers
docker compose ps
```

To inspect logs of the running containers:

```bash
# View MySQL container logs
docker compose logs mysql
```

---

## Step-07: Connect to MySQL Container

You can connect to the MySQL container and interact with the database:

```bash
# Connect to MySQL container
docker exec -it ums-mysqldb mysql -u root -pdbpassword11
```

- Once inside the MySQL shell, you can run SQL queries to interact with the `webappdb` database.

---

## Step-08: Inspect Docker Volume

Inspect the Docker volume created for persistent data storage:

```bash
# List Docker Volumes
docker volume ls

# Inspect volume details
docker volume inspect ums-stack_mydb
```

**Observation:**

- This command provides detailed information about the volume, such as mount paths and usage.

---

## Step-09: Stop and Clean Up

When you're done, stop and remove the containers with the following commands:

```bash
# Stop and remove the containers
docker compose down
```

To remove the MySQL volume as well (optional):

```bash
# Start Containers
docker compose up -d

# List Docker Volumes
docker volume ls

# Stop containers and remove volumes
docker compose down -v

# List Docker Volumes
docker volume ls

# Observation: We should see Docker Volume is deleted as part of `docker compose down -v` command.
```

---

## Conclusion

In this demo, we deployed a MySQL database using Docker Compose. The database was configured with persistent data storage using Docker volumes, ensuring that the data remains available even when containers are stopped or removed. The next steps would include adding additional services, such as a web application, to interact with this MySQL database.

---

## Additional Notes

- **Persistent Storage**: Using Docker volumes like `mydb` ensures that data remains available even after containers are stopped or deleted.
- **Environment Variables**: The `MYSQL_ROOT_PASSWORD` and `MYSQL_DATABASE` variables simplify the setup of MySQL by pre-configuring the database.
- **Docker Network**: The Docker network created in future demos will allow multiple containers to communicate seamlessly.
- **Scaling**: Docker Compose makes it easy to scale services, and additional components like web applications can be added by simply modifying the `docker-compose.yaml` file.

---

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Hub Image](https://hub.docker.com/_/mysql)
- [Docker Networking](https://docs.docker.com/network/)
- [Docker Volume Management](https://docs.docker.com/storage/volumes/)
- [Troubleshooting Docker Containers](https://docs.docker.com/config/containers/troubleshoot/)

---

**Happy Dockerizing!**

