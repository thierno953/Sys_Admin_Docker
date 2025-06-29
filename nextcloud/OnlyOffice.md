# Intégrer Onlyoffice à Nextcloud (tunnel Cloudflare)

#### Déployer le conteneur OnlyOffice

- Nous allons d’abord créer un répertoire à côté de notre Nextcloud

```sh
cd /opt
ls
```

- Nous créons maintenant un répertoire pour onlyoffice

```sh
mkdir onlyoffice
cd onlyoffice/
```

- Une fois dans ce répertoire, nous allons créer notre fichier docker

```sh
nano docker-compose.yml
```

- Nous collons le contenu suivant

```sh
version: "3"
services:
  onlyoffice:
    image: onlyoffice/documentserver
    container_name: onlyoffice
    restart: always
    ports:
      - "8080:80" 
    environment:
      - JWT_ENABLED=true
      - JWT_SECRET=SuperSecretoToken  
    volumes:
      - /opt/onlyoffice/DocumentServer/logs:/var/log/onlyoffice
      - /opt/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data
      - /opt/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice
      - /opt/onlyoffice/DocumentServer/db:/var/lib/postgresql
    networks:
      - onlyoffice_net

networks:
  onlyoffice_net:
    driver: bridge
```

- Quelque chose de très important est de définir le TOKEN pour pouvoir se connecter avec succès à Nextcloud, dans ce champ n'oubliez pas de mettre run secure TOKEN :

```sh
- JWT_SECRET=SuperSecretoToken 
```

- Nous sauvegardons et exécutons le conteneur

```sh
docker-compose up -d
hostname -I
```

- Une fois cette étape terminée, nous allons passer à la configuration de Cloudflare

- Nous exécutons cette commande pour la communication entre les conteneurs :

```sh
docker network connect nextcloud_backend onlyoffice
```

#### Cloudflare