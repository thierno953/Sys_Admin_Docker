# Installer GLPI avec Docker + Ubuntu GLPI Agent

#### Créons le répertoire glpi et y accédons

```sh
mkdir glpi-server && cd glpi-server
```

#### Nous créons maintenant le fichier docker-compose.yml

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
db

glpi_db_user

glpi_db_PWD
```

#### Répertoire où se trouvent tous les fichiers GLPI

```sh
glpi_db
```

#### Sécurisation de GLPI && Supprimer le script d’installation

```sh
docker exec -it glpi_web bash

cd install
ls -l
mv install.php install.php_bak
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
