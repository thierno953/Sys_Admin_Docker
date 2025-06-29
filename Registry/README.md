- Un registre Docker privé permet de partager des images Docker au sein d'une organisation ou pour un projet spécifique. Cela offre une indépendance vis-à-vis de Docker Hub et permet d'héberger un nombre illimité d'images privées. Par défaut, Docker Hub ne permet qu'une seule image privée gratuite. Cette démarche s'inscrit dans une logique de souveraineté numérique.

- Un registre Docker est un espace de stockage virtuel où vous pouvez publier vos images avec la commande `docker push <image>`, et les exécuter avec les commandes `docker pull <image>` ou `docker run <image>`.

## 1 - Installation de l'environnement

#### Création des répertoires nécessaires

```sh
mkdir -p docker-registry/{certs,auth,data} && cd docker-registry
```

#### Configuration de l'authentification

- Création d'un fichier htpasswd pour gérer l'authentification de base

```sh
cd auth
docker run --entrypoint htpasswd httpd -Bbn thiernos devops > htpasswd
```

#### Installation et configuration du registre Docker privé

- Génération des certificats SSL

```sh
cd ../certs

# Lorsque vous êtes invité à entrer le "Common Name", utilisez le FQDN ou l'adresse IP de votre serveur, par exemple : debian.monlab.local
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 -keyout docker-registry.key -out docker-registry.crt
```

- Lancement du registre Docker avec les configurations nécessaires.

```sh
cd ..

docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -v "$(pwd)"/certs:/certs \
  -v "$(pwd)"/data:/var/lib/registry \
  -e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/docker-registry.crt" \
  -e "REGISTRY_HTTP_TLS_KEY=/certs/docker-registry.key" \
  registry
```

#### Connexion au registre local

- Authentification au registre Docker local.

```sh
docker login localhost:5000

# Utilisateur : thiernos
# Mot de passe : devops
```

- Vérification de l'accès au registre

```sh
curl --insecure -X GET -u thiernos:devops https://localhost:5000/v2/_catalog
```

- Tester le registre avec une image Docker

```sh
docker pull alpine
docker tag alpine localhost:5000/myalpine
docker push localhost:5000/myalpine
```

- Vérification des images dans le registre

```sh
curl --insecure -X GET -u thiernos:devops https://localhost:5000/v2/_catalog
```

#### Connexion à distance au registre

- Résolution de l'erreur x509: cannot validate certificate
  - Pour permettre à Docker de se connecter à un registre avec un certificat auto-signé, vous devez configurer Docker pour accepter les registres non sécurisés.

```sh
sudo nano /etc/docker/daemon.json
```

- Ajoutez ou modifiez le fichier daemon.json comme suit

```sh
{
  "insecure-registries" : ["http://<IP>:5000"]
}
```

- Redémarrez Docker pour appliquer les changements

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker
```

- Authentification au registre distant.

```sh
docker login <IP>:5000
# Utilisateur : thiernos
# Mot de passe : devops
```

- Tester avec une image Docker

```sh
docker pull httpd
docker tag httpd <IP>:5000/myhttpd
docker push <IP>:5000/myhttpd
```

- Vérification des images dans le registre distant

```sh
curl --insecure -X GET -u thiernos:devops https://<IP>:5000/v2/_catalog
```

#### Gestion des images dans le registre

- Suppression d'une image du registre
  - Pour supprimer une image, vous devez supprimer manuellement les fichiers correspondants dans le répertoire data.

```sh
cd docker-registry/data/docker/registry/v2/repositories
rm -rf myhttpd
```

- Redémarrage du registre

```sh
docker restart registry
```

- Retournez au répertoire docker-registry

```sh
cd ~/docker-registry
```

- Créez une archive du répertoire data

```sh
sudo tar -czvf registry-backup.tar.gz data
```

- Vérifiez le contenu de l'archive

```sh
tar -tzvf registry-backup.tar.gz
```

- Pour restaurer l'archive

```sh
sudo tar -xzvf registry-backup.tar.gz -C /chemin/vers/destination
```
