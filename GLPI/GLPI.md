# Install GLPI with Docker + Ubuntu GLPI Agent

### Create the glpi-server directory and navigate into it

```sh
mkdir glpi-server && cd glpi-server
```

### Create the docker-compose.yml file

```sh
nano docker-compose.yml
```

```sh
version: '3.7'

services:
  db:
    image: mariadb:10.5
    container_name: glpi_db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: glpi_db
      MYSQL_USER: glpi_db_user
      MYSQL_PASSWORD: glpi_db_PWD
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - ./storage/mysql:/var/lib/mysql
    networks:
      - glpi_net

  glpi:
    image: glpi/glpi:latest
    container_name: glpi_web
    restart: unless-stopped
    depends_on:
      - db
    ports:
      - "8081:80"
    environment:
      TIMEZONE: Europe/Brussels
    volumes:
      - ./storage/glpi:/var/glpi
    networks:
      - glpi_net

networks:
  glpi_net:
```

### Run the containers

```sh
docker-compose up -d
```

- To check the IP address of your machine:

```sh
hostname -I
```

### Installation credentials for this example

```sh
Database: db

Username: glpi_db_user

Password: glpi_db_PWD
```

### Directory containing all GLPI files

```sh
glpi_db
```

### Secure GLPI & remove the installation script

```sh
docker exec -it glpi_web bash

cd install
ls -l
mv install.php install.php_bak
```

- Link to the GLPI agent releases: [https://github.com/glpi-project/glpi-agent/releases](https://github.com/glpi-project/glpi-agent/releases)

### Windows IT Agent URL: `http://localhost:62354/`

### Linux Agent Setup

```sh
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-x86_64.AppImage

chmod +x glpi-agent-1.15-x86_64.AppImage

sudo apt update
sudo apt install fuse libfuse2 -y
sudo modprobe fuse

sudo ./glpi-agent-1.15-x86_64.AppImage --install --server http://<IP_GLPI_SERVER>/

sudo glpi-agent
```

- Official documentation: [https://hub.docker.com/r/diouxx/glpi](https://hub.docker.com/r/diouxx/glpi)
