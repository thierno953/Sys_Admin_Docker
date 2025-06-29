# Installation d'OSS Inventory Server sur Ubuntu 24.04 avec Docker

#### Mettons à jour nos référentiels système :

```sh
sudo apt update
```

#### Ensuite, nous installons git

```sh
sudo apt install git
```

#### Maintenant, nous installons Docker

```sh
sudo apt install docker.io
```

#### Nous installons docker-compose

```sh
sudo apt install docker-compose
```

#### Référentiel d'inventaire OCS

- Voici le lien vers le référentiel d'inventaire OCS: `https://github.com/OCSInventory-NG/OCSInventory-Docker-Image`

#### Dans notre console :

```sh
sudo git clone https://github.com/OCSInventory-NG/OCSInventory-Docker-Image.git
```

#### Nous naviguons maintenant à l’intérieur du fichier téléchargé :

```sh
cd OCSInventory-Docker-Image
cd 2.12.3
```

- Nous éditons le fichier de configuration Docker

```sh
sudo nano docker-compose.yml
```

- Nous changeons maintenant l'endroit où nous exposons ce qui suit :

```sh
#expose:
#  - "3306"

ports:
  - "3306:3306"
```

#### Exécuter le conteneur

- Pour soulever le conteneur, nous utilisons cette commande :

```sh
sudo docker-compose up -d
```

#### Interface Web

- Nous entrons l'IP de l'appareil dans le navigateur et il nous redirigera automatiquement.
- Le nom d'utilisateur et le mot de passe par défaut sont :

```sh
admin
admin
```

- La page de téléchargement de l'agent: `https://ocsinventory-ng.org/?page_id=1548&lang=en`
