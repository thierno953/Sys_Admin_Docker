# Configuration de Docker Compose avec SSL/TLS

docker-compose.yml

```sh
version: "3.8"

services:
  ftpd_server:
    image: stilliard/pure-ftpd
    container_name: pure-ftpd
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - "/home/thierno/ftp:/home/thierno"
      - "/etc/ssl/private:/etc/ssl/private"
      - "/var/log/pure-ftpd:/var/log" # Volume pour conserver les logs Pure-FTPd
    environment:
      FTP_USER_NAME: ${FTP_USER_NAME}
      FTP_USER_PASS: ${FTP_USER_PASS}
      FTP_USER_HOME: ${FTP_USER_HOME}
      TLS: 1
    restart: always

networks:
  default:
    driver: bridge
```

- Et ajoutez un fichier .env contenant vos variables sensibles

```sh
FTP_USER_NAME=thierno
FTP_USER_PASS=thierno63
FTP_USER_HOME=/home/thierno
```

# Génération des certificats SSL/TLS

```sh
# Créer le répertoire pour stocker les certificats SSL/TLS (si inexistant)
sudo mkdir -p /etc/ssl/private

# Générer les paramètres Diffie-Hellman (pour renforcer la sécurité des échanges TLS)
sudo openssl dhparam -out /etc/ssl/private/pure-ftpd-dhparams.pem 2048

# Générer un certificat auto-signé (remplacez les valeurs du sujet par vos propres informations)
sudo openssl req -x509 -nodes -newkey rsa:2048 -sha256 \
    -keyout /etc/ssl/private/pure-ftpd.pem \
    -out /etc/ssl/private/pure-ftpd.pem \
    -days 365 \ # Durée de validité du certificat (365 jours ici)
    -subj "/C=FR/ST=State/L=City/O=Organization/CN=ftps.docker.local"

# Appliquer des permissions strictes sur les fichiers PEM (lecture uniquement par root)
sudo chmod 600 /etc/ssl/private/*.pem
```

#### Points importants

- Certificats auto-signés

  - Les certificats auto-signés sont suffisants pour un usage personnel ou interne, mais ils ne sont pas reconnus comme fiables par les navigateurs ou clients FTP.
  - Pour un usage professionnel, utilisez un certificat signé par une autorité de certification (CA) comme Let's Encrypt.

- Nom commun (CN)

  - Le champ CN=ftps.docker.local doit correspondre au nom d'hôte utilisé par vos clients FTP pour se connecter.
  - Si vous utilisez une IP ou un domaine public, remplacez ftps.docker.local par cette valeur.

- Durée de validité

  - Ajustez la durée de validité du certificat (-days 365) selon vos besoins.

- Pour lancer le service en arrière-plan

```sh
docker-compose up -d
```

- Pour vérifier que le conteneur fonctionne correctement

```sh
docker ps
```

- Pour consulter les journaux du conteneur

```sh
docker logs pure-ftpd
```

#### Tests et Connexions

- Connexion via un client FTP avec TLS
  - Utilisez un client comme FileZilla ou WinSCP
  - Configurez le client pour utiliser FTPS (FTP explicite) sur le port 21
  - Entrez les informations suivantes

```sh
Hôte : ftps.docker.local (ou l'IP/DNS public si applicable)
Port : 21
Nom d'utilisateur : thierno
Mot de passe : thierno63
```

#### Vérification des connexions passives

- Assurez-vous que la plage de ports passifs (30000-30009) est accessible depuis le client.
- Si vous utilisez un pare-feu, ouvrez ces ports.

```sh
sudo ufw allow 21/tcp
sudo ufw allow 30000:30009/tcp
```
