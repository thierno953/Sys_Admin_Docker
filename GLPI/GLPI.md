# Installer GLPI avec Docker + Ubuntu GLPI Agent

#### Nous installons d’abord Docker et Docker Compose

```sh
apt update
apt install docker.io docker-compose
```

#### Nous créons le répertoire glpi et y accédons

```sh
mkdir glpi
cd glpi
```

#### Nous créons le fichier mariadb.env

```sh
nano mariadb.env
```

```sh
MARIADB_ROOT_PASSWORD=diouxx
MARIADB_DATABASE=glpidb
MARIADB_USER=glpi_user
MARIADB_PASSWORD=glpi
```

#### Nous créons maintenant le fichier docker-compose.yml

```sh
nano docker-compose.yml
```

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

#### Maintenant, nous exécutons le conteneur

```sh
docker-compose up -d
```

- Pour voir l'IP de notre équipe

```sh
hostname -I
```

#### Données d'installation pour cet exemple

```sh
mariadb

glpi_user

glpi
```

#### Répertoire où se trouvent tous les fichiers GLPI

```sh
glpi_data
```

#### Sécurisation de GLPI && Supprimer le script d’installation

```sh
sudo rm -fr glpi/glpi_data/install/install.php
```

- Lien vers l'agent GLPI: `https://github.com/glpi-project/glpi-agent/releases`

#### URL de l'agent informatique Windows :

`http://localhost:62354/`

#### Étapes Linux

```sh
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-x86_64.AppImage

chmod +x glpi-agent-1.15-x86_64.AppImage

sudo apt update
sudo apt install fuse libfuse2 -y
sudo modprobe fuse

sudo ./glpi-agent-1.15-x86_64.AppImage --install --server http://<IP_GLPI_SERVER>/

sudo glpi-agent
```

- Documentation officielle: `https://hub.docker.com/r/diouxx/glpi`
