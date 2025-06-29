root@srv24:~# mkdir glpi && cd glpi

root@srv24:~/glpi# nano mariadb.env

```sh
MARIADB_ROOT_PASSWORD=diouxx
MARIADB_DATABASE=glpidb
MARIADB_USER=glpi_user
MARIADB_PASSWORD=glpi
``` 

root@srv24:~/glpi# nano docker-compose.yml

```sh
version: "3.2"

services:
  # MariaDB Container
  mariadb:
    image: mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    volumes:
      - ./mariadb_data:/var/lib/mysql
    env_file:
      - ./mariadb.env
    restart: always

  # GLPI Container
  glpi:
    image: diouxx/glpi
    container_name: glpi
    hostname: glpi
    ports:
      - "80:80"
    volumes:
      - ./glpi_data:/var/www/html/glpi
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      - TIMEZONE=Europe/Brussels
    restart: always
    depends_on:
      - mariadb
```

root@srv24:~/glpi# docker-compose up -d

root@srv24:~/glpi# hostname -I

```sh
http://192.168.129.162 
```

```sh
mariadb

glpi_user

glpi
``` 

root@glpi:~/glpi# rm glpi_data/install/install.php

# https://github.com/glpi-project/glpi-agent/releases


```sh
http://localhost:62354/
```

```sh
wget https://github.com/glpi-project/glpi-agent/releases/download/1.12/glpi-agent-1.12-x86_64.AppImage

chmod +x glpi-agent-1.12-x86_64.AppImage

sudo apt update
sudo apt install fuse libfuse2 -y
sudo modprobe fuse

sudo ./glpi-agent-1.12-x86_64.AppImage --install --server http://192.168.129.195/

sudo glpi-agent
```

