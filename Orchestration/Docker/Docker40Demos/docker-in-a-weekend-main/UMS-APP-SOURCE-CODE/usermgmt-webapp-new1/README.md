# User Management Web Application - Docker Image Build Process

## Step-00: Introduction
- Build Multi-platform Docker image for User Management Web Application
- Supports amd64, arm64

## Step-01: Introduction
- **Important Note:** Run `mvn clean package -DskipTests` to generate a WAR file in target folder without unit tests
- We will do that to test the WAR build process to ensure no errors occured
```bash
# Change to Directory 
cd usermgmt-webapp-new1

# Generate WAR file
mvn clean package -DskipTests

### IMPORTANT NOTE:  Without -DskipTests (MySQL DB should be up)
cd mysqldb
docker compose up -d
mvn clean package 
```
## Step-02: Review Dockerfile: Multi-stage Build
- The below dockerfile will create a multi-stage build
- It will build the war file `mvn clean package -DskipTests` and create docker image based on latest code
```Dockerfile
# ums-v6 - 690MB
# First stage: Use the official Tomcat image with OpenJDK 21 for building the project
FROM tomcat:10.1.31-jdk21-temurin-noble AS builder

# Set the frontend to non-interactive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Maven in a single RUN command
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    maven \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the Maven project files to the container
COPY pom.xml .
COPY src ./src

# Build the project and skip tests
RUN mvn clean package -DskipTests	

# Second stage: Use a lighter Tomcat image with JRE for runtime
FROM tomcat:10.1.31-jre21-temurin-noble AS final

# Set the frontend to non-interactive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install all required packages in a single RUN command
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    dnsutils \
    iputils-ping \
    telnet \
    curl \
    mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*	
	
# Remove default web applications from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the builder stage to the Tomcat webapps directory
COPY --from=builder /app/target/usermgmt-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
```

## Step-03: Build and Push Multi-platform Docker Images and push to Docker Hub
```bash
# Login with your Docker ID
docker login

# Build Multi-platform Docker Images
docker buildx build --platform linux/amd64,linux/arm64 -t stacksimplify/usermgmt-webapp-v6:latest --push .
```
## Step-04: Build and Push Multi-platform Docker Images and pusht to GitHub Packages
### Step-04-01: Generate GitHub Personal Access Token (Classic)
```bash
# Github Personal Access Token (GitHub -> Settings -> Developer Settings -> Personal Access Tokens -> Tokens{CLASSIC})
XXXXXXXXXXXXX

# Export your token
export CR_PAT=YOUR_TOKEN
export CR_PAT=XXXXXXXXXXXXX

# Verify Environment Varible
echo $CR_PAT 
```
### Step-04-02: Login to Github Container Registry
```bash
# Using the CLI for your container type, sign in to the Container registry service at ghcr.io.
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Replace USERNAME
echo $CR_PAT | docker login ghcr.io -u stacksimplify --password-stdin
```

### Step-04-03: Build and Push Multi-platform Docker Images and pusht to GitHub Packages
```bash
# Login with your Docker ID
docker login

# Build Multi-platform Docker Images
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/stacksimplify/usermgmt-webapp-v6:latest --push .
```

## Step-05: Run using Docker Compose
### Step-05-01: docker-compose.yaml
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
      MYSQL_DATABASE: webappdb
    ports:
      - "3306:3306"
    volumes:
      - mydb:/var/lib/mysql
volumes:
  mydb:
```
### Step-05-02: Docker Compose
```bash
# Docker Compose up 
docker compose up
## [OR]
# Docker Compose up - Run in detach mode
docker compose up -d  

# Docker compose down
docker compose down
```






## Legacy or OLD References: To Build Docker Image manually using mvn command
- **OLD SETUP:**  Build docker image using mvn command
```t
# Build Docker Image
mvn spring-boot:build-image
```
