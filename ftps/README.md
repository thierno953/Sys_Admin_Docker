# Docker Compose Configuration with SSL/TLS

```sh
nano docker-compose.yml
```

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
      - "/home/master01/ftp:/home/master01"
      - "/etc/ssl/private:/etc/ssl/private"
    environment:
      FTP_USER_NAME: master01
      FTP_USER_PASS: master0163
      FTP_USER_HOME: /home/master01
      TLS: "1"
      PUBLICHOST: "192.168.129.220"
    restart: always

networks:
  default:
    driver: bridge
```

### Generating SSL/TLS Certificates

```sh
# Create directory for storing SSL/TLS certificates (if it doesn't exist)
sudo mkdir -p /etc/ssl/private

# Generate Diffie-Hellman parameters (to strengthen TLS exchanges security)
sudo openssl dhparam -out /etc/ssl/private/pure-ftpd-dhparams.pem 2048

# Generate a self-signed certificate (replace subject values with your own info)
sudo openssl req -x509 -nodes -newkey rsa:2048 -sha256 \
    -keyout /etc/ssl/private/pure-ftpd.pem \
    -out /etc/ssl/private/pure-ftpd.pem

# Apply strict permissions on PEM files (readable only by root)
sudo chmod 600 /etc/ssl/private/*.pem
```

```sh
docker-compose up -d
```

- To check if the container is running properly:

```sh
docker ps
```

- To view the container logs:

```sh
docker logs pure-ftpd
```

### Testing and Connecting

```sh
Host: <IP> (or public IP/DNS if applicable)
Port: 21
Username: master01
Password: master0163
```

### Verifying Passive Connections

```sh
sudo ufw allow 21/tcp
sudo ufw allow 30000:30009/tcp
```
