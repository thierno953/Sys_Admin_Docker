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
version: "3.8"

volumes:
  nextcloud-data:
  nextcloud-db:
  npm-data:
  npm-ssl:
  npm-db:

networks:
  frontend:
  backend:
  onlyoffice_net:

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
      - backend   # ← permet la communication avec Nextcloud
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
docker exec -it onlyoffice_nextcloud-app_1 /bin/bash
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

# Intégrer Onlyoffice à Nextcloud (tunnel Cloudflare)

- Quelque chose de très important est de définir le TOKEN pour pouvoir se connecter avec succès à Nextcloud, dans ce champ n'oubliez pas de mettre run secure TOKEN :

```sh
- JWT_SECRET=SuperSecretoToken
```

- Une fois cette étape terminée, nous allons passer à la configuration de Cloudflare

- Nous exécutons cette commande pour la communication entre les conteneurs :

![Nextcloud](/nextcloud/assets/only.png)

#### Cloudflare

- Nous sommes situés dans le tunnel de notre domaine créé dans le tutoriel précédent et ajoutons un nom d'hôte public.

![Cloudflare](/nextcloud/assets/cloudflare_01.png)

- Dans mon cas, j'ai mis ces données, mais vous pouvez mettre le sous-domaine et le domaine que vous souhaitez, ce qui ne change pas, c'est le service HTTP et votre IP locale avec le port : 8080

![Cloudflare](/nextcloud/assets/cloudflare_02.png)

- On économise et ce serait tout pour le tunnel

#### Nginx

- Dans Nginx, lors de l'ajout d'un nouveau proxy, cela ressemblerait à ceci

![Cloudflare](/nextcloud/assets/cloudflare_03.png)

```sh
Scheme: http
Forward Hostanem / IP: onlyoffice
Forward Port: 8080
```

- Le domaine que vous avez créé pour ce cas.

- Nous pouvons également activer SSL

![Cloudflare](/nextcloud/assets/cloudflare_04.png)

- Et en avance nous avons mis ce texte ;

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

- Nous sauvegardons, même si nous obtenons une erreur, et que nous sauvegardons à nouveau, il sera créé.

- Il est désormais accessible sur la voie publique avec votre domaine en https

#### Nextcloud

- Évidemment, nous devons d’abord être connectés à notre nextcloud :

![Nextcloud](/nextcloud/assets/nextcloud_01.png)

- Ensuite, nous allons dans notre profil et sélectionnons Applications :

- Nous sommes situés dans « Applications en vedette »

![Nextcloud](/nextcloud/assets/nextcloud_02.png)

- Et dans la loupe, nous mettons onlyoffice et appuyons sur Entrée, puis cliquons et appuyons sur le bouton Télécharger et Activer :

![Nextcloud](/nextcloud/assets/nextcloud_03.png)

- Passons maintenant aux paramètres d'administration

- Maintenant, nous allons sur Onlyoffice, mettons le domaine que nous avons créé et allons dans Paramètres avancés

- Nous mettons maintenant ces informations dans ces champs :

![Nextcloud](/nextcloud/assets/nextcloud_04.png)

- Pour mon exemple, ce serait comme ça :

- Adresse des documents ONLYOFFICE : `https://onlyoffice.diarabaka.com/`

- Clé secrète (laisser vide ou désactiver) : SuperSecretToken

- En-tête d'authentification (laissez vide pour utiliser l'en-tête par défaut) : Autorisation

- Adresse des documents ONLYOFFICE pour les requêtes internes du serveur : `http://onlyoffice/`

- Adresse du serveur pour les requêtes internes ONLYOFFICE Docs : `https://cloud.diarabaka.com/`

- Avant de sauvegarder, nous devons faire cette configuration :

#### NB: Nextcloud avec OnlyOffice

- N'oubliez pas d'exécuter cette commande pour la communication :

```sh
docker inspect onlyoffice | grep -i network
docker network disconnect onlyoffice_backend onlyoffice
docker network connect onlyoffice_backend onlyoffice
docker network inspect onlyoffice_backend
```

- Nous pouvons maintenant enregistrer avec succès et nous pourrons ouvrir OnlyOffice dans Nextcloud, n'oublions pas de sélectionner le format des documents que nous voulons ouvrir dans Nextcloud

![Nextcloud](/nextcloud/assets/nextcloud_05.png)
