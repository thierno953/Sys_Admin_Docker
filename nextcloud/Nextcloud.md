# Cloud privé avec Nextcloud (HTTPS, Cloudflare, Nginx et Docker)

#### Nous allons sur ce chemin et créons ce répertoire :

```sh
cd /opt

mkdir nextcloud
cd nextcloud
```

#### Nous avons créé ce fichier

```sh
nano docker-compose.yml
```

#### Avec ce contenu

```sh
version: "3"
volumes:
  nextcloud-data:
  nextcloud-db:
  npm-data:
  npm-ssl:
  npm-db:

networks:
  frontend:
    # add this if the network is already existing!
    # external: true
  backend:

services:
  nextcloud-app:
    image: nextcloud
    restart: always
    volumes:
      - nextcloud-data:/var/www/html
    environment:
      - MYSQL_PASSWORD=replace-with-secure-password
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=nextcloud-db
    networks:
      - frontend
      - backend

  nextcloud-db:
    image: mariadb
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    volumes:
      - nextcloud-db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=replace-with-secure-password
      - MYSQL_PASSWORD=replace-with-secure-password
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
    networks:
      - backend

  npm-app:
    image: jc21/nginx-proxy-manager:latest
    restart: always
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    environment:
      - DB_MYSQL_HOST=npm-db
      - DB_MYSQL_PORT=3306
      - DB_MYSQL_USER=npm
      - DB_MYSQL_PASSWORD=replace-with-secure-password
      - DB_MYSQL_NAME=npm
    volumes:
      - npm-data:/data
      - npm-ssl:/etc/letsencrypt
    networks:
      - frontend
      - backend

  npm-db:
    image: jc21/mariadb-aria:latest
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=replace-with-secure-password
      - MYSQL_DATABASE=npm
      - MYSQL_USER=npm
      - MYSQL_PASSWORD=replace-with-secure-password
    volumes:
      - npm-db:/var/lib/mysql
    networks:
      - backend
```

#### Nous démarrons le conteneur

```sh
docker-compose up -d
```

#### Du côté de nginx, ce serait l'IP locale de votre ordinateur avec le port 81

```sh
http://<IP>:81
```

#### Ce sont les informations d'identification par défaut

```sh
admin@example.com
changeme
```

#### Pour entrer dans le conteneur et faire quelques ajustements

```sh
docker exec -it nextcloud_nextcloud-app_1 /bin/bash
```

#### Nous allons maintenant éditer le fichier avec cette commande

```sh
nano config/config.php
```

#### Et nous ajoutons cette ligne

```sh
'overwriteprotocol' => 'https',
```

#### Ce code permet d'utiliser Nextcloud dans des applications de bureau ou mobiles

```sh
location /.well-known/carddav {
    return 301 $scheme://$host/remote.php/dav;
}

location /.well-known/caldav {
    return 301 $scheme://$host/remote.php/dav;
}

location ^~ /.well-known {
    return 301 $scheme://$host/index.php$uri;
}
```

#### La source de ce code se trouve dans la documentation officielle de Nextcloud, vous pouvez la vérifier ici :

```sh
https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html
```
