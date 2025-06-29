```sh
root@server24:/opt# mkdir onlyoffice && cd onlyoffice
``` 

```sh
root@server24:/opt/onlyoffice# nano docker-compose.yml
```

```sh
version: "3"
services:
  onlyoffice:
    image: onlyoffice/documentserver
    container_name: onlyoffice
    restart: always
    ports:
      - "8080:80"  # Exponiendo el servicio en el puerto 8080
    environment:
      - JWT_ENABLED=true
      - JWT_SECRET=SuperSecretoToken  # Cambia esto por una clave segura
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

```sh
- JWT_SECRET=SuperSecretoToken  # Cambia esto por una clave segura
```

```sh
root@server24:/opt/onlyoffice# docker-compose up -d
root@server24:/opt/onlyoffice# hostname -I
```

```sh
docker network connect nextcloud_backend onlyoffice
```

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