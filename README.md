# 🐳 Inception Project

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-%23117AC9.svg?style=for-the-badge&logo=WordPress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)

## 📋 Overview

This project implements a complete web infrastructure using Docker containerization technology. It sets up a fully-functional WordPress website with MariaDB as the database backend and Nginx as the web server, all running in separate containers managed via Docker Compose.

## 🏗️ Architecture

The infrastructure consists of three custom Docker containers:

1. **NGINX** - Acts as a web server and TLS termination point
2. **WordPress** - Runs with PHP-FPM for dynamic content
3. **MariaDB** - Provides the database backend

Each component is built from a Debian Bullseye base image and configured to work together in a secure and optimized environment.

## 📂 Project Structure

```
Makefile                # Contains helpful commands for managing the project
srcs/
  ├── docker-compose.yml   # Defines the container relationships
  └── requirements/
      ├── mariadb/         # MariaDB container configuration
      │   ├── Dockerfile
      │   ├── conf/
      │   │   └── my.cnf   # MariaDB configuration
      │   └── tools/
      │       └── init.sh  # Database initialization script
      ├── nginx/           # NGINX container configuration
      │   ├── Dockerfile
      │   └── conf/
      │       └── nginx.conf # NGINX configuration
      └── wordpress/       # WordPress container configuration
          ├── Dockerfile
          ├── config/
          │   └── www.conf # PHP-FPM configuration
          └── tools/
              └── init.sh  # WordPress initialization script
```

## 🔧 Technical Implementation Details

### 1. Docker and Docker Compose

The entire project is containerized using Docker with each service defined in its own Dockerfile. Docker Compose orchestrates the containers, handling networking, volume mounting, and dependency management.

### 2. NGINX Configuration

- Based on Debian Bullseye
- Configured to listen on ports 80 (HTTP) and 443 (HTTPS)
- Implements automatic redirection from HTTP to HTTPS
- TLS 1.3 protocol enforced with self-signed certificates
- Proxies PHP requests to the WordPress container

### 3. WordPress with PHP-FPM

- Based on Debian Bullseye
- PHP 7.4 with FPM for better performance
- WordPress automatically installed and configured using WP-CLI
- Connections to the database handled securely
- Performance optimization for PHP-FPM included

### 4. MariaDB Database

- Based on Debian Bullseye
- Configured for secure remote access
- Database, users, and permissions automatically set up during initialization
- Data persistence through Docker volumes
- Optimized configuration in my.cnf

## 🚀 Setup and Usage

### Prerequisites

- Docker and Docker Compose
- Available ports: 80, 443, 3306, 9000

### Environment Variables

The project uses environment variables stored in a `.env` file (located at `/home/ilyas/Desktop/.secrets/.env`) containing:

- `MYSQL_USER`: Database user
- `MYSQL_PASSWORD`: Database password
- `MYSQL_ROOT_PASSWORD`: Database root password
- `WP_USER`: WordPress admin username
- `WP_PASSWORD`: WordPress admin password

### Commands

The Makefile provides easy-to-use commands:

```
make up      # Build and start all containers
make down    # Stop all containers
make fclean  # Remove all containers and purge Docker system
```

## 💡 Key Features

1. **Security**
   - TLS 1.3 encryption for all HTTPS traffic
   - Restricted PHP functions for better security
   - Proper user permissions in all containers

2. **Performance**
   - PHP-FPM configured for optimal performance
   - MariaDB tuned for WordPress workloads
   - Nginx optimized for static and dynamic content serving

3. **Reliability**
   - Data persistence through Docker volumes
   - Container dependency management
   - Proper initialization scripts ensure services start correctly

4. **Maintainability**
   - Clean separation of concerns with individual containers
   - Well-documented configuration files
   - Easily extensible architecture

## 🌐 Accessing the Website

Once deployed, the WordPress site is available at:
- URL: https://ibenaiss.42.fr
- Admin area: https://ibenaiss.42.fr/wp-admin

## 📊 Volume Management

The project uses Docker volumes for data persistence:
- `/home/ilyas/data/mysql`: MariaDB data directory
- `/home/ilyas/data/wordpress`: WordPress files

These volumes ensure data survives container restarts or rebuilds.

## 🔒 Network Security

All containers communicate over a dedicated Docker bridge network named `inception` which isolates the services from the host's main network.

## 📝 Conclusion

This project demonstrates the implementation of a complete web stack using Docker containerization. It showcases proper isolation of services, secure communication between containers, and maintainable infrastructure as code principles.
