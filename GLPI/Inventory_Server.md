# Installing OSS Inventory Server on Ubuntu 24.04 with Docker

### OCS Inventory repository

- Here is the link to the OCS Inventory repository: [https://github.com/OCSInventory-NG/OCSInventory-Docker-Image](https://github.com/OCSInventory-NG/OCSInventory-Docker-Image)

### clone the repo:

```sh
sudo git clone https://github.com/OCSInventory-NG/OCSInventory-Docker-Image.git
```

### Navigate inside the downloaded folder:

```sh
cd OCSInventory-Docker-Image
cd 2.12.3
```

### Edit the Docker configuration file:

```sh
sudo nano docker-compose.yml
```

### Change where the port is exposed by uncommenting/modifying this section:

```sh
#expose:
#  - "3306"

ports:
  - "3306:3306"
```

### Run the container

- To start the container, use this command:

```sh
sudo docker-compose up -d
```

### Web Interface

- Enter your device’s IP in a browser; it will redirect you automatically.

- Default username and password are:

```sh
admin
admin
```

- Agent download page: [https://ocsinventory-ng.org/?page_id=1548&lang=en](https://ocsinventory-ng.org/?page_id=1548&lang=en)
