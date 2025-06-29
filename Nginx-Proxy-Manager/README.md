- Guide pour l'utilisation de Nginx Proxy Manager: https://nginxproxymanager.com/guide/

```sh
docker network create nginx_proxy_network
docker network ls
docker network inspect nginx_proxy_network
docker network connect nginx_proxy_network nginxproxymanager-app-1
docker network connect nginx_proxy_network pruebanginx-web-1
ss -tuln
```
