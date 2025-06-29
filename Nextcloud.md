```sh
cd /opt
mkdir nextcloud && cd nextcloud
```

```sh
root@server24:/opt/nextcloud# nano docker-compose.yml
```

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

```sh
root@server24:/opt/nextcloud# docker-compose up -d
root@server24:/opt/nextcloud# hostname -I
```

```sh
http://<IP_DU_SERVEUR>:81
Email : admin@example.com
Password : changeme
```

```sh
https://nextcloud.example.com
```

```sh
root@server24:/opt/nextcloud# docker exec -it nextcloud_nextcloud-app_1 /bin/bash
root@5746251eb547:/var/www/html# apt update && apt install -y nano
```

```sh
root@5746251eb547:/var/www/html# nano config/config.php
```

```sh
'overwriteprotocol' => 'https',
```



```sh
docker restart nextcloud-app
```

```sh
location /.well-known/carddav {
    return 301 https://$host/remote.php/dav;
}

location /.well-known/caldav {
    return 301 https://$host/remote.php/dav;
}

location ^~ /.well-known {
    return 301 https://$host/index.php$uri;
}

add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
```

```sh
https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html
```

```sh
root@srv24:/opt/nextcloud# docker exec -u www-data -it nextcloud_nextcloud-app_1 php occ maintenance:repair --include-expensive
```