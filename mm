```sh
/opt/nextcloud/
├── docker-compose.yml
└── config/             ← créé automatiquement par Nextcloud
```

```sh
cd /opt
mkdir nextcloud && cd nextcloud
```

```sh
nano /opt/nextcloud/.env
```

```sh
# Nextcloud DB
MYSQL_ROOT_PASSWORD=superSecureRootPassword
MYSQL_PASSWORD=superSecureUserPassword
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud

# Nginx Proxy Manager DB
NPM_MYSQL_ROOT_PASSWORD=superSecureNpmRootPassword
NPM_MYSQL_PASSWORD=superSecureNpmUserPassword
NPM_MYSQL_DATABASE=npm
NPM_MYSQL_USER=npm
```

```sh
root@server24:/opt/nextcloud# nano docker-compose.yml
```

```sh
version: "3.8"

volumes:
  nextcloud-data:
  nextcloud-db:
  nextcloud-config:
  nextcloud-apps:
  npm-data:
  npm-ssl:
  npm-db:

networks:
  frontend:
  backend:

services:
  nextcloud-app:
    image: nextcloud
    restart: always
    depends_on:
      - nextcloud-db
      - redis
    volumes:
      - nextcloud-data:/var/www/html/data
      - nextcloud-config:/var/www/html/config
      - nextcloud-apps:/var/www/html/custom_apps
    environment:
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_HOST=nextcloud-db
    networks:
      - frontend
      - backend

  nextcloud-db:
    image: mariadb:10.11
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    volumes:
      - nextcloud-db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
    networks:
      - backend

  redis:
    image: redis:alpine
    restart: always
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
      - DB_MYSQL_USER=${NPM_MYSQL_USER}
      - DB_MYSQL_PASSWORD=${NPM_MYSQL_PASSWORD}
      - DB_MYSQL_NAME=${NPM_MYSQL_DATABASE}
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
      - MYSQL_ROOT_PASSWORD=${NPM_MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${NPM_MYSQL_DATABASE}
      - MYSQL_USER=${NPM_MYSQL_USER}
      - MYSQL_PASSWORD=${NPM_MYSQL_PASSWORD}
    volumes:
      - npm-db:/var/lib/mysql
    networks:
      - backend
```

```sh
root@server24:/opt/nextcloud# docker-compose pull && docker-compose up -d
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
<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'trusted_domains' =>
  array (
    0 => 'cloud.diarabaka.com',
    1 => '192.168.129.162',
  ),
  'overwrite.cli.url' => 'https://cloud.diarabaka.com',
  'overwritehost' => 'cloud.diarabaka.com',
  'overwriteprotocol' => 'https',
  'upgrade.disable-web' => true,
  'instanceid' => 'ocqm0dcwkhjq',
  'passwordsalt' => 'Z93u3UObCMVA1e0ciMuMD/FZn56Yde',
  'secret' => 'pgRSSbYUxdqatARz/l+tyWC40wUV6XDuVe60ZqoYXMekgILw',
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '31.0.6.2',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'superSecureUserPassword',
  'installed' => true,
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' =>
  array (
    'host' => 'redis',
    'port' => 6379,
  ),
  'maintenance_window_start' => 2,
  'default_phone_region' => 'BE',
  'maintenance' => false,
);
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
