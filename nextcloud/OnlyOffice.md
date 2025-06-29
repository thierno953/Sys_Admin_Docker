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
docker inspect onlyoffice | grep -i network
docker network connect nextcloud_backend onlyoffice
```

#### Cloudflare

- Nous sommes situés dans le tunnel de notre domaine créé dans le tutoriel précédent et ajoutons un nom d'hôte public

![onlyoffice](/nextcloud/assets/01-onlyoffice.png)

- Dans mon cas, j'ai mis ces données, mais vous pouvez mettre le sous-domaine et le domaine que vous souhaitez, ce qui ne change pas, c'est le service HTTP et votre IP locale avec le port : 8080

![onlyoffice](/nextcloud/assets/02-onlyoffice.png)

- On économise et ce serait tout pour le tunnel

#### Nginx

- Dans Nginx, lors de l'ajout d'un nouveau proxy, cela ressemblerait à ceci

```sh
Scheme: http
Forward Hostanem / IP: onlyoffice
Forward Port: 8080
```

- Le domaine que vous avez créé pour ce cas.

- Nous pouvons également activer SSL

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

- Ensuite, nous allons dans notre profil et sélectionnons Applications :

- Nous sommes situés dans « Applications en vedette »

- Et dans la loupe, nous mettons onlyoffice et appuyons sur Entrée, puis cliquons et appuyons sur le bouton Télécharger et Activer :

- Passons maintenant aux paramètres d'administration

- Maintenant, nous allons sur Onlyoffice, mettons le domaine que nous avons créé et allons dans Paramètres avancés

- Nous mettons maintenant ces informations dans ces champs :

- Pour mon exemple, ce serait comme ça :

- Adresse des documents ONLYOFFICE : `https://onlyoffice.disco-solar.com/`

- Clé secrète (laisser vide ou désactiver) : SuperSecretToken

- En-tête d'authentification (laissez vide pour utiliser l'en-tête par défaut) : Autorisation

- Adresse des documents ONLYOFFICE pour les requêtes internes du serveur : `http://onlyoffice/`

- Adresse du serveur pour les requêtes internes ONLYOFFICE Docs : `https://cloud2.disco-solar.com/`

- Avant de sauvegarder, nous devons faire cette configuration :

#### NB: Nextcloud avec OnlyOffice

- N'oubliez pas d'exécuter cette commande pour la communication :

```sh
docker network connect nextcloud_backend onlyoffice
```

- Nous pouvons maintenant enregistrer avec succès et nous pourrons ouvrir OnlyOffice dans Nextcloud, n'oublions pas de sélectionner le format des documents que nous voulons ouvrir dans Nextcloud
