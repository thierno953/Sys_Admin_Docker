#### Création d'un site web simple

- Créez un répertoire dans le dossier personnel de l'utilisateur thierno

```sh
mkdir -p /home/thierno/website/
```

- Ajoutez une page HTML avec un message basique dans ce répertoire

```sh
echo "<h1>Hello index</h1>" > /home/thierno/website/index.html
```

#### Déploiement d'un serveur web avec Docker

- Lancement d'un conteneur Apache avec Docker
  - Utilisez l'image officielle Apache HTTP Server (httpd:2.4) pour déployer un serveur web qui sert votre fichier HTML

```sh
docker run -dit --name thierno-web -p 80:80 -v /home/thierno/website/:/usr/local/apache2/htdocs/ httpd:2.4
```

- Arrêter tous les conteneurs Docker

```sh
docker stop $(docker ps -a -q)
```

- Supprimer tous les conteneurs Docker

```sh
docker rm $(docker ps -a -q)
```
