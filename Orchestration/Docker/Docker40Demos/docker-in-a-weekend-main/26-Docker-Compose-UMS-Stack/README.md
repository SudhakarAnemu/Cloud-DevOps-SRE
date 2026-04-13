---
title: "Deploy User Management WebApp and MySQL DB Using Docker Compose"
description: "Step-by-step guide to deploying a UMS Stack with MySQL using Docker Compose for persistent data storage and container management."
---

# Deploy UMS Stack (User Management Web Application with MySQL DB) Using Docker Compose

---

## Step-01: Introduction

In this demo, we will show how to deploy a **User Management Web Application (UMS)** along with a **MySQL database** using **Docker Compose**. The UMS Stack comprises:

1. **MySQL Database**: Backend for storing user data.
2. **UMS WebApp**: A web application that connects to the MySQL database to manage users, including login, create, and list operations.

---

## Step-02: Prerequisites

Ensure that you have the following tools installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Step-03: Project Structure

```bash
ums-stack/
├── docker-compose.yaml   # Docker Compose configuration file
```

---

## Step-04: Services

### MySQL Service:

- Uses the official `mysql:8.0` image from Docker Hub.
- Configures the database with environment variables.
- Exposes the MySQL service on port `3306`.
- Stores MySQL data in a Docker named volume (`mydb`) to ensure data persists.

### UMS WebApp Service:

- Uses the `ghcr.io/stacksimplify/usermgmt-webapp-v6:latest` image for the User Management WebApp.
- Connects to the MySQL database service for backend operations.
- Exposes the UMS WebApp on port `8080` of the host machine.

### docker-compose.yaml

```yaml
name: ums-stack
services:
  myumsapp:
    container_name: ums-app
    image: ghcr.io/stacksimplify/usermgmt-webapp-v6:latest
    ports:
      - "8080:8080"        
    depends_on:
      - mysql
    environment:
      - DB_HOSTNAME=mysql
      - DB_PORT=3306
      - DB_NAME=webappdb
      - DB_USERNAME=root
      - DB_PASSWORD=dbpassword11
  mysql:
    container_name: ums-mysqldb
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: dbpassword11
      MYSQL_DATABASE=webappdb
    ports:
      - "3306:3306"
    volumes:
      - mydb:/var/lib/mysql
volumes:
  mydb:
```

### Key Configuration

#### UMS Web Application Service: `myumsapp`

- **`DB_HOSTNAME`**: The hostname of the MySQL container, set to `mysql`.
- **`DB_PORT`**: MySQL port, set to `3306`.
- **`DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`**: Database connection details for the UMS WebApp.

#### MySQL Service: `mysql`

- **`MYSQL_ROOT_PASSWORD`**: Root password for MySQL.
- **`MYSQL_DATABASE`**: Pre-configures the `webappdb` database for the UMS WebApp.

### Volumes Explanation

- **`mydb`**: A named Docker volume for persistent storage, ensuring that the MySQL database data persists even after container restarts or removal.

---

## Step-05: How to Start the UMS Stack

Follow the steps below to start the UMS Stack:

```bash
# Change to the project directory
cd ums-stack

# Start the UMS Stack in detached mode
docker compose up -d
```

- The `-d` flag runs the services in detached mode, allowing them to run in the background.

---

## Step-06: Verify Services

To ensure that both the MySQL and UMS WebApp services are running:

```bash
# List running Docker containers
docker compose ps
```

To view logs for both services:

```bash
# View logs with docker compose
docker compose logs -f <SERVICE-NAME>
docker compose logs -f mysql
docker compose logs -f myumsapp

# View logs using container names
docker logs -f <CONTAINER-NAME-OR-ID>
docker logs -f ums-mysqldb
docker logs -f ums-app
```

---

## Step-07: Accessing the UMS WebApp

1. Open your browser and navigate to `http://localhost:8080`.
2. Use the default credentials to log in:
   - **Username**: `admin101`
   - **Password**: `password101`
3. Once logged in, you can:
   - View a list of users.
   - Create new users.
   - Test the login functionality with the newly created users.

---

## Step-08: Connect to MySQL Container

To inspect or interact with the MySQL database, connect to the MySQL container:

```bash
# Connect to MySQL container
docker exec -it ums-mysqldb mysql -u root -pdbpassword11
```

Once inside the MySQL shell, you can run SQL queries to view the `webappdb` database:

```bash
mysql> show schemas;
mysql> use webappdb;
mysql> show tables;
mysql> select * from user;
```

---
## Step-09: Verify the Container to Container communication using Service Names using DNS
```bash
# List running Docker containers
docker compose ps

# Connect to ums-app container
docker exec -it ums-app /bin/bash

# Test DNS - myumsapp
nslookup <SERVICE-NAME>
nslookup myumsapp
dig myumsapp

# Test DNS - mysql
nslookup <SERVICE-NAME>
nslookup mysql
dig mysql
```

---
## Step-10: Stop and Clean Up

When you're done, stop and remove the running containers:

```bash
# Stop and remove the containers
docker compose down
```

To remove the MySQL volume as well (optional):

```bash
# Stop containers and remove volumes
docker compose down -v

# List Docker volumes to confirm removal
docker volume ls
```

**Observation**: The command `docker compose down -v` removes both the containers and the named volume `mydb`, thus deleting the persistent data.

---

## Conclusion

In this tutorial, we successfully deployed a **MySQL database** and a **User Management WebApp** using Docker Compose. We configured the MySQL database for persistent storage and connected the WebApp to interact with it. This setup can be scaled or extended with additional services.

---

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Hub Image](https://hub.docker.com/_/mysql)
- [User Management WebApp Docker Image](https://github.com/users/stacksimplify/packages/container/package/usermgmt-webapp-v6)
- [Docker Volume Management](https://docs.docker.com/storage/volumes/)
- [Docker Networking](https://docs.docker.com/network/)

---

**Happy Dockerizing!**